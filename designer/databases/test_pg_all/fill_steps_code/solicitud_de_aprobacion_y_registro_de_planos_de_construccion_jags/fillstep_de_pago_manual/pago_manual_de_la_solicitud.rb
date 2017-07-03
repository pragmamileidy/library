
  class PagoManualDeLaSolicitud < TemplateCode::Step

    on_becoming do
      
#CODIGO PARA INVOCAR EL SERVICIO payment_computing_service
 _applicationId = @application["id"]
 _configRoute = "EntidadesEvaluadoras-rates"
 _formId = @task["form"]
 _taskId = @task["id"]
#result = WebserviceConsumer.get('/payments/payment_computing_service.json?application_id=' + "#{_applicationId}" + '&config_route=' + "#{_configRoute}" + '&form_id=' + "#{_formId}").parsed_response

#  hash = {:application_id => "#{_applicationId}", 
  #            :config_route   => "#{_configRoute}",
    #          :form_id          => "#{_formId}"}
  #result = PaymentProxy.payment_computing_service(hash)

# ***** Servicio nuevo *****
  hash = {:application_id => "#{_applicationId}", 
              :config_route   => "#{_configRoute}",
              :form_id          => "#{_formId}",
              :task_id          => "#{_taskId}"}
  result = PaymentProxy.manual_computing_service(hash)

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
            
