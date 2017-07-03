
  class Paso1DeAcuerdoALaSolicitud < TemplateCode::Step

    on_becoming do
       form_data.set("de_acuerdo_a_la_solicitud_mici.de_acuerdo_a_la_solicitud.lo_que_se_desea_operar","Agencia de Información de datos.")
 form_data.set("de_acuerdo_a_la_solicitud_mici.de_acuerdo_a_la_solicitud.ley_correspondiente","Ley 24 del 22 de mayo de 2002.")
 form_data.set("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.se_dedicara_a_ofrecer_texto","Agencia de Información de datos.")
    end

    on_transition do
      #VERIFICACIÒN NUMERO DE CEDULA DEL REPRESENTANTE LEGAL DE LA EMPRESA NO PERTENEZCA A UN DIFUNTO
### Comentado por Chantal Valverde 09-Mar-2017, porque la sección Representante Legal no va en el trámite.                            
##representante = form_data.get("informacion_de_persona_juridica.representante_legal.cedula")   
##_person = @application["person_id"]
##_owner = @application["owner_person_id"]
##if _person != _owner
##    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{representante}")).parsed_response
##    datosre = result["response"]
##    if datosre.blank? 
##        transition_errors << "La Cédula del representante no fue encontrada. Por favor, verifique." 
##    else            
##        difuntore = datosre["cod_mensaje"]
##        if (difuntore == "534")
##            transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{representante} corresponde a un ciudadano Difunto."
##        end
##    end
##end
### Hasta aquí el comentario Chantal Valverde

#:::: Fecha del contrato o convenio de la asociación
fecha_convenio = form_data.get("datos_de_la_empresa_a_inscribir.datos_generales_de_empresa.fecha_de_inicio_de_operaciones")
if (fecha_convenio.to_date > Date.today)
    transition_errors << "La fecha de inicio de operaciones de la empresa no puede ser posterior a la fecha actual, por favor verifique."
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(function() {
$('#id_del_combo_distritos').html("");
$('#id_del_combo_corregimientos').html("");
})
$( function() {
	$("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_provincia_lista").change(function(){
		var prov = $("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_provincia_lista").find(':selected').val();
		distritos(prov);
	});
	$("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_distrito_lista").change(function(){
		var distrito = $("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_distrito_lista").find(':selected').val();
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
				$("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_distrito_lista").html(html_options);
				$("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_corregimiento_lista").html("");
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
				$("#field_datos_de_la_empresa_a_inscribir_datos_de_ubicacion_corregimiento_lista").html(html_options);
            }
          );
}

////////////////////////// Cambiando labels

$( function() {
  $(".field-hint").each (function(){
      if ($(this).html().trim() == "Nombre de la firma a la cual pertenece el abogado litigante") {
          $(this).html("Nombre de la firma a la cual pertenece el abogado");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Edificio/Casa*") {
          $(this).html("Edificio o Casa, local*");
      }
  });
});
    STEPAJAXCODE
  end
            
