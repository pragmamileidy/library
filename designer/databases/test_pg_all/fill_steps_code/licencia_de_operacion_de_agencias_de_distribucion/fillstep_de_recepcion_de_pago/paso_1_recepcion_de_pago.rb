
  class Paso1RecepcionDePago < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente - LG

_idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]


form_data.set("recibido_por_pago.datos_del_funcionario_proceso.usuario", _agente["name"])
form_data.set("recibido_pago.datos_del_funcionario_proceso.usuario", _agente["name"])
    end

    on_transition do
      id_pago = form_data.get("variables_pago_generico.variables_pago_generico.payment")

respuesta_del_agente = form_data.get("recibido_por_pago.datos_del_funcionario_proceso.seleccione_el_resultado_de_su_evaluacion")

if respuesta_del_agente.blank?
  respuesta_del_agente = form_data.get("recibido_pago.datos_del_funcionario_proceso.seleccione_el_resultado_de_su_evaluacion_ok_rechazo")
end

PaymentProxy.payment_reception(id_pago, respuesta_del_agente)

_obs = form_data.get("recibido_por_pago.datos_del_funcionario_proceso.observaciones")
_eval = form_data.get("recibido_por_pago.datos_del_funcionario_proceso.seleccione_el_resultado_de_su_evaluacion")
if (_eval =="REPARO" && _obs.blank?) 
   transition_errors << "Debe indicar el motivo del reparo en el campo (Observación). "
end

if (_eval =="RECHAZO" && _obs.blank?) 
   transition_errors << "Debe indicar el motivo del rechazo en el campo (Observación). "
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
