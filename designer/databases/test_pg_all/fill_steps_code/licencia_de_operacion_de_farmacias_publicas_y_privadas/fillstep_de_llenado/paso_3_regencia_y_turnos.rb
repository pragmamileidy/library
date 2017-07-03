
  class Paso3RegenciaYTurnos < TemplateCode::Step

    on_becoming do
      ####Validaciòn para print LP 01-03-17
#### Comentada por Chantal Valverde 07-Mar-2017, está la misma asignación en el on-becoming del Paso 4 
##dato = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")
##if dato == "Lunes a domingo y días feriados 24 horas"
##    form_data.set("horario_de_operacion.horario.campo_oculto","Sí")
##else
##    form_data.set("horario_de_operacion.horario.campo_oculto","No")
##end
    end

    on_transition do
      #Chantal Valverde 01-Mar-2017 
#CONCATENACION DE DATOS PARA OBTENER EL NOMBRE COMPLETO DEL REGENTE PARA EL PRINTDESIGN
primer_nombre = form_data.get("datos_del_regente_farmaceutico.datos_de_la_persona.primer_nombre")
segundo_nombre = form_data.get("datos_del_regente_farmaceutico.datos_de_la_persona.segundo_nombre")
primer_apellido = form_data.get("datos_del_regente_farmaceutico.datos_de_la_persona.primer_apellido")
segundo_apellido = form_data.get("datos_del_regente_farmaceutico.datos_de_la_persona.segundo_apellido")
nombre_completo = "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido}"
form_data.set("datos_del_regente_farmaceutico.datos_de_la_persona.nombre_completo", nombre_completo)
# FIN 

# Obtener valor del config
valor = @config.route("Rates-payment-payment-payment")

if valor == "Electrónico"

        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Electrónico")

end
if valor == "Manual"

        form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")

end


_error = nil
_h1 = ""
_h1 +=  form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura1")
_h1 += 	form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre1")
_h1 +=	form_data.get("horario_de_regencia.sabados.hora_de_apertura1")
_h1 += 	form_data.get("horario_de_regencia.sabados.hora_de_cierre1")
_h1 +=  form_data.get("horario_de_regencia.domingos.hora_de_apertura1")
_h1 +=	form_data.get("horario_de_regencia.domingos.hora_de_cierre1")
_h1 +=	form_data.get("horario_de_regencia.feriados.hora_de_apertura1")
_h1 +=	form_data.get("horario_de_regencia.feriados.hora_de_cierre1") 
_h = form_data.get("horario_de_regencia.horario_corrido.confirmacion")

if  _h1.blank?
	_error = "Debe indicar el Horario de Regencia."
        transition_errors << "#{_error}"
end

if  !_h1.blank?
	_error = nil
	_error1 = nil
	_p1 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura1")
	_d1 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre1")
	_p2 = form_data.get("horario_de_regencia.sabados.hora_de_apertura1")
	_d2 = form_data.get("horario_de_regencia.sabados.hora_de_cierre1")
	_p3 = form_data.get("horario_de_regencia.domingos.hora_de_apertura1")
	_d3 = form_data.get("horario_de_regencia.domingos.hora_de_cierre1")
	_p4 = form_data.get("horario_de_regencia.feriados.hora_de_apertura1")
	_d4 = form_data.get("horario_de_regencia.feriados.hora_de_cierre1")
	_p5 = form_data.get("horario_de_regencia.horario.lunes_a_domingo_y_dias_feriados_24_horas")
	_error = (!_p1.blank? and _d1.blank?)? "#{_error}" +"1" : _error
	_error = (!_p2.blank? and _d2.blank?)? "#{_error}" +" ,2" : _error
	_error = (!_p3.blank? and _d3.blank?)? "#{_error}" +" ,3" : _error
	_error = (!_p4.blank? and _d4.blank?)? "#{_error}" +" ,4" : _error
	_error1 = (_p1.blank? and !_d1.blank?)? "#{_error1}" +"1" : _error1
	_error1 = (_p2.blank? and !_d2.blank?)? "#{_error1}" +" ,2" : _error1
	_error1 = (_p3.blank? and !_d3.blank?)? "#{_error1}" +" ,3" : _error1
	_error1 = (_p4.blank? and !_d4.blank?)? "#{_error1}" +" ,4" : _error1
	if !_error.nil?	|| !_error1.nil?
		transition_errors << "Por favor verifique. El horario de regencia debe indicarse correctamente tanto Hora de Apertura como Hora de Cierre" 
	end


	############LP Dependencia de horarios

	hora1 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura1")
	hora2 = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre1")
	hora3 = form_data.get("horario_de_regencia.sabados.hora_de_apertura1")
	hora4 = form_data.get("horario_de_regencia.sabados.hora_de_cierre1")
	hora5 = form_data.get("horario_de_regencia.domingos.hora_de_apertura1")
	hora6 = form_data.get("horario_de_regencia.domingos.hora_de_cierre1")
	hora7 = form_data.get("horario_de_regencia.feriados.hora_de_apertura1")
	hora8 = form_data.get("horario_de_regencia.feriados.hora_de_cierre1")

	if (Time.parse(hora1) > Time.parse(hora2))
		transition_errors <<  "Verifique la hora de apertura del horario de lunes a viernes. No puede ser mayor a la hora de cierre"
	end if hora1.present? && hora2.present?
	
	if (Time.parse(hora3) > Time.parse(hora4))
		transition_errors <<  "Verifique la hora de apertura del horario del Sábado. No puede ser mayor a la hora de cierre"
	end if hora3.present? && hora4.present?
	
	if (Time.parse(hora5) > Time.parse(hora6))
		transition_errors <<  "Verifique la hora de apertura del horario del Domingo. No puede ser mayor a la hora de cierre"
	end if hora5.present? && hora6.present?
	
	if (Time.parse(hora7) > Time.parse(hora8))
		transition_errors <<  "Verifique la hora de apertura de los días Feriados. No puede ser mayor a la hora de cierre"
	end if hora7.present? && hora8.present?
end


    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //Cambiar nombres
$( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Teléfono*") {
          $(this).html("Número de Teléfono Fijo*");
      }
  });
});

$( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Fax") {
          $(this).html("Número de Teléfono Móvil");
      }
  });
});


//-------------------------------------------------------------------------------------------
// LP Para ocultar o mostrar campo dependiendo dependiendo del valor del radio seleccionado 28/02/17
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


//Filtrado provincias lp 01-03-17
//Mostrar u ocultar parte dependiendo del tipo de solicitud
	var tipos = $("#field_datos_del_establecimiento_datos_de_la_empresa_siglas").val();  
	if (tipos == "Inicio"){
		$("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").hide();
		// Chantal Valverde 6-Mar-2017 - Limpiar el campo Licencia de Operación 
		$("input[name='[field][datos_del_establecimiento_registro_de_empresa_licencia_de_operacion]']:checked").val("");
	} else{	
		$("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").show();
		}


//Filtrado provincias 
$(function() {
	$('#id_del_combo_distritos').html("");
	$('#id_del_combo_corregimientos').html("");
})
$( function() {
	$("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_provincia_lista").change(function(){
		var prov = $("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_provincia_lista").find(':selected').val();
		distritos(prov);
	});
	$("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_distrito_lista").change(function(){
		var distrito = $("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_distrito_lista").find(':selected').val();
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
			$("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_distrito_lista").html(html_options);
			$("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_corregimiento_lista").html("");
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
			$("#field_datos_del_regente_farmaceutico_informacion_de_residencia_localizacion_corregimiento_lista").html(html_options);
		}
		);
}

    STEPAJAXCODE
  end
            
