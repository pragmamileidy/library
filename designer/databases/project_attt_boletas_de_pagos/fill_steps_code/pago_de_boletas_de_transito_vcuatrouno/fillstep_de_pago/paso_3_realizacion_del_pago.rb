
  class Paso3RealizacionDelPago < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
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
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Evaluador") {  
        $(this).html("Datos del Pago"); 
      }
    });
  });

  $( function() {
    var hint = "Datos del Pago";
      $("div").each (function(){
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
    $("div").each (function(){
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
  pasarela = $('#field_variables_pago_generico_variables_pago_generico_estatus');
  hideParent(pasarela);
  var app_id = $('#field_boletas_por_pagar_monto_app_id').val();
   $(pago).parents(".section-box").hide();
   if ($(pago).val() == "false") {
    $.blockUI({
      message: '<h1 style="font-size:1.5em;color:#E2E2E2;">Estimado Usuario, su solicitud está por finalizar, Usted recibirá la constancia de su solicitud por correo y en la pestaña Archivos Adjuntos de su trámite."</h1><img src="/assets/loading_barra.gif">',
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
            
