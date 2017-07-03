
  class Paso2HorarioDeOperacion < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      #Usado para print design
dias_completos = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")

if (dias_completos == '["Lunes a domingo y días feriados 24 horas"]')
    form_data.set("horario_de_operacion.horario.campo_oculto","X")
else
	form_data.set("horario_de_operacion.horario.campo_oculto","")
end

# Si se selecciona Horario corrido, las demás opciones deben estar desmarcadas. Igualmente, si se 
# selecciona(n) alguna(s) de las opciones de horario detallado, no puede estar seleccionado el 
# HORARIO 
# CORRIDO. 
# Si existe el conflicto de que está seleccionado el HORARIO CORRIDO y alguna(s) de las otras 
# opciones, desplegar un mensaje explicando el error y pidiendo solventar. NO PERMITIR AVANZAR.

_error = nil
_h1 = ""
_h1 += "#{form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura")}"
_h1 +=  "#{form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre")}"
_h1 +=  "#{form_data.get("horario_de_operacion.sabados.hora_de_apertura")}"
_h1 +=  "#{form_data.get("horario_de_operacion.sabados.hora_de_cierre")}"
_h1 +=  "#{form_data.get("horario_de_operacion.domingos.hora_de_apertura")}"
_h1 +=  "#{form_data.get("horario_de_operacion.domingos.hora_de_cierre")}"
_h1 +=  "#{form_data.get("horario_de_operacion.feriados.hora_de_apertura")}"
_h1 +=  "#{form_data.get("horario_de_operacion.feriados.hora_de_cierre")}"

horario_present = dias_completos.match("Lunes a domingo y días feriados 24 horas")

if  _h1.blank? && !horario_present.present?
  _error = "Debe indicar si el establecimiento farmacéutico opera en horario corrido o, de lo contrario los horarios detallados de operación."
  transition_errors << "#{_error}"
end

if  !_h1.blank? && horario_present.present?
  _error = "Si el establecimiento farmacéutico opera en horario corrido, no se deben indicar horarios detallados. Por favor indique sólo una de las dos opciones."
  transition_errors << "#{_error}"
end

if !horario_present.present? && !_h1.blank?
	_errorP = nil
	_errorP1 = nil
	_p1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura")
	_d1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre")
	_p2 = form_data.get("horario_de_operacion.sabados.hora_de_apertura")
	_d2 = form_data.get("horario_de_operacion.sabados.hora_de_cierre")
	_p3 = form_data.get("horario_de_operacion.domingos.hora_de_apertura")
	_d3 = form_data.get("horario_de_operacion.domingos.hora_de_cierre")
	_p4 = form_data.get("horario_de_operacion.feriados.hora_de_apertura")
	_d4 = form_data.get("horario_de_operacion.feriados.hora_de_cierre")

	_errorP = (!_p1.blank? and _d1.blank?)? "#{_errorP}" +"1" : _errorP
	_errorP = (!_p2.blank? and _d2.blank?)? "#{_errorP}" +" ,2" : _errorP
	_errorP = (!_p3.blank? and _d3.blank?)? "#{_errorP}" +" ,3" : _errorP
	_errorP = (!_p4.blank? and _d4.blank?)? "#{_errorP}" +" ,4" : _errorP
	_errorP1 = (_p1.blank? and !_d1.blank?)? "#{_errorP1}" +"1" : _errorP1
	_errorP1 = (_p2.blank? and !_d2.blank?)? "#{_errorP1}" +" ,2" : _errorP1
	_errorP1 = (_p3.blank? and !_d3.blank?)? "#{_errorP1}" +" ,3" : _errorP1
	_errorP1 = (_p4.blank? and !_d4.blank?)? "#{_errorP1}" +" ,4" : _errorP1

	if !_errorP.nil? || !_errorP1.nil?
		transition_errors << "Por favor verifique. El horario de operación debe indicarse correctamente tanto Hora de Apertura como Hora de Cierre" 
	end

    ##VALIDACION HORAS
    hora1 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura")
    hora2 = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre")
    hora3 = form_data.get("horario_de_operacion.sabados.hora_de_apertura")
    hora4 = form_data.get("horario_de_operacion.sabados.hora_de_cierre")
    hora5 = form_data.get("horario_de_operacion.domingos.hora_de_apertura")
    hora6 = form_data.get("horario_de_operacion.domingos.hora_de_cierre")
    hora7 = form_data.get("horario_de_operacion.feriados.hora_de_apertura")
    hora8 = form_data.get("horario_de_operacion.feriados.hora_de_cierre")

    if (Time.parse(hora1) > Time.parse(hora2))
        transition_errors <<  "Verifique la hora de apertura del horario de lunes a viernes. No puede ser mayor a la hora de cierre"
    end if hora1.present? && hora2.present?

    if (Time.parse(hora3) > Time.parse(hora4))
        transition_errors <<  "Verifique la hora de apertura del horario del Sábado. No puede ser mayor a la hora de cierre"
    end if hora3.present? && hora4.present?

    if (Time.parse(hora5) > Time.parse(hora6))
        transition_errors <<  "Verifique la hora de apertura del horario del Domingo. No puede ser mayor a la hora de cierre"
    end if hora5.present? && hora5.present?

    if (Time.parse(hora7) > Time.parse(hora8))
        transition_errors <<  "Verifique la hora de apertura de los días Feriados. No puede ser mayor a la hora de cierre"
    end if hora7.present? && hora8.present?

    #lunes a viernes
    horario_semana = ""
    semana_inicio = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_apertura")
    semana_fin = form_data.get("horario_de_operacion.lunes_a_viernes.hora_de_cierre")
    if (semana_inicio.present? && semana_fin.present?)
        horario_semana += "#{semana_inicio} a #{semana_fin}"
    elsif ( !semana_inicio.present? && semana_fin.present?)
        horario_semana += "N/A a #{semana_fin}"
    elsif (semana_inicio.present? && !semana_fin.present?)
        horario_semana += "#{semana_inicio} a N/A"
    end
    form_data.set("horario_de_operacion.lunes_a_viernes.campo_oculto",horario_semana)

    #sabados
    horario_sabado = ""
    sabado_inicio = form_data.get("horario_de_operacion.sabados.hora_de_apertura")
    sabado_fin = form_data.get("horario_de_operacion.sabados.hora_de_cierre")
    if (sabado_inicio.present? && sabado_fin.present?)
        horario_sabado += "#{sabado_inicio} a #{sabado_fin}"
    elsif ( !sabado_inicio.present? && sabado_fin.present?)
        horario_sabado += "N/A a #{sabado_fin}"
    elsif (sabado_inicio.present? && !sabado_fin.present?)
        horario_sabado += "#{sabado_inicio} a N/A"
    end
    form_data.set("horario_de_operacion.sabados.campo_oculto",horario_sabado)

    #domingos
    horario_domingo = ""
    domingo_inicio = form_data.get("horario_de_operacion.domingos.hora_de_apertura")
    domingo_fin = form_data.get("horario_de_operacion.domingos.hora_de_cierre")
    if (domingo_inicio.present? && domingo_fin.present?)
        horario_domingo += "#{domingo_inicio} a #{domingo_fin}"
    elsif ( !domingo_inicio.present? && domingo_fin.present?)
        horario_domingo += "N/A a #{domingo_fin}"
    elsif (domingo_inicio.present? && !domingo_fin.present?)
        horario_domingo += "#{domingo_inicio} a N/A"
    end
    form_data.set("horario_de_operacion.domingos.campo_oculto",horario_domingo)

    #feriados
    horario_feriado = ""
    feriado_inicio = form_data.get("horario_de_operacion.feriados.hora_de_apertura")
    feriado_fin = form_data.get("horario_de_operacion.feriados.hora_de_cierre")
    if (feriado_inicio.present? && feriado_fin.present?)
        horario_feriado += "#{feriado_inicio} a #{feriado_fin}"
    elsif ( !feriado_inicio.present? && feriado_fin.present?)
        horario_feriado += "N/A a #{feriado_fin}"
    elsif (feriado_inicio.present? && !feriado_fin.present?)
        horario_feriado += "#{feriado_inicio} a N/A"
    end
    form_data.set("horario_de_operacion.feriados.campo_oculto",horario_feriado)
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      function esconderCamposEmpresa(){
     $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
     $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).parents(".field-box").hide();
}
esconderCamposEmpresa();
$(function() {
    $( "input:radio" ).click(function() {
        console.log("checkkkk")
        checkHideField(this);
    });
});

function checkHideField(obj) {
    console.log(obj.name)
    console.log(obj.value)
    if (obj.value == "Sí" && obj.name=="[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]"){
        $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").show();
        $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).parents(".field-box").show();
    }else if (obj.value == "No" && obj.name=="[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]"){ 
         console.log("nooooooooo"); 
        $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
        $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).parents(".field-box").hide();
    }
}
    STEPAJAXCODE
  end
            
