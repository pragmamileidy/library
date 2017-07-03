
  class Paso3AdjuntarArchivos < TemplateCode::Step

    on_becoming do
      form_data.set("anexos_solicitud_de_record_policivo.mensaje_dij.mensaje","No se requieren anexos adicionales en la solicitud.\n \nFavor continúe al próximo paso.") 

#::: DV: AGREGADO 21/01/2016 :::#
#:::: SI EL TITULAR NO EXISTE EN LA DIJ Y NO ES EL owner, obtiene el nombre si el mismo viene vacio :::::#
	(1..20).each do |_num|
		primerNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre")
		segundoNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre")
		primerApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido")
		segundoApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido")
		apellidoCasada = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada")
		nombreCompleto = "#{primerNombre} #{segundoNombre} #{primerApellido} #{segundoApellido} #{apellidoCasada}"
		form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.nombre_completo",nombreCompleto.squish)
	end
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
