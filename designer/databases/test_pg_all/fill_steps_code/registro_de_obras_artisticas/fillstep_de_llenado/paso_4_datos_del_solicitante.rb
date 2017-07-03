
  class Paso4DatosDelSolicitante < TemplateCode::Step

    on_becoming do
      if @owner["kind_of_user_type"] == "NaturalPerson"
        if @owner["natural_person_type"]=="national_citizen"
                form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte",@owner["national_id"])
        else
                if @owner["natural_person_type"]=="foreign_citizen"    
                   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte", @owner["passport"])
                end
        end

   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_nombre",@owner["first_name"])
   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_apellido",@owner["last_name"])
   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_nombre",@owner["second_name"])
   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_apellido",@owner["second_last_name"])
   form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.apellido_de_casada",@owner["married_name"])
   form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.pais",@owner["country"])
   form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.direccion",@owner["full_address"])
   form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.numero_de_telefono",@owner["fixed_number"])
   form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.correo_electronico",@owner["email"])
end

if @owner["kind_of_user_type"] == "JuridicalPerson"
        form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.ruc",@owner["tax_id"])
        form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.nombre",@owner["name"])
        form_data.set("datos_del_solicitante_persona_juridica.direccion.pais",@owner["country"])
        form_data.set("datos_del_solicitante_persona_juridica.direccion.direccion",@owner["full_address"])
        form_data.set("datos_del_solicitante_persona_juridica.direccion.numero_de_telefono",@owner["fixed_number"])
        form_data.set("datos_del_solicitante_persona_juridica.direccion.correo_electronico",@owner["email"])
end
    end

    on_transition do
      #VERIFICACIÒN NUMERO DE CEDULA DEL SOLICITANTE NO PERTENEZCA A UN DIFUNTO

if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
    numdoc = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte")
    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
    datosSol = result["response"]
    if datosSol.blank? 
        transition_errors << "La Cédula del solicitante no fue encontrada. Por favor, verifique." 
    else            
        difunto = datosSol["cod_mensaje"]
##Chantal Valverde Comentado el 15-Mar por reporte de error de mensaje / Se cambió la condición de difunto
##        if (difunto != "ND")
##            transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{numdoc} corresponde a un ciudadano Difunto."
            if (difunto == "534")
                transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{numdoc} corresponde a un ciudadano Difunto."
        end
    end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      // $(document).ready(function(){
// Deshabilito o habilito campos segundo nombre, segundo apellido
// 
// 	segundoNombre = $("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_nombre");
// 	if ($(segundoNombre).val() == ""){
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_nombre").removeAttr("disabled");
// 	}else{
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_nombre").attr("disabled","disabled");
// 	}
// 
// 	segundoApellido = $("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_apellido");
// 	if ($(segundoApellido).val() == ""){
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_apellido").removeAttr("disabled");
// 	}else{
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_segundo_apellido").attr("disabled","disabled");
// 	}
// 
// 	apellidoCasada = $("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_apellido_de_casada");
// 	if ($(apellidoCasada).val() == ""){
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_apellido_de_casada").removeAttr("disabled");
// 	}else{
// 		$("#field_datos_del_solicitante_persona_natural_datos_de_la_persona_apellido_de_casada").attr("disabled","disabled");
// 	}
// });
    STEPAJAXCODE
  end
            
