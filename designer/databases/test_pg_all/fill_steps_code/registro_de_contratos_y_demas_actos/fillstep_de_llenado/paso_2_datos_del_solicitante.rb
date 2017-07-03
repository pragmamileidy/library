
  class Paso2DatosDelSolicitante < TemplateCode::Step

    on_becoming do
      if @owner["kind_of_user_type"] == "NaturalPerson"
         numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte","#{numdoc}")
		
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_nombre",@owner["first_name"])
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_apellido",@owner["last_name"])
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_nombre",@owner["second_name"])
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_apellido",@owner["second_last_name"])
		name1=form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_nombre")
		name2=form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_apellido")
		name3=form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_nombre")
		name4=form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_apellido")
		completo="#{name1} #{name3} #{name2} #{name4}"
		form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.nombre_completo",completo)
        pais_natural = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.pais")
		form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.pais",@owner["country"]) if !pais_natural.present?
		direccion_natural = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.direccion")
		form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.direccion",@owner["full_address"]) if !direccion_natural.present?
		telefono_natural = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.numero_de_telefono")
		form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.numero_de_telefono",@owner["fixed_number"]) if !telefono_natural.present?
		email_natural = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.correo_electronico")
		form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.correo_electronico",@owner["email"]) if !email_natural.present?

end

if @owner["kind_of_user_type"] == "JuridicalPerson"

		form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.ruc",@owner["tax_id"])
		form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.nombre",@owner["name"])
		pais_juridico = form_data.get("datos_del_solicitante_persona_juridica.direccion.pais")
		form_data.set("datos_del_solicitante_persona_juridica.direccion.pais",@owner["country"]) if !pais_juridico.present?
		direccion_juridico = form_data.get("datos_del_solicitante_persona_juridica.direccion.direccion")
		form_data.set("datos_del_solicitante_persona_juridica.direccion.direccion",@owner["full_address"]) if !direccion_juridico.present?
		telefono_juridico = form_data.get("datos_del_solicitante_persona_juridica.direccion.numero_de_telefono")
		form_data.set("datos_del_solicitante_persona_juridica.direccion.numero_de_telefono",@owner["fixed_number"]) if !telefono_juridico.present?
        ##form_data.set("datos_del_solicitante_persona_juridica.direccion.numero_celular",@owner["movil_number"])
		email_juridico = form_data.get("datos_del_solicitante_persona_juridica.direccion.correo_electronico")
		form_data.set("datos_del_solicitante_persona_juridica.direccion.correo_electronico",@owner["email"]) if !email_juridico.present?

end
    end

    on_transition do
      # Obtener valor del config
                valor = @config.route("Rates-payment-payment-payment")
                
                if valor == "Electrónico"
                
                        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Electrónico")
                
                end
                if valor == "Manual"
                
                        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")
                
                end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
