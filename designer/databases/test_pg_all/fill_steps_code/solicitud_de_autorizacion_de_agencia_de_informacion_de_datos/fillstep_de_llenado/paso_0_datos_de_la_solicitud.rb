
  class Paso0DatosDeLaSolicitud < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get( '/consecutive/generador_infordatos/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)

form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.ruc", @owner["tax_id"])
    end

    on_transition do
              #Abogado Litigante
ci = form_data.get("de_acuerdo_a_la_solicitud_mici.de_acuerdo_a_la_solicitud.cedula_litigante")
result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{ci}").parsed_response
datos = result["response"]
if !datos.nil?
    nombre =  "#{datos["primerNombre"]} "+"#{datos["primerApellido"]} "+"#{datos["segundoApellido"]}"
    form_data.set("de_acuerdo_a_la_solicitud_mici.de_acuerdo_a_la_solicitud.nombre_del_abogado", nombre)
else
    transition_errors << "Los datos del abogado no fueron encontrados, por favor verifique.\n"
end

#Empresa
## Chantal Valverde 5-Abr-2017. Para asignar correctamente data de RP y corregir error en logs por fecha cuando viene vacía en el servicio
if @owner["kind_of_user_type"] == "JuridicalPerson"
    _ruc = form_data.get("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.ruc")
    _ti_so = form_data.get("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.tipo_sociedad")
    result = WebserviceConsumer.get( '/service/bdin_registro_publico_empresas/find.json?ruc=' + _ruc +'&tipo_sociedad=' + _ti_so).parsed_response
    emp = result["response"]

    if emp.nil?
        transition_errors << "Los datos de la empresa no fueron encontrados, por favor verifique."
    else
        fecha=emp["fecha_inscripcion"].to_s
        if !fecha.blank?
            if fecha.index("-")==nil 
                fecha.insert(2,"-")
                fecha.insert(5,"-")
            end
        end
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.fecha_de_inscripcion_texto",fecha)
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.tomo",emp["rollo-tomo"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.folio",emp["imagen-folio"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.asiento",emp["asiento"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.domicilio_legal",emp["sociedad_domicilio"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.nombre_comercial",emp["nombre_empresa"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.digito_verificador",emp["digito_verificador"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.apartado_postal",emp["codigo_postal"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.telefono_o_celular",emp["tlf_movil"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.correo_electronico",emp["email"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.provincia",emp["provincia"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.distrito",emp["distrito"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.corregimiento",emp["corregimiento"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.calle_o_avenida",emp["calle"])
        form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.edificio_casa",emp["nro-casa-apto"])
    end
end
## HASTA AQUÍ 5-ABR

     #DATOS DE LA PERSONA QUIEN INICIA EL TRAMITE CUANDO LO HACE POR TERCERA PERSONA
    _person = @application["person_id"]
    _owner = @application["owner_person_id"]

    if _person != _owner
       _idpersona = @application["person_id"].to_s
        result = WebserviceConsumer.get( "/preconfigured_services/get_user_info.xml?person_id=#{_idpersona}&include_all=true").parsed_response
        _hash = result["hash"]
        persona = _hash["response"]

        form_data.set("informacion_de_persona_juridica.representante_legal.cedula",persona["person_gov_id_number"])
        form_data.set("informacion_de_persona_juridica.representante_legal.nombre_completo",persona["name"])
        form_data.set("informacion_de_persona_juridica.representante_legal.email",persona["email"])
        #form_data.set("informacion_de_persona_juridica.representante_legal.numero_de_telefono",persona["fixed_number"])
    end   
## end

##VERIFICACIÒN NUMERO DE CEDULA DEL ABOGADO NO PERTENEZCA A UN DIFUNTO
                            
abogado = form_data.get("de_acuerdo_a_la_solicitud_mici.de_acuerdo_a_la_solicitud.cedula_litigante")   
resultAbo = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{abogado}")).parsed_response
datosAbo = resultAbo["response"]
if datosAbo.blank? 
    transition_errors << "La Cédula del Abogado Legal no fue encontrada. Por favor, verifique." 
else            
    difuntoAbo = datosAbo["mensaje"]
    if (difuntoAbo == "534")
        transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{abogado} corresponde a un ciudadano Difunto."
    end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $(".field-hint").each (function(){
      if ($(this).html().trim() == "Indicar el número de cédula del abogado litigante") {
          $(this).html("Número de Cédula del Abogado");
      }
  });
});

    STEPAJAXCODE
  end
            
