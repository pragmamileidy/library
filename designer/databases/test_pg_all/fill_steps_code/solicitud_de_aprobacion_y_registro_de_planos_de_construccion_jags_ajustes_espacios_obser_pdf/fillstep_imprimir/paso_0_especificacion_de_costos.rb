
  class Paso0EspecificacionDeCostos < TemplateCode::Step

    on_becoming do
      ##### INTEGRACION DE PAGO AUTOMATICO #####
form_data.set("entidad_evaluadora_revisiones.monto_total.costo", " ") 
#CODIGO PARA INVOCAR EL SERVICIO payment_computing_service
_applicationId = @application["id"]
_configRoute = "EntidadesEvaluadoras-rates"
_formId = @task["form"]
evaluacion = form_data.get("seccion_de_funcionario_jefe4.datos_del_funcionario_generico.evaluacion")

#result = WebserviceConsumer.get('/payments/payment_computing_service.json?application_id=' + "#{_applicationId}" + '&config_route=' + "#{_configRoute}" + '&form_id=' + "#{_formId}").parsed_response

hash = {:application_id => "#{_applicationId}", 
  :config_route   => "#{_configRoute}",
  :form_id        => "#{_formId}"}
result = PaymentProxy.payment_computing_service(hash)
  
_payment_id= result["response"]["payment_id"]
_detail = result["response"]["detail"]
_total  = result["response"]["result"]["total"] 

#form_data.set("variables_usadas_codigos_p5.variables_p5.payment",_payment_id)
#form_data.set("variables_usadas_codigos_p5.variables_p5.detail",_detail)

if (evaluacion == "REPARO")
 form_data.set("entidad_evaluadora_revisiones.monto_total.monto_pagado", _total) 
else
 form_data.set("entidad_evaluadora_revisiones.monto_total.costo", _total) 
 form_data.set("entidad_evaluadora_revisiones.monto_total.total", _total) 
end

##### SETEAR NOMBRES Y MONTOS DE ENTIDADES SEGUN RESPUESTA DE SERVICIO DE PAGO #####
result["response"]["result"]["items"].each do |key, value|
 if(key =~ /item_instance_([\d]+)/)
 _i = $1.to_i - 1
  if(value["description"] == "fija") 
form_data.set("entidades_fijas.entidad.nombre_de_la_entidad", value["name"])
form_data.set("entidades_fijas.entidad.monto_a_pagar", value["formula"])
  else
   form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{_i}.nombre_de_la_entidad", value["name"])
   form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{_i}.monto_a_pagar", value["formula"])
  end
 end 
end


#Nombres de entidades AV
_app_id = @application["id"].to_s
result_entidades = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
entidades=[]
result_entidades["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
 next unless key =~ /entidades_instance/ 
 entidades << entidad_data["evaluacion_de_la_entidad"]  
end

haybomberos = false
entidades.each_index do |i|
 ##### SE ASIGNAN LOS NOMBRES DE TODAS LAS ENTIDADES EVALUADORAS #####
 _name = entidades[i]["entidad"]
 ##### SI LA ENTIDAD NO ES DE BOMBEROS #####
 if !(_name =~ /CBP|Bomberos/)
  form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_entidad", _name)
 else
 ##### SI LA ENTIDAD SI ES DE BOMBEROS #####
  if !haybomberos
   ##### SI NO SE HA AGREGADO BOMBEROS, SE AGREGA
   form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_entidad", "Cuerpo de Bomberos de Panamá")
   haybomberos = true
  end
 end
end
    end

    on_transition do
      ##### Fillstep Imprimir - ON TRANSITION #####

_app_id = @application["id"].to_s
result = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
entidades=[]
result["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
 next unless key =~ /entidades_instance/ 
 entidades << entidad_data["evaluacion_de_la_entidad"]
end

seleccion = form_data.get("asignacion_de_entidades.entidad_evaluadora.entidad_evaluadora_check")
seleccion = JSON.parse(seleccion)

##### RECORRER LISTA DE ENTIDADES CONFIGURADAS
posbomberos   = ""
haybomberos   = false
montobomberos = false
mensaje_cero  = "0.00"
sin_seleccion = "NO FUE REQUERIDA REVISIÓN DE ESTA ENTIDAD."
entidades.each_index do |i|
 ##### SI LA ENTIDAD EXISTE (NOMBRE NO ES VACIO)
 if  (entidades[i]["entidad"] != "")
  _name = entidades[i]["entidad"]
  ##### SI CONSIGO LA PRIMERA ENTIDAD DE BOMBEROS - GUARDO LA POSICION
  if !haybomberos && (_name =~ /CBP|Bomberos/)
   haybomberos = true
   posbomberos = i
  end
  ##### SI LA ENTIDAD FUE SELECCIONADA
  if (seleccion.include? entidades[i]["entidad"])
   monto = form_data.get("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.monto_a_pagar")
   ##### SI LA ENTIDAD NO TIENE PAGO
   if (monto == 0 || monto == "")
    ##### SI LA ENTIDAD ES BOMBEROS
    if (_name =~ /CBP|Bomberos/)
     ##### SI NO SE HA SETEADO EL MONTO A PAGAR DE LA ENTIDAD
     if !montobomberos
      ##### SE ASIGNA MENSAJE EN LA POSICION DE BOMBEROS - POSBOMBEROS
      form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{posbomberos}.monto_texto",mensaje_cero)
      montobomberos = true
     end
    else
     ##### SI LA ENTIDAD NO ES BOMBEROS ASIGNA MENSAJE
     form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.monto_texto",mensaje_cero)
    end
   else
    ##### SI LA ENTIDAD SI TIENE PAGO
    ##### SI LA ENTIDAD ES BOMBEROS
    if (_name =~ /CBP|Bomberos/)
     ##### SI NO SE HA SETEADO EL MONTO A PAGAR DE LA ENTIDAD
     if !montobomberos
      ##### SE ASIGNA MONTO EN LA POSICION DE BOMBEROS - POSBOMBEROS
      form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{posbomberos}.monto_texto",monto)
      montobomberos = true
     end
    else
     ##### SI LA ENTIDAD NO ES BOMBEROS SE ASIGNA MONTO
     form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.monto_texto",monto)
    end
   end
  else
   ##### SI LA ENTIDAD NO FUE SELECCIONADA
   if (_name =~ /CBP|Bomberos/)
    ##### SI LA ENTIDAD ES BOMBEROS
    if !montobomberos
     ##### SI NO SE HA SETEADO EL MONTO A PAGAR DE LA ENTIDAD
     form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{posbomberos}.monto_texto", sin_seleccion)
    end
   else
    ##### SI LA ENTIDAD NO ES BOMBEROS
    if (!form_data.get("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_entidad").blank?)
     form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.monto_texto", sin_seleccion)
    end
   end
  end
 end
end


evaluacion = form_data.get("seccion_de_funcionario_jefe4.datos_del_funcionario_generico.evaluacion")    
if (evaluacion == "REPARO")
 suma3 = form_data.get("entidad_evaluadora_revisiones.monto_total.total") 
 suma2 = form_data.get("entidad_evaluadora_revisiones.monto_total.monto_pagado") 
 monto_total = suma3.to_i + suma2.to_i 
 form_data.set("entidad_evaluadora_revisiones.monto_total.total", monto_total)
 resta =  monto_total.to_i - suma2.to_i
 form_data.set("entidad_evaluadora_revisiones.monto_total.acumulado", resta)       
end

entidad_fija = "Registro Público" 
monto_fijo = form_data.get("entidades_fijas.entidad.monto_a_pagar")
monto_fijo_pagar = "0.00"
if monto_fijo.blank?
	form_data.set("entidades_fijas.entidad.nombre_de_la_entidad",entidad_fija)
	form_data.set("entidades_fijas.entidad.monto_a_pagar",monto_fijo_pagar)
end
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
            
