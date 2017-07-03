
  class Paso4Confirmacion < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      anno = Time.now.year
mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day

form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)

if form_data.get("confirmacion_culminacion_de_tramite.confirmacion_de_formulario.si_no")=="NO"
   transition_errors << "Para realizar el envío del formulario debe confirmar con SI el llenado del mismo."
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
