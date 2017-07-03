
  class Paso1CerradoPor < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente - LG

_idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]


form_data.set("cerrado_por.datos_del_funcionario_generico.usuario", _agente["name"])
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){

	cedula = $("#field_datos_del_solicitante_datos_de_la_persona_cedula");
	if ($(cedula).html() == ""){
		$("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().hide();
		$("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().show();
	}

	pasaporte = $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte");
	if ($(pasaporte).html() == "") {
		$("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().show();
		$("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().hide();
	}
});

// Chantal Valverde 13-Abr-2017, modificación de etiquetas

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Teléfono") {
          $(this).html("Número de teléfono Fijo");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número Celular") {
          $(this).html("Número de teléfono Móvil");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Teléfono de Oficina") {
          $(this).html("Número de teléfono Fijo");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Fax") {
          $(this).html("Número de teléfono Móvil");
      }
  });
});

//// escondiendo o mostrando parte

tipoSolicitud = $('#field_tipo_de_solicitud_tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia_tipo_de_solicitud');
   if ($(tipoSolicitud).html() == "Inicio"){
       $('#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion').parents(".part-box").hide();
   }else{
       $('#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion').parents(".part-box").show();
   }

otraEmpresa = $('#field_horario_de_regencia_trabaja_en_otra_empresa_seleccione');
   if ($(otraEmpresa).html() == "Sí"){
       $('#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa').parents(".field-box").show();
       $('#field_horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa').parents(".field-box").show();
   }else{
       $('#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa').parents(".field-box").hide();
       $('#field_horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa').parents(".field-box").hide();
   }



    STEPAJAXCODE
  end
            
