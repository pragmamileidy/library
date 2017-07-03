
  class Paso2HorarioDeOperacion < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      
##########################LP 01-03-17
# Si se selecciona Horario corrido, las demás opciones deben estar desmarcadas. Igualmente, si se 
# selecciona(n) alguna(s) de las opciones de horario detallado, no puede estar seleccionado el 
# HORARIO 
# CORRIDO. 
# Si existe el conflicto de que está seleccionado el HORARIO CORRIDO y alguna(s) de las otras 
# opciones, desplegar un mensaje explicando el error y pidiendo solventar. NO PERMITIR AVANZAR.

_error = nil

_h1 = ""
_h1 += "#{form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.sabados.hora_de_apertura1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.sabados.hora_de_cierre1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.domingos.hora_de_apertura1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.domingos.hora_de_cierre1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.feriados.hora_de_apertura1")}"
_h1 +=  "#{form_data.get("horario_de_operacion.feriados.hora_de_cierre1")}"

# Chantal Valverde 02-Mar-2017, se modifico la ruta horario_de_operacion.horario_corrido.confirmacion

_h = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")

horario_present = _h.match("Lunes a domingo y días feriados 24 horas")

if  _h1.blank? && !horario_present.present?
  _error = "Debe indicar si el establecimiento farmacéutico opera en horario corrido o, de lo contrario los horarios detallados de operación."
  transition_errors << "#{_error}"
end

if  !_h1.blank? && horario_present.present?
  _error = "Si el establecimiento farmacéutico opera en horario corrido, no se deben indicar horarios detallados. Por favor indique sólo una de las dos opciones."
  transition_errors << "#{_error}"
end

if !horario_present.present? && !_h1.blank?
  _error = nil
  _error1 = nil
  _p1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura1")
  _d1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre1")
  _p2 = form_data.get("horario_de_operacion.sabados.hora_de_apertura1")
  _d2 = form_data.get("horario_de_operacion.sabados.hora_de_cierre1")
  _p3 = form_data.get("horario_de_operacion.domingos.hora_de_apertura1")
  _d3 = form_data.get("horario_de_operacion.domingos.hora_de_cierre1")
  _p4 = form_data.get("horario_de_operacion.feriados.hora_de_apertura1")
  _d4 = form_data.get("horario_de_operacion.feriados.hora_de_cierre1")
  _p5 = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")
  _error = (!_p1.blank? and _d1.blank?)? "#{_error}" +"1" : _error
  _error = (!_p2.blank? and _d2.blank?)? "#{_error}" +" ,2" : _error
  _error = (!_p3.blank? and _d3.blank?)? "#{_error}" +" ,3" : _error
  _error = (!_p4.blank? and _d4.blank?)? "#{_error}" +" ,4" : _error
  _error1 = (_p1.blank? and !_d1.blank?)? "#{_error1}" +"1" : _error1
  _error1 = (_p2.blank? and !_d2.blank?)? "#{_error1}" +" ,2" : _error1
  _error1 = (_p3.blank? and !_d3.blank?)? "#{_error1}" +" ,3" : _error1
  _error1 = (_p4.blank? and !_d4.blank?)? "#{_error1}" +" ,4" : _error1
  if !_error.nil? || !_error1.nil?
    transition_errors << "Por favor verifique. El horario de operación debe indicarse correctamente tanto Hora de Apertura como Hora de Cierre" 
  end

  ############LP Dependencia de horarios

  hora1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura1")
  hora2 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre1")
  hora3 = form_data.get("horario_de_operacion.sabados.hora_de_apertura1")
  hora4 = form_data.get("horario_de_operacion.sabados.hora_de_cierre1")
  hora5 = form_data.get("horario_de_operacion.domingos.hora_de_apertura1")
  hora6 = form_data.get("horario_de_operacion.domingos.hora_de_cierre1")
  hora7 = form_data.get("horario_de_operacion.feriados.hora_de_apertura1")
  hora8 = form_data.get("horario_de_operacion.feriados.hora_de_cierre1")

  if (Time.parse(hora1) > Time.parse(hora2))
    transition_errors <<  "Verifique la hora de apertura del horario de lunes a viernes. No puede ser mayor a la hora de cierre"
  end if hora1.present? && hora2.present?
  
  if (Time.parse(hora3) > Time.parse(hora4))
    transition_errors <<  "Verifique la hora de apertura del horario del Sábado. No puede ser mayor a la hora de cierre"
  end if hora3.present? && hora3.present?
  
  if (Time.parse(hora5) > Time.parse(hora6))
    transition_errors <<  "Verifique la hora de apertura del horario del Domingo. No puede ser mayor a la hora de cierre"
  end if hora5.present? && hora5.present?
  
  if (Time.parse(hora7) > Time.parse(hora8))
    transition_errors <<  "Verifique la hora de apertura de los días Feriados. No puede ser mayor a la hora de cierre"
  end if hora7.present? && hora8.present?
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
