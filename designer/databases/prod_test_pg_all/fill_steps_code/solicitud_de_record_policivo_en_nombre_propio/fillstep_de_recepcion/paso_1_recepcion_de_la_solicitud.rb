
  class Paso1RecepcionDeLaSolicitud < TemplateCode::Step

    on_becoming do
      _idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]

# form_data.set("recibido_por.datos_del_funcionario_generico.usuario", _agente["name"])
form_data.set("recibido_vu.datos_del_funcionario_generico.usuario", _agente["name"])
    end

    on_transition do
      _obs = form_data.get("recibido_vu.datos_del_funcionario_generico.observaciones")
_eval = form_data.get("recibido_vu.datos_del_funcionario_generico.evaluacion_ok_reparo")

if (_eval =="REPARO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del reparo en el campo (Observación). "
end

if (_eval =="RECHAZO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del rechazo en el campo (Observación). "
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){ 
   $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Tipo de Solicitud") {  
        $(this).html("Tipo de Solicitud"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Solicitante") {  
        $(this).html("Gestión de Solicitud"); 
      }
    });
  });


  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Titular") {  
        $(this).html("Información del Titular"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Recepción Ventanilla Única") {  
        $(this).html("Recepción de Ventanilla Única"); 
      }
    });
  });
});

$(document).ready(function(){ 
  TiDoc = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento');
  nacio = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_nacionalidad');
  if ($(TiDoc).html() == "Cedula") {
    $(nacio).html("Nacional");
  } else if($(TiDoc).html() == "Pasaporte") {
    $(nacio).html("Extranjero");
  }
});
    STEPAJAXCODE
  end
            
