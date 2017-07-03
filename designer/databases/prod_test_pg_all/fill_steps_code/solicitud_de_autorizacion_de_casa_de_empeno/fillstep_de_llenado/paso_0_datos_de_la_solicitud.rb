
  class Paso0DatosDeLaSolicitud < TemplateCode::Step

    on_becoming do
      
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get( '/consecutive/generador_casasempenios/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)

if @owner["kind_of_user_type"] == "JuridicalPerson"

	_ruc = form_data.set("solicitante_juridico.datos_generales_de_empresa.ruc",@owner["tax_id"])

end
    end

    on_transition do
      #Solicitante Jurídico
if @owner["kind_of_user_type"] == "JuridicalPerson"
    #Abogado Litigante
    ci = form_data.get("solicitante_juridico.de_acuerdo_a_la_solicitud.cedula_litigante")
    result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{ci}").parsed_response
    datos = result["response"]
    if !datos.nil?
        difunto = datos["cod_mensaje"]
        if (difunto == "534")
            transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{ci} del Abogado, corresponde a un ciudadano Difunto."
        end
        nombre =  "#{datos["primerNombre"]} "+"#{datos["primerApellido"]} "+"#{datos["segundoApellido"]}"
        form_data.set("solicitante_juridico.de_acuerdo_a_la_solicitud.nombre_del_abogado", nombre)
    else
        transition_errors << "Los datos del abogado no fueron encontrados, por favor verifique.\n"
    end

    #Empresa
    # _ruc = form_data.get("solicitante_juridico.datos_generales_de_empresa.ruc")
    # result = WebserviceConsumer.get( '/service/bdin_registro_publico_empresas/find.json?ruc=' + "#{_ruc}").parsed_response
    # emp = result["response"]
    # if emp.nil?
    #   transition_errors << "Los datos de la empresa no fueron encontrados, por favor verifique."
    # else
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.fecha_de_inscripcion",emp["fecha_inscripcion"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.tomo",emp["rollo-tomo"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.folio",emp["imagen-folio"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.asiento",emp["asiento"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.domicilio_legal",emp["direccion"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.nombre_comercial",emp["nombreComercial"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.digito_verificador",emp["digito_verificador"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.apartado_postal",emp["codigo_postal"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.telefono_o_celular",emp["tlf_movil"])
    #   form_data.set("solicitante_juridico.datos_generales_de_empresa.correo_electronico",emp["email"])
    #   form_data.set("solicitante_juridico.datos_de_ubicacion.provincia",emp["provincia"])
    #   form_data.set("solicitante_juridico.datos_de_ubicacion.distrito",emp["distrito"])
    #   form_data.set("solicitante_juridico.datos_de_ubicacion.corregimiento",emp["corregimiento"])
    #   form_data.set("solicitante_juridico.datos_de_ubicacion.calle_o_avenida",emp["calle"])
    #   form_data.set("solicitante_juridico.datos_de_ubicacion.edificio_casa",emp["nro-casa-apto"])
    # end
end

#Solicitante Natural
if @owner["kind_of_user_type"] == "NaturalPerson"

    #Abogado Litigante
    ci = form_data.get("solicitante_natural.datos_del_abogado_litigante.cedula_litigante")
    
    result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{ci}").parsed_response
    datos = result["response"]
    if !datos.nil?
        difunto = datos["cod_mensaje"]
        if (difunto == "534")
            transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{ci} del Abogado, corresponde a un ciudadano Difunto."
        end

		nombre =  "#{datos["primerNombre"]} "+"#{datos["primerApellido"]} "+"#{datos["segundoApellido"]}"
		form_data.set("solicitante_natural.datos_del_abogado_litigante.nombre_del_abogado", nombre)
	else
		transition_errors << "Los datos del abogado no fueron encontrados, por favor verifique.\n"
	end
        
    #Empresa
#CV    _ruc = form_data.get("solicitante_natural.datos_del_local.ruc")
#CV    result = WebserviceConsumer.get( '/service/bdin_registro_publico_empresas/find.json?ruc=' + "#{_ruc}").parsed_response
#CV    emp = result["response"]
#CV    if emp.nil?
#CV      transition_errors << "Los datos del local no fueron encontrados, por favor verifique."
#CV    else
#CV      direccion =  "#{emp["calle"]} "+",#{emp["nro-casa-apto"]} "+",#{emp["corregimiento"]} "+",#{emp["distrito"]} "+",#{emp["provincia"]}"
        
#CV      form_data.set("solicitante_natural.datos_del_local.nombre_comercial",emp["nombreComercial"])
#CV      form_data.set("solicitante_natural.datos_del_local.digito_verificador",emp["digito_verificador"])
#CV      form_data.set("solicitante_natural.datos_del_local.telefono_o_celular",emp["tlf_movil"])
#CV      form_data.set("solicitante_natural.datos_del_local.correo_electronico",emp["email"])
#CV      form_data.set("solicitante_natural.datos_del_local.apartado_postal",emp["codigo_postal"])
#CV      form_data.set("solicitante_natural.datos_del_local.ubicacion_del_establecimiento_comercial",direccion)
#CV    end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
