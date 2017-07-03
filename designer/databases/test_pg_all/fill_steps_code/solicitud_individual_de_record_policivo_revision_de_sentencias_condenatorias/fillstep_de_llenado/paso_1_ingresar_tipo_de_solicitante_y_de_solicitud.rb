
  class Paso1IngresarTipoDeSolicitanteYDeSolicitud < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
# Datos del Solicitante Natural #
if @owner["kind_of_user_type"] == "NaturalPerson"
	if @owner["natural_person_type"]=="national_citizen"
		nro_documento=@owner["national_id"]
        tipo_documento="Cedula"
    		result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
    		 data = result["response"]
				if data.nil? 
					transition_errors << "Los datos del solicitante no fueron encontrados, por favor verifique."
                else
                	form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento",tipo_documento)
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",data["cedula"])
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre",data["primerNombre"])
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre",data["segundoNombre"])
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido",data["primerApellido"])
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido",data["segundoApellido"])
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada",data["apellidoCasada"])
					form_data.set("datos_del_titular_rp.datos_de_ubicacion.direccion",data["direccionNacimiento"])
					form_data.set("datos_del_titular_rp.datos_del_padre.primer_nombre",data["primerNombrePadre"])
					form_data.set("datos_del_titular_rp.datos_del_padre.primer_apellido",data["apellidoPaternoPadre"])
					form_data.set("datos_del_titular_rp.datos_de_la_madre.primer_nombre",data["primerNombreMadre"])
					form_data.set("datos_del_titular_rp.datos_de_la_madre.primer_apellido",data["apellidoPaternoMadre"])
					form_data.set("datos_del_titular_rp.datos_del_padre.documento_hijo",nro_documento)
					form_data.set("datos_del_titular_rp.datos_de_la_madre.documento_hijo",nro_documento)
					fecha = data["fechaNacimiento"]
					fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_n)

					edad = ((Date.today - fecha_n.to_date).to_f / 365).to_i
					form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.edad",edad)
					
					##### USADO PARA PRINT DESIGN #####
						segundoNombre = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre")
						apellidoCasada = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada")
						_nombre =  "#{data["primerNombre"]} #{segundoNombre} #{data["primerApellido"]} #{data["segundoApellido"]} #{apellidoCasada}"
						form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.nombre_completo",_nombre)

					#######Datos solicitante##########################################

					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.tipo_documento",tipo_documento)
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.cedula_pasaporte",data["cedula"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.primer_nombre",data["primerNombre"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.segundo_nombre",data["segundoNombre"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.primer_apellido",data["primerApellido"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.segundo_apellido",data["segundoApellido"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.apellido_de_casada",data["apellidoCasada"])
					form_data.set("datos_del_solicitante.datos_de_ubicacion.direccion",data["direccionNacimiento"])
					
				end        
		else
			nro_documento=@owner["passport"]
			tipo_documento="Pasaporte"	
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",nro_documento)
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_documento",tipo_documento)
				form_data.set("datos_del_titular_rp.datos_del_padre.documento_hijo",nro_documento)
				form_data.set("datos_del_titular_rp.datos_de_la_madre.documento_hijo",nro_documento)
	end			
end             

# Persona Jurídica #

if  @owner["kind_of_user_type"] == "JuridicalPerson"
    tipo_documento= form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento")
	nro_documento=form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte")
 
	if tipo_documento=="Cedula"
		result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
		data = result["response"]
		if data.blank?
			form_data.set("tipo_de_persona_dij.tipo_de_identificacion.numero_documento","")				
			transition_errors << "Los datos del solicitante, no fueron encontrados, por favor verifique."
		else
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento",tipo_documento)
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",data["cedula"])
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre",data["primerNombre"])
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre",data["segundoNombre"])
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido",data["primerApellido"])
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido",data["segundoApellido"])
				form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada",data["apellidoCasada"])
				form_data.set("datos_del_titular_rp.datos_de_ubicacion.numero_de_telefono",data["tlfLocal"])
				form_data.set("datos_del_titular_rp.datos_de_ubicacion.correo_electronico",data["email"])
				form_data.set("datos_del_titular_rp.datos_de_ubicacion.pais",data["pais"])
				form_data.set("datos_del_titular_rp.datos_de_ubicacion.direccion",data["direccionNacimiento"])
				form_data.set("datos_del_titular_rp.datos_del_padre.documento_hijo",data["cedula"])
				form_data.set("datos_del_titular_rp.datos_del_padre.primer_nombre",data["primerNombrePadre"])
				form_data.set("datos_del_titular_rp.datos_del_padre.primer_apellido",data["apellidoPaternoPadre"])
				form_data.set("datos_del_titular_rp.datos_de_la_madre.documento_hijo",data["cedula"])
				form_data.set("datos_del_titular_rp.datos_de_la_madre.primer_nombre",data["primerNombreMadre"])
				form_data.set("datos_del_titular_rp.datos_de_la_madre.primer_apellido",data["apellidoPaternoMadre"])
							
						fecha = data["fechaNacimiento"]
						fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
						form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_n)

						edad = ((Date.today - fecha.to_date).to_f / 365).to_i
						form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.edad",edad)
						
							##### USADO PARA PRINT DESIGN #####
						segundoNombre = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre")
						apellidoCasada = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada")
						_nombre =  "#{data["primerNombre"]} #{segundoNombre} #{data["primerApellido"]} #{data["segundoApellido"]} #{apellidoCasada}"
						form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.nombre_completo",_nombre)

						#######Datos solicitante##########################################

					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.tipo_documento",tipo_documento)
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.cedula_pasaporte",data["cedula"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.primer_nombre",data["primerNombre"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.segundo_nombre",data["segundoNombre"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.primer_apellido",data["primerApellido"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.segundo_apellido",data["segundoApellido"])
					form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.apellido_de_casada",data["apellidoCasada"])
					form_data.set("datos_del_solicitante.datos_de_ubicacion.direccion",data["direccionNacimiento"])
				
		end
						 
	else
		form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",nro_documento)
		form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento",tipo_documento)
		form_data.set("datos_del_titular_rp.datos_del_padre.documento_hijo",nro_documento)
		form_data.set("datos_del_titular_rp.datos_de_la_madre.documento_hijo",nro_documento)
								
	end
end			
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
