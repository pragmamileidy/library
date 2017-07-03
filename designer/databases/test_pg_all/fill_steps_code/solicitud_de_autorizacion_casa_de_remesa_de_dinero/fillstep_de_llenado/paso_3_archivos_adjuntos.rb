
  class Paso3ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      // Chantal Valverde 21-Mar-2017, Asignando la etiqueta del adjunto "Modelo del Contrato"

$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Modelo del Contrato") {
          $(this).html("Modelo del contrato que contemple por lo menos la información del artículo 18 de la Ley 48 del 23 de julio de 2003.");
      }
  });
});
    STEPAJAXCODE
  end
            
