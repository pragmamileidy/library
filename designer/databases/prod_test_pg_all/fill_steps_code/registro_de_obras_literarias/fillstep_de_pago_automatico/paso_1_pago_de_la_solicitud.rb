
  class Paso1PagoDeLaSolicitud < TemplateCode::Step

    on_becoming do
      #CODIGO PARA INVOCAR EL SERVICIO payment_computing_service
 _applicationId = @application["id"]
 _configRoute = "Rates-rates"
 _formId = @task["form"]
#result = WebserviceConsumer.get('/payments/payment_computing_service.json?application_id=' + "#{_applicationId}" + '&config_route=' + "#{_configRoute}" + '&form_id=' + "#{_formId}").parsed_response

  hash = {:application_id => "#{_applicationId}", 
              :config_route   => "#{_configRoute}",
              :form_id          => "#{_formId}"}
  result = PaymentProxy.payment_computing_service(hash)

_payment_id= result["response"]["payment_id"]
_detail = result["response"]["detail"]
_total = result["response"]["result"]["total"]

form_data.set("variables_pago_generico.variables_pago_generico.payment",_payment_id)
form_data.set("variables_pago_generico.variables_pago_generico.detail",_detail)
form_data.set("datos_del_evaluador_generico.monto_total.monto_total", _total)

result["response"]["result"]["items"].each do |key, value|
 if(key =~ /item_instance_([\d]+)/)
  _i = $1.to_i - 1
    form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.nombre_de_la_entidad", value["name"])
    form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.pagada", "Iniciada")
    form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.monto_a_pagar", value["formula"])
 end 
end

    end

    on_transition do
      #CODIGO PARA INVOCAR Make Payment, que nos retorna un url

#_paymentId = form_data.get("variables_pago_generico.variables_pago_generico.payment")
#_consecutiveId = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")

#_id = @current_user.citizen_id_number
#_name = @current_user.name
#_email = @current_user.email

#_str = '/payments/make_payment.json?payment_id=' + "#{_paymentId}" + '&id=' + "#{_id}" + '&name=' + "#{_name}" + '&email=' + "#{_email}" + '&consecutive_id=' + "#{_consecutiveId}"

#_result = WebserviceConsumer.get(URI.escape(_str)).parsed_response
#_error = _result["error"]

#if !_error.nil?
  #   transition_errors << "Ha ocurrido un error al intentar iniciar el pago."
#else
#	#seteos
  #  _url = _result["response"]
   # _dato = _result["request_id"]
	#_strurl = "#{PEOPLE_URL}/tasks/force_redirect_to?task_id=#{@task["id"]}&url=#{_url}"
#	form_data.set("variables_pago_generico.variables_pago_generico.url",_strurl)
 #       form_data.set("variables_pago_generico.variables_pago_generico.request", _dato)
#end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
	
	$(document).ready(function(){

		function partContainer(obj) { 
			return obj.parent().parent().parent().parent().parent().children(); 
		};
		function valueIsCero(obj) { 
			return ((obj.val() == "") || (obj.val() == 0)); 
		};
		function hideIfCero(obj) { 
			if( valueIsCero(obj) ){ partContainer(obj).hide(); partContainer(obj).parent().hide(); };
		};

		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_0_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_1_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_2_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_3_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_4_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_5_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_6_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_7_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_8_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_9_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_10_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_11_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_12_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_13_monto_a_pagar'));
		hideIfCero($('#field_datos_del_evaluador_generico_entidad_evaluadora_14_monto_a_pagar'));


	});
});

    STEPAJAXCODE
  end
            
