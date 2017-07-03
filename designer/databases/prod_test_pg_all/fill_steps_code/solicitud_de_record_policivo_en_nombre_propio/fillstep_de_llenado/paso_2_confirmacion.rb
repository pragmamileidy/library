
  class Paso2Confirmacion < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      anno = Time.now.year
mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day

form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)

if form_data.get("confirmacion.confirmacion_de_formulario.si_no")=="NO"
   transition_errors << "Para realizar el envío del formulario debe confirmar con SI el llenado del mismo."
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){ 
 $( function() {
   $("span").each (function(){
     if ($(this).html().trim() == "Sección: Confirmación de Solicitud") {  
       $(this).html("¿Está seguro que desea finalizar su trámite?"); 
     }
   });
 });

 $( function() {
   $("span").each (function(){
     if ($(this).html().trim() == "Declaro bajo juramento que la información suministrada a través de este formulario es correcta.") {  
       $(this).html(""); 
     }
   });
 });
});

$(document).ready(function(){ 
  TiDoc = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento');
  nacio = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_nacionalidad');
  if ($(TiDoc).html() == "Cedula") {
    $(nacio).html("Nacional");
  } else if($(TiDoc).html() == "Pasaporte") {
    $(nacio).html("Extranjero");
  }
});

    STEPAJAXCODE
  end
            
