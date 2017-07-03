
  class Paso0TipoDeSolicitud < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get( '/consecutive/generador_agendistribucion/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
    end

    on_transition do
      # Chantal Valverde, el trámite sólo inicia para persona natural / Esto se debe mover de paso si fuera necesario
#_ruc = form_data.get("datos_del_establecimiento.datos_de_la_empresa.ruc")
#tipo_s = form_data.get("datos_del_establecimiento.datos_de_la_empresa.tipo_sociedad")
_cedula = form_data.get("datos_del_regente.datos_de_la_persona.cedula")
#_error = nil

#Obtener datos del establecimiento
# if (@owner["kind_of_user_type"] == "JuridicalPerson")
#    result = WebserviceConsumer.get( '/service/bdin_registro_publico_ruc/find.json?ruc=' + _ruc +'&tipo_sociedad=' + tipo_s).parsed_response
#    _establecimiento = result["response"]
# #   if _establecimiento.nil?
# #      _error = "#{_error}" + "El RUC del establecimiento no fue encontrado en la base de datos del Registro Público. Favor verifique."
# #   end
# end

#Obtener datos de la Licencia de Operacion del establecimiento
#result2 = WebserviceConsumer.get( '/service/bdin_registro_publico_datos_operacion/find.json?ruc=' + "#{_ruc}").parsed_response
#_lic_operacion = result2["response"]

##Chantal Valverde 21-Mar-2017
#Obtener datos del regente
result3 = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{_cedula}").parsed_response
_regente = result3["response"]
if _regente.nil?
    transition_errors << "Los datos del regente farmacéutico no fueron encontrados en la base de datos del tribunal electoral. Favor verifique."
else
    difunto = _regente["cod_mensaje"]
    if (difunto == "534")
        transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{_cedula} del Regente, corresponde a un ciudadano Difunto."
    else
        form_data.set("datos_del_regente.datos_de_la_persona.primer_nombre",_regente["primerNombre"])
        form_data.set("datos_del_regente.datos_de_la_persona.primer_apellido",_regente["primerApellido"])
        ### SI LOS DATOS DE SEGUNDO NOMBRE Y SEGUNDO APELLIDO NO VIENEN VACÍOS, SE SETEAN LOS DATOS SINO, NO.
        if _regente["segundoNombre"] != ""
            form_data.set("datos_del_regente.datos_de_la_persona.segundo_nombre",_regente["segundoNombre"])
        end
        if _regente["segundoApellido"] != ""
            form_data.set("datos_del_regente.datos_de_la_persona.segundo_apellido",_regente["segundoApellido"])
        end
        ### FIN VALIDACION
        form_data.set("datos_del_regente.informacion_de_residencia_localizacion.provincia", _regente["provincia"])
        form_data.set("datos_del_regente.informacion_de_residencia_localizacion.distrito", _regente["distrito"])
        form_data.set("datos_del_regente.informacion_de_residencia_localizacion.corregimiento", _regente["corregimiento"])
        #form_data.set("datos_del_regente.informacion_de_residencia_localizacion.direccion", _regente["direccion"])
    end
end
##Hasta aquí Chantal Valverde 21-Mar-2017

# if !_error.nil? 
#     transition_errors << "#{_error}"
# else
#     #Establecimiento
#     form_data.set("datos_del_establecimiento.datos_de_la_empresa.nombre",_establecimiento["nombre_empresa"])
#     form_data.set("datos_del_establecimiento.direccion.provincia", _establecimiento["provincia"])
#     form_data.set("datos_del_establecimiento.direccion.distrito", _establecimiento["distrito"])
#     form_data.set("datos_del_establecimiento.direccion.corregimiento", _establecimiento["corregimiento"])
#     form_data.set("datos_del_establecimiento.direccion.direccion", _establecimiento["sociedad_domicilio"])
#     form_data.set("datos_del_establecimiento.direccion.telefono_de_oficina", _establecimiento["tlf_movil"])
#     form_data.set("datos_del_establecimiento.direccion.numero_de_fax", _establecimiento["tlf_fax"])
#     form_data.set("datos_del_establecimiento.direccion.correo_electronico", _establecimiento["email"]) 
#    # form_data.set("datos_del_establecimiento.registro_de_empresa.licencia_de_operacion", _lic_operacion["nroLicenciaOperacion"])
# end

#::: DV: Modificado el 21/03/2017
# se mueve código del onbecoming del paso 2 al ontransition del paso 1 para validar tribunal electoral
    if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
        _tipo = "Cédula"
        _ci = @owner["national_id"]
        result = WebserviceConsumer.get('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{_ci}").parsed_response
        datos = result["response"]
        if !datos.nil?
            form_data.set("datos_del_solicitante.datos_de_la_persona.cedula",_ci)
            form_data.set("datos_del_solicitante.datos_de_la_persona.primer_nombre",datos["primerNombre"])
            form_data.set("datos_del_solicitante.datos_de_la_persona.segundo_nombre",datos["segundoNombre"])
            form_data.set("datos_del_solicitante.datos_de_la_persona.primer_apellido",datos["primerApellido"])
            form_data.set("datos_del_solicitante.datos_de_la_persona.segundo_apellido",datos["segundoApellido"])
            form_data.set("datos_del_solicitante_persona_natural.nombres_completos.apellido_de_casada",datos["apellidoCasada"])  
            #form_data.set("datos_del_solicitante.informacion_de_residencia_localizacion.direccion",datos["direccionNacimiento"])
        else
            transition_errors << "Los datos del solicitante no fueron encontrados en el sistema de Tribunal Electoral. Por favor verifique" 
        end    
    end
    if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "foreign_citizen"))
        form_data.set("datos_del_solicitante.datos_de_la_persona.pasaporte",@owner["passport"])
        form_data.set("datos_del_solicitante.datos_de_la_persona.primer_nombre",@owner["first_name"])
        form_data.set("datos_del_solicitante.datos_de_la_persona.segundo_nombre",@owner["second_name"])
        form_data.set("datos_del_solicitante.datos_de_la_persona.primer_apellido",@owner["last_name"])
        form_data.set("datos_del_solicitante.datos_de_la_persona.segundo_apellido",@owner["second_last_name"])
        form_data.set("datos_del_solicitante.datos_de_la_persona.apellido_de_casada",@owner["married_name"])
        form_data.set("datos_del_solicitante.informacion_de_residencia_localizacion.direccion",@owner["full_address"])
    end
# end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
