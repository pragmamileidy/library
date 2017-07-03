
  class PagoDeLaSolicitud < TemplateCode::Step

    on_becoming do
      
#CODIGO PARA INVOCAR EL SERVICIO payment_computing_service
 _applicationId = @application["id"]
 _configRoute = "EntidadesEvaluadoras-rates"
 _formId = @task["form"]
 
#result = WebserviceConsumer.get('/payments/payment_computing_service.json?application_id=' + "#{_applicationId}" + '&config_route=' + "#{_configRoute}" + '&form_id=' + "#{_formId}").parsed_response

  hash = {:application_id => "#{_applicationId}", 
              :config_route   => "#{_configRoute}",
              :form_id          => "#{_formId}"}
  result = PaymentProxy.payment_computing_service(hash)
  
_payment_id= result["response"]["payment_id"]
_detail = result["response"]["detail"]
_total  = result["response"]["result"]["total"] 


form_data.set("variables_usadas_codigos_p5.variables_p5.payment",_payment_id)
form_data.set("variables_usadas_codigos_p5.variables_p5.detail",_detail)
form_data.set("entidad_evaluadora_revisiones.monto_total.monto_total", _total) 


result["response"]["result"]["items"].each do |key, value|
 if(key =~ /item_instance_([\d]+)/)
  _i = $1.to_i - 1
  if(value["description"] == "fija")
    form_data.set("entidades_fijas.entidad.nombre_de_la_entidad", value["name"])
    form_data.set("entidades_fijas.entidad.pagada", "Iniciada")
    form_data.set("entidades_fijas.entidad.monto_a_pagar", value["formula"])
     else
    form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{_i}.nombre_de_la_entidad", value["name"])
    form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{_i}.pagada", "Iniciada")
    form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{_i}.monto_a_pagar", value["formula"])
  end
 end 
end
    end

    on_transition do
      

#CODIGO PARA INVOCAR Make Payment, que nos retorna un url

#_paymentId = form_data.get("variables_usadas_codigos_p5.variables_p5.payment")
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
	#seteos
#    _url = _result["response"] 
  # _dato = _result["request_id"]
  # _strurl = "#{PEOPLE_URL}/tasks/force_redirect_to?task_id=#{@task["id"]}&url=#{_url}"
#	form_data.set("variables_usadas_codigos_p5.variables_p5.url",_strurl)
  #      form_data.set("variables_usadas_codigos_p5.variables_p5.request", _dato)
#end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
	entidad_evaluadora_0 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_0_monto_a_pagar");
	entidad_evaluadora_1 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_1_monto_a_pagar");
	entidad_evaluadora_2 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_2_monto_a_pagar");
	entidad_evaluadora_3 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_3_monto_a_pagar");
	entidad_evaluadora_4 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_4_monto_a_pagar");
	entidad_evaluadora_5 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_5_monto_a_pagar");
	entidad_evaluadora_6 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_6_monto_a_pagar");
	entidad_evaluadora_7 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_7_monto_a_pagar");
	entidad_evaluadora_8 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_8_monto_a_pagar");
	entidad_evaluadora_9 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_9_monto_a_pagar");
	entidad_evaluadora_10 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_10_monto_a_pagar");
	entidad_evaluadora_11 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_11_monto_a_pagar");
	entidad_evaluadora_12 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_12_monto_a_pagar");
	entidad_evaluadora_13 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_13_monto_a_pagar");
	entidad_evaluadora_14 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_14_monto_a_pagar");
	entidad_evaluadora_16 = $("#field_entidades_fijas_entidad_nombre_de_la_entidad").html("Registro Público");
	monto_fijo = $("#field_entidades_fijas_entidad_monto_a_pagar");

	//:::::::: Mnatener campos entre pasos y reparo :::::://
	if ($(monto_fijo).html() == ""){
		$(monto_fijo).html("0.00");
	}
	if($(entidad_evaluadora_0).html() == ""){
		$(entidad_evaluadora_0).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_0).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_1).html() == ""){
		$(entidad_evaluadora_1).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_1).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_2).html() == ""){
		$(entidad_evaluadora_2).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_2).parents(".part-box").show();  
	}  
	if($(entidad_evaluadora_3).html() == ""){
		$(entidad_evaluadora_3).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_3).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_4).html() == ""){
		$(entidad_evaluadora_4).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_4).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_5).html() == ""){
		$(entidad_evaluadora_5).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_5).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_6).html() == ""){
		$(entidad_evaluadora_6).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_6).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_7).html() == ""){
		$(entidad_evaluadora_7).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_7).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_8).html() == ""){
		$(entidad_evaluadora_8).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_8).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_9).html() == ""){
		$(entidad_evaluadora_9).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_9).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_10).html() == ""){
		$(entidad_evaluadora_10).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_10).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_11).html() == ""){
		$(entidad_evaluadora_11).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_11).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_12).html() == ""){
		$(entidad_evaluadora_12).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_12).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_13).html() == ""){
		$(entidad_evaluadora_13).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_13).parents(".part-box").show();  
	}
	if($(entidad_evaluadora_14).html() == ""){
		$(entidad_evaluadora_14).parents(".part-box").hide();    
	}else{
		$(entidad_evaluadora_14).parents(".part-box").show();  
	}
});
    STEPAJAXCODE
  end
            
