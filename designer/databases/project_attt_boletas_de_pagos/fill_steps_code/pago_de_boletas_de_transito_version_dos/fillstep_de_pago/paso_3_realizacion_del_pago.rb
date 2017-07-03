
  class Paso3RealizacionDelPago < TemplateCode::Step

    on_becoming do
      if form_data.get("boletas_por_pagar.monto.motivo_de_la_multa") == "true"
	#Si el pago es automatico se ejecuta las siguientes condiciones: 
	#Verificar el estatus del pago. Para esto se debe invocar el servicio get payment status enviandole como parametro el Payment Id que devuelve el servicio #de computo (invocado en el On Becoming del paso 1) y el id de la transaccion (request_id)
	#Caso estatus Pendiente - Setear en el campo url el link del servicio Redirect to, pasandole como parametro el retorno del servicio Make Payment y mostrar el mensaje de pendiente
	#Caso estatus completado - Mostrar mensaje de exito sin url 

	#CODIGO PARA INVOCAR get_payment_status

	#_url = form_data.get("variables_pago_generico.variables_pago_generico.url")
	_datoRequest =  form_data.get("variables_pago_generico.variables_pago_generico.request")
	_paymentId = form_data.get("variables_pago_generico.variables_pago_generico.payment")
	_consecutiveId = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")
	_id = @current_user.citizen_id_number
	_name = @current_user.name
	_email = @current_user.email

	# ***** Servicio nuevo *****
	  hash = {:payment_id => "#{_paymentId}", 
	          :request_id => "#{_datoRequest}",
	          :dummy      => "true"}
	  result = PaymentProxy.get_payment_status(hash)
	  
	#result = WebserviceConsumer.get("/payments/get_payment_status.json?payment_id=#{_paymentId}&request_id=#{_datoRequest}").parsed_response
	status = result["response"]

	if !status.nil?
		#transition_errors << "Ha ocurrido un error al revisar el pago. Por favor intente más tarde.."
	#else
		form_data.set("variables_pago_generico.variables_pago_generico.estatus",status)
	end


	#Status Started || Error
	if ((status == "started") || (status == "error") || (status == "created"))
		#_str = '/payments/make_payment.json?payment_id=' + "#{_paymentId}" + '&id=' + "#{_id}" + '&name=' + "#{_name}" + '&email=' + "#{_email}" + '&consecutive_id=' + "#{_consecutiveId}"
	    
	  hash = {:payment_id => "#{_paymentId}", 
	          :id  => "#{_id}",
	          :name  => "#{_name}",
			  :email => "#{_email}",
		      :consecutive_id => "#{_consecutiveId}"}
	  _resultMakeP = PaymentProxy.make_payment(hash, true)
	  
		#_resultMakeP = WebserviceConsumer.get(URI.escape(_str)).parsed_response
		_error = _resultMakeP["error"]

		#if !_error.nil?
		 #    transition_errors << "Ha ocurrido un error para redireccionar el pago. Por favor intente más tarde."
		#else
			#seteos
			_url = _resultMakeP["response"]
			_datoReq = _resultMakeP["request_id"]
			_strurl = "#{PEOPLE_URL}/tasks/force_redirect_to?task_id=#{@task["id"]}&url=#{_url}"
			form_data.set("variables_pago_generico.variables_pago_generico.url",_strurl)
			form_data.set("variables_pago_generico.variables_pago_generico.request", _datoReq)
			form_data.set("mensajes_pago_generico.mensaje_pendiente.texto_1", _strurl)
			form_data.set("mensajes_pago_generico.mensaje_pendiente.texto_2",@task["id"])
			form_data.set("mensajes_pago_generico.mensaje_fallido.texto_1", _strurl)
			form_data.set("mensajes_pago_generico.mensaje_fallido.texto_2",@task["id"])
		
		#end
	end


	#Status successfully
	if (status == "successfully" && 1 == 2)
		#result = WebserviceConsumer.get('/payments/get_payment_info.json?payment_id=' + "#{_paymentId}").parsed_response

	# ***** Servicio nuevo *****
	  hash = {:payment_id => "#{_paymentId}"}
	  result = PaymentProxy.get_payment_info(hash)

		_fecha_de_pago = result["response"]["payment_date"]
		_no_de_confirmacion = result["response"]["transaction_id"]
		_monto_del_pago = result["response"]["total"]
		_medio_utilizado = result["response"]["payment_method"]

		form_data.set("datos_obtenidos_del_pago_electronico_generico.datos_obtenidos_del_pago_electronico_generico.fecha_del_pago", _fecha_de_pago)
		form_data.set("datos_obtenidos_del_pago_electronico_generico.datos_obtenidos_del_pago_electronico_generico.no_de_confirmacion", _no_de_confirmacion)
		form_data.set("datos_obtenidos_del_pago_electronico_generico.datos_obtenidos_del_pago_electronico_generico.monto_del_pago", _monto_del_pago)
		form_data.set("datos_obtenidos_del_pago_electronico_generico.datos_obtenidos_del_pago_electronico_generico.medio_utilizado", _medio_utilizado)
	end 
else
    form_data.set("mensaje.confirmacion_culminacion_de_tramite.notificacion", "Estimado usuario, su solicitud está por finalizar.
    	\n Su Constancia fue enviada a su correo. En breves minutos dispondrá la Constancia de su solicitud en la pestaña Archivos Adjuntos.")
end
    end

    on_transition do
      if form_data.get("boletas_por_pagar.monto.motivo_de_la_multa") == "true"
#Verificar el estatus del pago. Para esto se debe invocar el servicio transaction search enviandole como parametro el Payment Id que devuelve el servicio #de computo (invocado en el On Becoming del paso 1)

###CODIGO PARA INVOCAR get_payment_status ###
_paymentId = form_data.get("variables_pago_generico.variables_pago_generico.payment")
_dato2 =  form_data.get("variables_pago_generico.variables_pago_generico.request")

#result = WebserviceConsumer.get("/payments/get_payment_status.json?payment_id=#{_paymentId}&request_id=#{_dato2}").parsed_response

# ***** Servicio nuevo *****
  hash = {:payment_id => "#{_paymentId}", 
              :request_id   => "#{_dato2}"}
  result = PaymentProxy.get_payment_status(hash)
  
status = result["response"]
if status.nil?
	transition_errors << "Ha ocurrido un error al revisar el pago. Por favor intente más tarde."
else
	#seteos
	form_data.set("variables_pago_generico.variables_pago_generico.estatus",status)

end

###  CODIGO PARA MENSAJE FALLIDO DE PAGO ###
if (form_data.get("variables_pago_generico.variables_pago_generico.estatus")!="successfully")
   transition_errors << "Su pago no ha sido completado. Por favor verifique y complete la transacción para enviar el formulario."
end

end 

#::: Condición para notificar el mensaje para el recibo :::#
if form_data.get("boletas_por_pagar.monto.motivo_de_la_multa") == "true"
    form_data.set("boletas_por_pagar.boletas.mensaje_notificacion", "Estimado usuario su pago ha sido reportado a SERTRACEN. Puede descargar su Constancia disponible en el campo Reporte de Pago.
    	\n \n\ Su Constancia fue enviada a su correo. En breves minutos dispondrá de su Constancia de Pago en la pestaña Archivos Adjuntos.")
else
    form_data.set("boletas_por_pagar.boletas.mensaje_notificacion", "Estimado usuario, puede descargar la Constancia de su solicitud disponible en el campo Reporte de Pago.
    	\n \n\ Su Constancia fue enviada a su correo. En breves minutos dispondrá la Constancia de su solicitud en la pestaña Archivos Adjuntos.")
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
        $(document).ready(function(){
		 
		 //OCULTAR INPUT DE TEXTO
		  $("#field_mensajes_pago_generico_mensaje_pendiente_texto_1").hide();
		  $("#field_mensajes_pago_generico_mensaje_pendiente_texto_2").hide();

          $("#field_mensajes_pago_generico_mensaje_exito_texto_1").hide();
          $("#field_mensajes_pago_generico_mensaje_fallido_texto_1").hide();
		  $("#field_mensajes_pago_generico_mensaje_fallido_texto_2").hide();

		  //ASIGNACION DE VARIABLES 
		  var urls =  $("#field_mensajes_pago_generico_mensaje_pendiente_texto_1").val();
		  var taskId =  $("#field_mensajes_pago_generico_mensaje_pendiente_texto_2").val();
		  var url = urls+"?task_id="+taskId;
		 
		  //REMOVER ATRIBUTO HREF ORIGINAL
		  $("#pendiente").removeAttr("href");
		  
		  //AÑADIR AL NUEVO HREF
		  $("#pendiente").attr("href",url);


          //ASIGNACION DE VARIABLES ESTATUS FALLIDO
		  var urlsf =  $("#field_mensajes_pago_generico_mensaje_fallido_texto_1").val();
		  var taskIdf =  $("#field_mensajes_pago_generico_mensaje_fallido_texto_2").val();
		  var urlf = urlsf+"?task_id="+taskIdf;
		  
		  
		   //REMOVER ATRIBUTO HREF ORIGINAL ESTATUS FALLIDO
		  $("#fallido").removeAttr("href");
		  
		  //AÑADIR AL NUEVO HREF ESTATUS FALLIDO
		  $("#fallido").attr("href",urlf);
		  
	});

});


$(document).ready(function(){
  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Evaluador") {  
        $(this).html("Datos del Pago"); 
      }
    });
  });

  $( function() {
    var hint = "Datos del Pago";
      $("span").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

   $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Entidad Evaluadora") {  
        $(this).html("Detalle del Pago"); 
      }
    });
  });

   $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Nombre de la Entidad Evaluadora") {  
        $(this).html("Beneficiario del Pago"); 
      }
    });
  });
  
  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección:") {  
        $(this).html(""); 
      }
    });
  });
});

$(document).ready(function(){    
  $("#field_mensaje_confirmacion_culminacion_de_tramite_notificacion").css({'color':'#088A08','font-size':'1.1em','text-align':'justify','font-weight:':'bold','white-space':'pre-line'});
  $( function() {
    var hint = "Mensaje";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});

//::: DV: Ventana Emergente pantalla completa de la app ::://
$(document).ready(function(){
  pago = $('#field_boletas_por_pagar_monto_motivo_de_la_multa');
  pasarela = $('#field_datos_obtenidos_del_pago_electronico_generico_datos_obtenidos_del_pago_electronico_generico_no_de_confirmacion');
  var app_id = $('#field_boletas_por_pagar_monto_app_id').val();
   $(pago).parents(".section-box").hide();
   if ($(pago).val() == "false") {
    $.blockUI({
      message: '<h1 style="font-size:1.5em;color:#E2E2E2;">Estimado usuario, su solicitud está por finalizar. Su Constancia fue enviada a su correo. En breves minutos dispondrá de la Constancia de su solicitud en la pestaña Archivos Adjuntos."</h1><img src="/assets/loading_barra.gif">',
      css: {
        border: 'none',
        padding: '15px',
        backgroundColor: '#1E1F20',
        '-webkit-border-radius': '10px',
        '-moz-border-radius': '10px',
        opacity: .9,
        color: '#fff',
      }
    });

    setTimeout(function(){ 
      document.location = "/applications/"+app_id;
    }, 5000);
  }

  if ($(pasarela).html() == "") {
    $.blockUI({
      message: '<h1 style="font-size:1.5em;color:#E2E2E2;">Su pago ha sido realizado y está siendo reportado a la Autoridad de Transporte y Tránsito Terrestre, esto puede tomar unos minutos."</h1><img src="/assets/loading_barra.gif">',
      css: {
        border: 'none',
        padding: '15px',
        backgroundColor: '#1E1F20',
        '-webkit-border-radius': '10px',
        '-moz-border-radius': '10px',
        opacity: .9,
        color: '#fff',
      }
    });

    setTimeout(function(){ 
      document.location = "/applications/"+app_id;
    }, 5000);
  }
});
    STEPAJAXCODE
  end
            
