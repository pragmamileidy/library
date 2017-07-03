
  class Paso8DatosDelSolicitante < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
if @owner["kind_of_user_type"] == "NaturalPerson"
nombre2 = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_nombre")
nombre3 = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_nombre")
nombre4 = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_apellido")
nombre5 = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_apellido")
nombre6 = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.apellido_de_casada")

nombre_completo = nombre2.to_s + " " + nombre3.to_s + " " + nombre4.to_s + " " + nombre5.to_s + " " + nombre6.to_s

form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.nombre_completo", nombre_completo)
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Teléfono*") {
          $(this).html("Número de Teléfono (Fijo)*");
      }
  });
});
    STEPAJAXCODE
  end
            
