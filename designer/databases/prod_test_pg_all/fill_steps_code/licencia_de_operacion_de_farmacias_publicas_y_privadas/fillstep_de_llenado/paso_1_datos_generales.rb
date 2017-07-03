
  class Paso1DatosGenerales < TemplateCode::Step

    on_becoming do
      ##Setear valor del tipo de solicitud 28-02-17
tipo = form_data.get("tipo_de_solicitud.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia")
form_data.set("datos_del_establecimiento.datos_de_la_empresa.siglas",tipo)
    end

    on_transition do
      #Chantal Valverde 28-Feb-2017 
#CONCATENACION DE DATOS PARA OBTENER EL NOMBRE COMPLETO DEL REPRESENTANTE PARA EL PRINTDESIGN
primer_nombre = form_data.get("datos_del_representante.datos_de_la_persona.primer_nombre")
segundo_nombre = form_data.get("datos_del_representante.datos_de_la_persona.segundo_nombre")
primer_apellido = form_data.get("datos_del_representante.datos_de_la_persona.primer_apellido")
segundo_apellido = form_data.get("datos_del_representante.datos_de_la_persona.segundo_apellido")
nombre_completo = "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido}"
form_data.set("datos_del_representante.datos_de_la_persona.nombre_completo", nombre_completo)
# FIN 
 


###Limpiar valor de licencia de opreaciones si tipo de solicitud es igual a inicio
###Lp 06-03-17
valor = form_data.get("tipo_de_solicitud.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia")

if valor =="Inicio"

  form_data.set("datos_del_establecimiento.registro_de_empresa.licencia_de_operacion","")

end
#x
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

//Mostrar u ocultar parte dependiendo del tipo de solicitud
	var tipos = $("#field_datos_del_establecimiento_datos_de_la_empresa_siglas").val();  
	if (tipos == "Inicio"){
		$("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").hide();
	} else{	
		$("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").show();
		}


//Filtrado provincias 
$(function() {
	$('#id_del_combo_distritos').html("");
	$('#id_del_combo_corregimientos').html("");
})
$( function() {
	$("#field_datos_del_establecimiento_direccion_provincia_lista").change(function(){
		var prov = $("#field_datos_del_establecimiento_direccion_provincia_lista").find(':selected').val();
		distritos(prov);
	});
	$("#field_datos_del_establecimiento_direccion_distrito_lista").change(function(){
		var distrito = $("#field_datos_del_establecimiento_direccion_distrito_lista").find(':selected').val();
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
			$("#field_datos_del_establecimiento_direccion_distrito_lista").html(html_options);
			$("#field_datos_del_establecimiento_direccion_corregimiento_lista").html("");
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
			$("#field_datos_del_establecimiento_direccion_corregimiento_lista").html(html_options);
		}
		);
}



$(document).ready(function(){

    cedula = $("#field_datos_del_representante_datos_de_la_persona_cedula");
    if ($(cedula).val() == ""){
        $("#field_datos_del_representante_datos_de_la_persona_cedula").parent().parent().hide();
        $("#field_datos_del_representante_datos_de_la_persona_pasaporte").parent().parent().show();
    }
    pasaporte = $("#field_datos_del_representante_datos_de_la_persona_pasaporte");
    if ($(pasaporte).val() == "") {
        $("#field_datos_del_representante_datos_de_la_persona_cedula").parent().parent().show();
        $("#field_datos_del_representante_datos_de_la_persona_pasaporte").parent().parent().hide();
    }

});

    STEPAJAXCODE
  end
            
