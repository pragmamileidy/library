
  class Paso3RegenciaYTurnos < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      # Si se selecciona Horario corrido, las demás opciones deben estar desmarcadas. Igualmente, si se 
# selecciona(n) alguna(s) de las opciones de horario detallado, no puede estar seleccionado el 
# HORARIO 
# CORRIDO. 
# Si existe el conflicto de que está seleccionado el HORARIO CORRIDO y alguna(s) de las otras 
# opciones, desplegar un mensaje explicando el error y pidiendo solventar. NO PERMITIR AVANZAR.


_error = nil
_h2 = ""
_h2 += "#{form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura")}"
_h2 += "#{form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre")}"
_h2 += "#{form_data.get("horario_de_regencia.sabados.hora_de_apertura")}"
_h2 += "#{form_data.get("horario_de_regencia.sabados.hora_de_cierre")}"
_h2 += "#{form_data.get("horario_de_regencia.domingos.hora_de_apertura")}"
_h2 += "#{form_data.get("horario_de_regencia.domingos.hora_de_cierre")}"
_h2 += "#{form_data.get("horario_de_regencia.feriados.hora_de_apertura")}"
_h2 += "#{form_data.get("horario_de_regencia.feriados.hora_de_cierre") }"
#_h3 = "#{form_data.get("horario_de_regencia.trabaja_en_otra_empresa.seleccione")}"
#_h3 += "#{form_data.get("horario_de_regencia.rotacion_de_horario.seleccione")}"

#if (_h3.blank? && _h2.blank?)
if _h2.blank?
    _error = "Debe indicar los horarios de Regencia."
        transition_errors << "#{_error}"
end

if !_h2.blank?
    _error = nil
    _error1 = nil
    ##VALIDACION HORAS DE REGENCIA
    hora1 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura")
    hora2 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre")
    hora3 = form_data.get("horario_de_regencia.sabados.hora_de_apertura")
    hora4 = form_data.get("horario_de_regencia.sabados.hora_de_cierre")
    hora5 = form_data.get("horario_de_regencia.domingos.hora_de_apertura")
    hora6 = form_data.get("horario_de_regencia.domingos.hora_de_cierre")
    hora7 = form_data.get("horario_de_regencia.feriados.hora_de_apertura")
    hora8 = form_data.get("horario_de_regencia.feriados.hora_de_cierre")

    _error = (!hora1.blank? and hora2.blank?)? "#{_error}" +"1" : _error
    _error = (!hora3.blank? and hora4.blank?)? "#{_error}" +" ,2" : _error
    _error = (!hora5.blank? and hora6.blank?)? "#{_error}" +" ,3" : _error
    _error = (!hora7.blank? and hora8.blank?)? "#{_error}" +" ,4" : _error
    _error1 = (hora1.blank? and !hora2.blank?)? "#{_error1}" +"1" : _error1
    _error1 = (hora3.blank? and !hora4.blank?)? "#{_error1}" +" ,2" : _error1
    _error1 = (hora5.blank? and !hora6.blank?)? "#{_error1}" +" ,3" : _error1
    _error1 = (hora7.blank? and !hora8.blank?)? "#{_error1}" +" ,4" : _error1

    if !_error.nil? || !_error1.nil?
        transition_errors << "Por favor verifique. El Horario de Regencia debe indicarse correctamente tanto Hora de Apertura como Hora de Cierre" 
    end

    if (Time.parse(hora1) > Time.parse(hora2))
        transition_errors <<  "En la Sección Horario de Regencia, por favor verifique la hora de apertura del horario de lunes a viernes. No puede ser mayor a la hora de cierre"
    end if (hora1.present? && hora2.present?)

    if (Time.parse(hora3) > Time.parse(hora4))
        transition_errors <<  "En la Sección Horario de Regencia, por favor verifique la hora de apertura del horario del Sábado. No puede ser mayor a la hora de cierre"
    end if (hora3.present? && hora4.present?)

    if (Time.parse(hora5) > Time.parse(hora6))
        transition_errors <<  "En la Sección Horario de Regencia, por favor verifique la hora de apertura del horario del Domingo. No puede ser mayor a la hora de cierre"
    end if (hora5.present? && hora6.present?)

    if (Time.parse(hora7) > Time.parse(hora8))
        transition_errors <<  "En la Sección Horario de Regencia, por favor verifique la hora de apertura de los días Feriados. No puede ser mayor a la hora de cierre"
    end if (hora7.present? && hora8.present?)
end


#Horario de Supervisión Farmacéutica

_err = nil
#_h4 = form_data.get("horario_de_supervision_farmaceutica.horario_corrido.seleccione")
_h5 = ""
_h5 += "#{form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_apertura")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_cierre")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_apertura")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_cierre")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_apertura")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_cierre")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_apertura")}"
_h5 +=    "#{form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_cierre") }"
#_h6 = form_data.get("horario_de_supervision_farmaceutica.trabaja_en_otra_empresa.seleccione")+
#       form_data.get("horario_de_supervision_farmaceutica.rotacion_de_horario.seleccione")

#if (_h6.blank? && _h5.blank? && _h4.blank?)
if _h5.blank?
    _err = "Debe indicar los horarios de la Supervisión Farmacéutica."
        transition_errors << "#{_err}"
end

if !_h5.blank?
    ##VALIDACION HORAS DE SUPERVISION
    hora9 = form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_apertura")
    hora10 = form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_cierre")
    hora11 = form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_apertura")
    hora12 = form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_cierre")
    hora13 = form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_apertura")
    hora14 = form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_cierre")
    hora15 = form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_apertura")
    hora16 = form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_cierre")

    _errorS = nil
    _errorS1 = nil

    _errorS = (!hora9.blank? and hora10.blank?)? "#{_errorS}" +"1" : _errorS
    _errorS = (!hora11.blank? and hora12.blank?)? "#{_errorS}" +" ,2" : _errorS
    _errorS = (!hora13.blank? and hora14.blank?)? "#{_errorS}" +" ,3" : _errorS
    _errorS = (!hora15.blank? and hora16.blank?)? "#{_errorS}" +" ,4" : _errorS
    _errorS1 = (hora9.blank? and !hora10.blank?)? "#{_errorS1}" +"1" : _errorS1
    _errorS1 = (hora11.blank? and !hora12.blank?)? "#{_errorS1}" +" ,2" : _errorS1
    _errorS1 = (hora13.blank? and !hora14.blank?)? "#{_errorS1}" +" ,3" : _errorS1
    _errorS1 = (hora15.blank? and !hora16.blank?)? "#{_errorS1}" +" ,4" : _errorS1

    if !_errorS.nil? || !_errorS1.nil?
        transition_errors << "Por favor verifique. El horario de Supervición Farmacéutica debe indicarse correctamente tanto Hora de Apertura como Hora de Cierre" 
    end

    if (Time.parse(hora9) > Time.parse(hora10))
        transition_errors <<  "En la Sección Horario de Supervición Farmacéutica, por favor verifique la hora de apertura del horario de lunes a viernes. No puede ser mayor a la hora de cierre"
    end if (hora9.present? && hora10.present?)

    if (Time.parse(hora11) > Time.parse(hora12))
        transition_errors <<  "En la Sección Horario de Supervición Farmacéutica, por favor verifique la hora de apertura del horario del Sábado. No puede ser mayor a la hora de cierre"
    end if (hora11.present? && hora12.present?)

    if (Time.parse(hora13) > Time.parse(hora14))
        transition_errors <<  "En la Sección Horario de Supervición Farmacéutica, por favor verifique la hora de apertura del horario del Domingo. No puede ser mayor a la hora de cierre"
    end if (hora13.present? && hora14.present?)

    if (Time.parse(hora15) > Time.parse(hora16))
        transition_errors <<  "En la Sección Horario de Supervición Farmacéutica, por favor verifique la hora de apertura de los días Feriados. No puede ser mayor a la hora de cierre"
    end if (hora15.present? && hora16.present?)
end

# Obtener valor del config
valor = @config.route("Rates-payment-payment-payment")

if valor == "Electrónico"

        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Electrónico")

end
if valor == "Manual"

        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")

end

# Chantal Valverde. 13-Abr-2017
#Nombre del regente

primer_nombre = form_data.get("datos_del_regente.datos_de_la_persona.primer_nombre")
segundo_nombre = form_data.get("datos_del_regente.datos_de_la_persona.segundo_nombre")
primer_apellido = form_data.get("datos_del_regente.datos_de_la_persona.primer_apellido")
segundo_apellido = form_data.get("datos_del_regente.datos_de_la_persona.segundo_apellido")
apellido_casada = form_data.get("datos_del_regente.datos_de_la_persona.apellido_de_casada")
nombre_completo = "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido} #{apellido_casada}"
form_data.set("datos_del_regente.datos_de_la_persona.nombre_completo",nombre_completo)

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
	$("#field_datos_del_regente_informacion_de_residencia_localizacion_provincia_lista").change(function(){
		var prov = $("#field_datos_del_regente_informacion_de_residencia_localizacion_provincia_lista").find(':selected').val();
		distritos(prov);
	});
	$("#field_datos_del_regente_informacion_de_residencia_localizacion_distrito_lista").change(function(){
		var distrito = $("#field_datos_del_regente_informacion_de_residencia_localizacion_distrito_lista").find(':selected').val();
		corregimientos(distrito);
	});
	});

function distritos(provincia) {
 params = {
            "service_name":"ws_panama_distritos/where",
            "provincia":provincia
          }
$.post(
            "/proxy_service/get_service",
            params,
            function(data){
				var dist;
				var html_options = "";
				for (x in data){
					dist = data[x];
					html_options = html_options+'<option value="'+dist["distrito"] +'">'+dist["distrito"] +'</option>'
				}	
				$("#field_datos_del_regente_informacion_de_residencia_localizacion_distrito_lista").html(html_options);
				$("#field_datos_del_regente_informacion_de_residencia_localizacion_corregimiento_lista").html("");
            }
          );
}
function corregimientos(distrito) {
 params = {
            "service_name":"ws_panama_corregimientos/where",
            "distrito":distrito
          }
$.post(
            "/proxy_service/get_service",
            params,
            function(data){
				var corr;
				var html_options = "";
				for (x in data){
					corr = data[x];
					html_options = html_options+'<option value="'+corr["corregimiento"] +'">'+corr["corregimiento"] +'</option>'
				}	
				$("#field_datos_del_regente_informacion_de_residencia_localizacion_corregimiento_lista").html(html_options);
            }
          );
}





// //Comentado LP 09-03-17
// /////////////////// validacion activar y esconder campos de empresa
// function esconderCamposEmpresa(){
//      $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").attr('disabled',true);
//      $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).attr('disabled',true);
// }

// if ($("input[name='[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]']:checked").val() != "Sí" ){
//     esconderCamposEmpresa();
// }

// $(function() {
//     $( "input:radio" ).click(function() {
//         console.log("checkkkk")
//         checkHideField(this);
//     });
// });

// function checkHideField(obj) {
//     if (obj.value == "Sí" && obj.name=="[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]"){
//         $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").attr('disabled',false);
//         $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).attr('disabled',false);
//     }else if (obj.value == "No" && obj.name=="[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]"){ 
//         $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").val("");
//         $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).prop('checked', false);
//         $("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").attr('disabled',true);
//         $(document.getElementsByName("[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]")).attr('disabled',true);
//     }
// }


//-------------------------------------------------------------------------------------------
// LP Para ocultar o mostrar campo dependiendo dependiendo del valor del radio seleccionado 09/03/17
//-------------------------------------------------------------------------------------------
$(document).ready(function(){
	//ocultar campos pordefecto
	$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
	$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]"]').parents(".field-box").hide();
	//Comportamiento al cambiar selección del radio
	$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]"]').change(function() {  
	//Meter el valor seleccionado del radio butonn en una variable	
		var dato = $("input[name='[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]']:checked").val();     
		if(dato =="Sí"){
			//mostrar campo especificar
				$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").show();
				$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]"]').parents(".field-box").show();
				
			} else {
			//Limpiar campo nombre
			$('#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa').val("");
			//ocultar campo nombre
			$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
			//Limpiar tipo empresa
			$("input[name='[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]']:checked").prop('checked', false);
			//ocultar tipo empresa
			$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]"]').parents(".field-box").hide();

		} 	
	}); 
	//Mantener cambios entre pasos
		//Meter el valor seleccionado del radio butonn en una variable	
		var dato = $("input[name='[field][horario_de_regencia_trabaja_en_otra_empresa_seleccione]']:checked").val();     
		if(dato =="Sí"){
			//mostrar campo especificar
				$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").show();
				$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]"]').parents(".field-box").show();
				
			} else {
			//Limpiar campo nombre
			$('#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa').val("");
			//ocultar campo nombre
			$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
			//Limpiar tipo empresa
			$("input[name='[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]']:checked").val("");
			//ocultar tipo empresa
			$('input[name="[field][horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa]"]').parents(".field-box").hide();

		} 	
});

// Chantal Valverde 12-Abr-2017, modificación de etiquetas

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Teléfono*") {
          $(this).html("Número de teléfono Fijo*");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número Celular") {
          $(this).html("Número de teléfono Móvil");
      }
  });
});
    STEPAJAXCODE
  end
            
