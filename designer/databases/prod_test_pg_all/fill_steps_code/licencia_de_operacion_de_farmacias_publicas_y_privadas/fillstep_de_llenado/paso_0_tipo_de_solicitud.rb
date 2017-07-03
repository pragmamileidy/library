
  class Paso0TipoDeSolicitud < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get( '/consecutive/generador_farpubypriv/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
    end

    on_transition do
      #vdiaz
tipo_s = form_data.get("datos_del_establecimiento.datos_de_la_empresa.tipo_sociedad")
nro_documento = form_data.get("datos_del_establecimiento.datos_de_la_empresa.ruc")
_cedula = form_data.get("datos_del_regente_farmaceutico.datos_de_la_persona.cedula")
#_error = nil

# #LP Comentado por cambios solicitados 27-02-17
# #::: DV: Descomentado por solicitud
# #Obtener datos del establecimiento
# result = WebserviceConsumer.get( '/service/bdin_registro_publico_ruc/find.json?ruc=' + nro_documento +'&tipo_sociedad=' + tipo_s).parsed_response
# _establecimiento = result["response"]
# if _establecimiento.nil?
#   _error = "#{_error}" + "El RUC del establecimiento no fue encontrado en la base de datos del Registro Público. Favor verifique."
# end
# #Termina comentado 27-02-17

# #Obtener datos de la Licencia de Operacion del establecimiento
# # result2 = WebserviceConsumer.get( '/service/bdin_registro_publico_datos_operacion/find.json?ruc=' + "#{_ruc}").parsed_response
# # _lic_operacion = result2["response"]

# #Establecimiento
# form_data.set("datos_del_establecimiento.datos_de_la_empresa.nombre",_establecimiento["nombre_empresa"])
# form_data.set("datos_del_establecimiento.direccion.provincia", _establecimiento["provincia"])
# form_data.set("datos_del_establecimiento.direccion.distrito", _establecimiento["distrito"])
# form_data.set("datos_del_establecimiento.direccion.corregimiento", _establecimiento["corregimiento"])
# form_data.set("datos_del_establecimiento.direccion.direccion", _establecimiento["sociedad_domicilio"])
# form_data.set("datos_del_establecimiento.direccion.numero_de_telefono", _establecimiento["tlf_movil"])
# form_data.set("datos_del_establecimiento.direccion.numero_de_fax", _establecimiento["tlf_fax"])
# form_data.set("datos_del_establecimiento.direccion.correo_electronico", _establecimiento["email"]) 
# #form_data.set("datos_del_establecimiento.registro_de_empresa.licencia_de_operacion", _lic_operacion["nroLicenciaOperacion"])
# # Regente


#Obtener datos del regente
result3 = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{_cedula}").parsed_response
_regente = result3["response"]
if _regente.blank?
  transition_errors << "Los datos del regente farmacéutico no fueron encontrados en la base de datos del tribunal electoral. Favor verifique."
else
  difunto = _regente["cod_mensaje"]
  if (difunto == "534")
    transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{_cedula}, corresponde a un ciudadano Difunto."
  end
  form_data.set("datos_del_regente_farmaceutico.datos_de_la_persona.primer_nombre",_regente["primerNombre"])
  form_data.set("datos_del_regente_farmaceutico.datos_de_la_persona.segundo_nombre",_regente["segundoNombre"])
  form_data.set("datos_del_regente_farmaceutico.datos_de_la_persona.primer_apellido",_regente["primerApellido"])
  form_data.set("datos_del_regente_farmaceutico.datos_de_la_persona.segundo_apellido",_regente["segundoApellido"])
  form_data.set("datos_del_regente_farmaceutico.informacion_de_residencia_localizacion.provincia", _regente["provincia"])
  form_data.set("datos_del_regente_farmaceutico.informacion_de_residencia_localizacion.distrito", _regente["distrito"])
  form_data.set("datos_del_regente_farmaceutico.informacion_de_residencia_localizacion.corregimiento", _regente["corregimiento"])
  #form_data.set("datos_del_regente_farmaceutico.informacion_de_residencia_localizacion.direccion", _regente["direccion"])
end

#VERIFICACIÒN NUMERO DE CEDULA DEL SOLICITANTE NO PERTENEZCA A UN DIFUNTO
if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
    numdoc = @owner["national_id"]
    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
    datosSol = result["response"]
    if datosSol.blank? 
        transition_errors << "La Cédula del Representante no fue encontrada. Por favor, verifique." 
    else            
        difunto = datosSol["cod_mensaje"]
        if (difunto == "534")
            transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{numdoc} corresponde a un ciudadano Difunto."
        end
    end
end

cedu_validacion = form_data.get("datos_del_representante.datos_de_la_persona.cedula")
if cedu_validacion != @owner["national_id"]
    _ci = @owner["national_id"]
    result = WebserviceConsumer.get('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{_ci}").parsed_response
    datos = result["response"]
    if !datos.nil?
        form_data.set("datos_del_representante.datos_de_la_persona.cedula",datos["cedula"])
        form_data.set("datos_del_representante.datos_de_la_persona.primer_nombre",datos["primerNombre"])
        form_data.set("datos_del_representante.datos_de_la_persona.primer_apellido",datos["primerApellido"])
    else
        ### SI LOS DATOS DE SEGUNDO NOMBRE Y SEGUNDO APELLIDO NO VIENEN VACÍOS, SE SETEAN LOS DATOS SINO, NO.
        if datos["segundoNombre"] != ""
            form_data.set("datos_del_representante.datos_de_la_persona.segundo_nombre",datos["segundoNombre"])
        end

        if datos["segundoApellido"] != ""
            form_data.set("datos_del_representante.datos_de_la_persona.segundo_apellido",datos["segundoApellido"])
        end
        ### FIN VALIDACION

        #form_data.set("datos_del_representante.informacion_de_residencia_localizacion.correo_electronico",datos["email"])
        form_data.set("datos_del_representante.informacion_de_residencia_localizacion.direccion",@owner["full_address"])
    end
end
if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "foreign_citizen"))
    form_data.set("datos_del_representante.datos_de_la_persona.pasaporte",@owner["passport"])
    form_data.set("datos_del_representante.datos_de_la_persona.primer_nombre",@owner["first_name"])
    form_data.set("datos_del_representante.datos_de_la_persona.primer_apellido",@owner["last_name"])

    ### SI LOS DATOS DE SEGUNDO NOMBRE Y SEGUNDO APELLIDO NO VIENEN VACÍOS, SE SETEAN LOS DATOS SINO, NO.
    if @owner["second_name"] != ""
        form_data.set("datos_del_representante.datos_de_la_persona.segundo_nombre",@owner["second_name"])
    end

    if @owner["second_last_name"] != ""
        form_data.set("datos_del_representante.datos_de_la_persona.segundo_apellido",@owner["second_last_name"])
    end
    ### FIN VALIDACION

    form_data.set("datos_del_representante.informacion_de_residencia_localizacion.correo_electronico",@owner["email"])
    form_data.set("datos_del_representante.informacion_de_residencia_localizacion.direccion",@owner["full_address"])
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Teléfono*") {
          $(this).html("Número de Teléfono Fijo*");
      }
  });
});

$( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Fax") {
          $(this).html("Número de Teléfono Móvil");
      }
  });
});
    STEPAJAXCODE
  end
            
