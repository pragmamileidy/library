
  class UltimoPasoConfirmacion < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      if form_data.get("confirmacion.confirmacion_de_formulario.si_no")=="NO"
   transition_errors << "Para realizar el envío del formulario debe confirmar con SÍ el llenado del mismo."
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
