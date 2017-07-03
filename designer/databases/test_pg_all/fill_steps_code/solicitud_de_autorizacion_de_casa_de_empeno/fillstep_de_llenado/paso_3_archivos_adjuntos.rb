
  class Paso3ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      // Cambiando label del anexo dado que desde el designer no queda espacio para más caracteres
$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Certificado del registro público expedido dentro de los sesenta(60) días anteriores a la fecha de presentación de la solicitud, donde conste el nombre de la sociedad, la vigencia, el capital autorizado, el representante legal, los dignatarios, los poderes") {
          $(this).html("Certificado del registro público expedido dentro de los sesenta(60) días anteriores a la fecha de presentación de la solicitud, donde conste el nombre de la sociedad, la vigencia, el capital autorizado, el representante legal, los dignatarios, los poderes generales y datos de inscripción de la sociedad.");
      }
  });
});

$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Modelo del contrato que contemple por lo menos la información del Artículo 23 de la Ley 16 de 23 de Mayo de") {
          $(this).html("Modelo del contrato que contemple por lo menos la información del Artículo 23 de la Ley 16 de 23 de Mayo de 2005.");
      }
  });
});

// Chantal Valverde 10-Mar-2017
$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Escritura Pública") {
          $(this).html("Copia de la escritura pública donde conste la propiedad o derecho de uso, o del contrato de arrendamiento del local comercial donde estará ubicada la empresa, que presentará al momento de la notificación de la resolución que autoriza las operaciones de la casa de empeño");
      }
  });
});
    STEPAJAXCODE
  end
            
