
  class Paso1CierreDeSolicitud < TemplateCode::Step

    on_becoming do
      _idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]


form_data.set("cerrado_por.datos_del_funcionario_generico.usuario", _agente["name"])
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //Cambiar nombres
$( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Teléfono") {
          $(this).html("Número de Teléfono Fijo");
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

$(document).ready(function(){

    cedula = $("#field_datos_del_representante_datos_de_la_persona_cedula");
    if ($(cedula).html() == ""){
        $("#field_datos_del_representante_datos_de_la_persona_cedula").parent().parent().hide();
        $("#field_datos_del_representante_datos_de_la_persona_pasaporte").parent().parent().show();
    }
    pasaporte = $("#field_datos_del_representante_datos_de_la_persona_pasaporte");
    if ($(pasaporte).html() == "") {
        $("#field_datos_del_representante_datos_de_la_persona_cedula").parent().parent().show();
        $("#field_datos_del_representante_datos_de_la_persona_pasaporte").parent().parent().hide();
    }

});




$(document).ready(function(){

    $.each( $('[id*=turnos_farmaceuticos_]'), function(index, campo) {

        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   

        var inicioRuta = "#field_turnos_farmaceuticos";
        var mod1 = inicioRuta.concat(pos);

        var nomb = "_turno_farmaceutico_nombre";

        var nombre = mod1.concat(nomb);


        if($(nombre).html() != ""){ 
            $(nombre).parents(".section-box").show();
        }else {
            $(nombre).parents(".section-box").hide();
        }

        $(nombre).parents(".section-box").next().hide();

    });
});

$(document).ready(function(){ 
	//Mantener cambios entre pasos
		//Meter el valor seleccionado del radio butonn en una variable	
		var dato = $("#field_horario_de_regencia_trabaja_en_otra_empresa_seleccione").html();     
		if(dato =="Sí"){
			//mostrar campo especificar
				$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").show();
				$("#field_horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa").parents(".field-box").show();
				
			} else {
			//ocultar campo nombre
			$("#field_horario_de_regencia_trabaja_en_otra_empresa_nombre_de_la_empresa").parents(".field-box").hide();
			$("#field_horario_de_regencia_trabaja_en_otra_empresa_tipo_de_empresa").parents(".field-box").hide();

		} 	
});
    STEPAJAXCODE
  end
            
