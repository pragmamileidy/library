
  class Paso3RealizacionDelPago < TemplateCode::Step

    on_becoming do
      #::::::::::::: DV: 17/04/2017 onbecoming del paso 3 ::::::::::::::::#
if form_data.get("boletas_por_pagar.monto.motivo_de_la_multa") == "true"
    #Si el pago es automatico se ejecuta las siguientes condiciones: 
    #Verificar el estatus del pago. Para esto se debe invocar el servicio get payment status enviandole como parametro el Payment Id 
    #que devuelve el servicio #de computo (invocado en el On Becoming del paso 1) y el id de la transaccion (request_id)
    #Caso estatus (started) Pendiente - Setear en el campo url el link del servicio Redirect to, pasandole como parametro 
    #el retorno del servicio Make Payment y mostrar el mensaje de pendiente
    #Caso estatus (successfully) completado - Mostrar mensaje de exito sin url 

    #CODIGO PARA INVOCAR get_payment_status

    #_url = form_data.get("variables_pago_generico.variables_pago_generico.url")
    _paymentId = form_data.get("variables_pago_generico.variables_pago_generico.payment")

    # ***** Servicio nuevo ***** 
    hash = { :payment_id => "#{_paymentId}" }
    result = PaymentProxy.get_payment_status(hash)

    status = result["response"]
    Rails.logger.info(">>>>>>> params >>>>.. #{hash}")
    Rails.logger.info(">>>>>>> STATUS >>>>.. #{status}")
    form_data.set("variables_pago_generico.variables_pago_generico.estatus",status) if status.present?

    #:::::::::::::::::::::::: Status successfully
    if (status != "successfully")
      _id = @current_user.citizen_id_number
      _name = @current_user.name
      _email = @current_user.email
      _consecutiveId = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")
      hash = {:payment_id => "#{_paymentId}", 
              :id  => "#{_id}",
              :name  => "#{_name}",
              :email => "#{_email}",
              :consecutive_id => "#{_consecutiveId}"}
      # INVOCO MAKE PAYMENT SIN MAS
      _resultMakeP = PaymentProxy.make_payment(hash)
      Rails.logger.info(">>>>>>>>>>>>> _resultMakeP  #{_resultMakeP}")
      # 10-05-17 SE AGREGA ESTA CONDICION
      if _resultMakeP["error"].present? 
        transition_errors << "Por favor intente más tarde. En este momento, no es posible acceder a la Pasarela de Pagos."
        Rails.logger.error(">>>>>>>>>>>>> Warning PaymentProxy ERROR: #{_resultMakeP["error"]}. Params: #{hash}")
      elsif ! _resultMakeP["response"].present?
        transition_errors << "Por favor intente más tarde. En este momento, no es posible acceder a la Pasarela de Pagos."
        Rails.logger.error(">>>>>>>>>>>>> Warning PaymentProxy ERROR: Gateway URL Ausente. Params: #{hash}")
      else
          #_url = _resultMakeP["response"] 
          _url = CGI.escape(_resultMakeP["response"])
          #_datoReq = ""
          _strurl = "#{PEOPLE_URL}/tasks/force_redirect_to?task_id=#{@task["id"]}&url=#{_url}"
          form_data.set("variables_pago_generico.variables_pago_generico.url",_strurl)
          form_data.set("mensajes_pago_generico.mensaje_pendiente.texto_1", _strurl)
          form_data.set("mensajes_pago_generico.mensaje_pendiente.texto_2",@task["id"])
          form_data.set("mensajes_pago_generico.mensaje_fallido.texto_1", _strurl)
          form_data.set("mensajes_pago_generico.mensaje_fallido.texto_2",@task["id"])
      end
    end 
else
    form_data.set("mensaje.confirmacion_culminacion_de_tramite.notificacion", "Estimado usuario, su solicitud está por finalizar.
        \n Su Constancia fue enviada a su correo. En breves minutos dispondrá de la Constancia de su solicitud en la pestaña Formularios.")
end
    end

    on_transition do
      #::::::::: DV: OnTransition paso 3 17/04/2017  
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
      //var url = urls+"?task_id="+taskId;
      var url = urls;
     
      //REMOVER ATRIBUTO HREF ORIGINAL
      $("#pendiente").removeAttr("href");
      
      //AÑADIR AL NUEVO HREF
      $("#pendiente").attr("href",url);


          //ASIGNACION DE VARIABLES ESTATUS FALLIDO
      var urlsf =  $("#field_mensajes_pago_generico_mensaje_fallido_texto_1").val();
      var taskIdf =  $("#field_mensajes_pago_generico_mensaje_fallido_texto_2").val();
      //var urlf = urlsf+"?task_id="+taskIdf;
      var urlf = urlsf;
      
      
       //REMOVER ATRIBUTO HREF ORIGINAL ESTATUS FALLIDO
      $("#fallido").removeAttr("href");
      
      //AÑADIR AL NUEVO HREF ESTATUS FALLIDO
      $("#fallido").attr("href",urlf);
      
  });

});


$(document).ready(function(){
  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Resumen del Pago") {  
        $(this).html("Resumen del Pago"); 
      }
    });
  });

  $( function() {
    var hint = "Resumen del Pago";
      $("span").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

   $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Entidad Evaluadora") {  
        $(this).html("Detalle del Pago"); 
      }
    });
  });

   $( function() {
    $("div").each (function(){
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
    $("span").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});

//::: DV: Ventana Emergente pantalla completa de la app ::://
$(document).ready(function(){
  pago = $('#field_boletas_por_pagar_monto_motivo_de_la_multa');
  pasarela = $('#field_variables_pago_generico_variables_pago_generico_estatus');
  hideParent(pasarela);
  var app_id = $('#field_boletas_por_pagar_monto_app_id').val();
   $(pago).parents(".section-box").hide();
   if ($(pago).val() == "false") {
    $.blockUI({
      message: '<h1 style="font-size:1.5em;color:#E2E2E2;">Estimado Usuario, su solicitud está por finalizar. Usted recibirá la constancia de su solicitud por correo y en la pestaña Archivos Adjuntos de su trámite."</h1><img src="/assets/loading_barra.gif">',
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
  }else if ($(pasarela).val() == "successfully") {
    $.blockUI({
      message: '<h1 style="font-size:1.5em;color:#E2E2E2;">Estimado Usuario, su pago ha sido enviado a la ATTT, cuando el mismo sea completado, Usted recibirá la constancia de pago por correo y en la pestaña Archivos Adjuntos de su trámite."</h1><img src="/assets/loading_barra.gif">',
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
$(document).ready(function(){
  // VDIAZ - cambios de presentación
  // elimina el boton de maximizar    
  $(".panel-control-fullscreen2").remove();
  $(".panel-control-collapse").remove();
  $(".panel-control-collapse-all").remove();
  
   //cambia estilo a boton de pasarela de pago
  $("#pendiente").attr("style", "background: #aeb404;height: 40px;font-size: 18px;text-align: center;border-radius: 10px;text-decoration: none;color: #f9f9f9;padding: 10px;");
  $("#section-plink").attr("style", "text-align:center  ");
  $("#fallido").attr("style", "background: #aeb404;height: 40px;font-size: 18px;text-align: center;border-radius: 10px;text-decoration: none;color: #f9f9f9;padding: 10px;");
  
  
  //quita palabra section y bordes de sección y parte para el boton de pasarela de pago
  $("#mensajes_pago_generico").find(".label2").remove();
  $("#mensajes_pago_generico .section-body").attr("style","border: none;");
  $("#mensajes_pago_generico .part-body").attr("style","border: none;");
  
});
function hideParent(pasarela){
  $(pasarela).parents(".section-box").hide();
}


    STEPAJAXCODE
  end
            
