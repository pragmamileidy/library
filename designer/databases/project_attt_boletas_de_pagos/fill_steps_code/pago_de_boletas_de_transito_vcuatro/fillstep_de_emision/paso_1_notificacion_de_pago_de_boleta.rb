
  class Paso1NotificacionDePagoDeBoleta < TemplateCode::Step

    on_becoming do
      #::: Invoca el método que genera PDF :::#
#app = @application["id"]
#pdf_certificado = WebserviceConsumer.get("/service/helper_bdin_pago_boletas_attt/call.json?method=generar_salvar_solvencia_pdf&app_id=#{app}").parsed_response["response"]
#form_data.set(pdf_certificado["ruta"], "document_id:#{pdf_certificado["id"]}")

#result = WebserviceConsumer.get(URI.escape('/service/helper_bdin_pago_boletas_attt/call.json?method=notificar_pagos&app_id=' + "#{app}")).parsed_response
#respuesta = result["response"]
#form_data.set("boletas_por_pagar.boletas.campo_oculto_noti", respuesta)
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){  
  $("#field_boletas_por_pagar_boletas_reporte_pago").parents(".field-box").hide();    
  $("#field_boletas_por_pagar_boletas_mensaje_notificacion").css({'color':'#088A08','font-size':'1.2em','text-align':'justify','font-weight:':'bold','white-space':'pre-line'});
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Datos de la Persona que debe pagar la boleta") {  
        $(this).html("Datos de la Persona que pagó la boleta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Persona que pagó la boleta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Información de la Persona Jurídica") {  
        $(this).html("Datos de la Persona Jurídica que pagó la boleta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Persona Jurídica que pagó la boleta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
  
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Boletas por Pagar") {  
        $(this).html("Notificación de Pago de Boleta"); 
      }
    });
  });

  $( function() {
    var hint = "Notificación de Pago de Boleta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
  
  $( function() {
    var hint = "Información de Boletas por pagar en la ATTT";
      $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(""); 
      }
    });
  })

$( function() {
    var hint = "Monto";
      $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(""); 
      }
    });
  })


$( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Monto Pendiente por Pagar") {  
        $(this).html(""); 
      }
    });
  });
  
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección:") {  
        $(this).html(""); 
      }
    });
  });
});
    STEPAJAXCODE
  end
            
