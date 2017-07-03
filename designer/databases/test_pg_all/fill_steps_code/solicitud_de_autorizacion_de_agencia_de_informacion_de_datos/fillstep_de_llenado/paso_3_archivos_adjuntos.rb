
  class Paso3ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $(".hint").each (function(){
      if ($(this).html().trim() == "Artículo 16") {
          $(this).html("Artículo 16 de la Ley 22 de mayo del 2002: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una agencia de información de datos sobre historial de crédito, deberán estar domiciliados en la República de Panamá.");
      }
  });
});
    STEPAJAXCODE
  end
            
