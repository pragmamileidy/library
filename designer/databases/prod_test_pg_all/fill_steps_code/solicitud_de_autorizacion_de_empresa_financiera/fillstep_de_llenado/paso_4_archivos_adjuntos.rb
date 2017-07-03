
  class Paso4ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $(".hint").each (function(){
      if ($(this).html().trim() == "Artículo 12") {
          $(this).html("Artículo 12 de la Ley 42 de 23 de julio de 2001: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una empresa financiera, deberán estar domiciliados en la República de Panamá");
      }
  });
});

// Chantal Valverde 10-Mar-2017
$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Registro público") {
          $(this).html("Certificación de registro público expedido dentro de los treinta (30) días anteriores a la fecha de presentación de la solicitud donde conste la vigencia y datos de inscripción de la sociedad, su capital social de quinientos mil (B/. 500,000.00) y el nombre de sus directores, dignatarios y representante legal y apoderado, si lo hubiere.");
      }
  });
});

// Chantal Valverde 10-Mar-2017
$( function() {
  $(".hint").each (function(){
      if ($(this).html().trim() == "Artículo 12") {
          $(this).html("Artículo 12 de la Ley 42 de 23 de julio de 2001: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una empresa financiera, deberán estar domiciliados en la República de Panamá");
      }
  });
});

// Chantal Valverde 10-Mar-2017
$( function() {
  $(".hint").each (function(){
      if ($(this).html().trim() == "extranjeros") {
          $(this).html("De ser extranjeros copia del pasaporte debidamente cotejado por notario público panameño, o acompañada de la certificación diplomática acreditada en el país o de la autoridad correspondiente en el lugar de emisión. (Según el artículo 3 numeral 1 del decreto 213 del 26 de Octubre, de 2010).");
      }
  });
});
    STEPAJAXCODE
  end
            
