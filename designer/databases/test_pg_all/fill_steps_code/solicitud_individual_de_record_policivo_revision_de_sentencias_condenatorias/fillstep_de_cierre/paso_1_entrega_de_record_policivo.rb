
  class Paso1EntregaDeRecordPolicivo < TemplateCode::Step

    on_becoming do
      #::: OBTENER PROVINCIA DE REVISION DE LA SOLICITUD EN ATTACHMENT :::#
_app_id = @application["id"]
result = WebserviceConsumer.get('/service/dij_helper/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
provincia = result["response"]["provincia"]
form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)

#::: INICIALIZAR LOS DATOS DEL AGENTE :::#
_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]
form_data.set("confirmar_entrega_record.datos_del_funcionario_generico.usuario", _agente["name"])

    end

    on_transition do
      #::: GENERAR CÓDIGO UNICO Y DATOS PARA IMPRESIÓN :::#
codigo = form_data.get("codigo_unico_dij.codigo_unico_dij.dia")

#::: GENERAR FECHA PARA IMPRESION :::#
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
anno = Time.now.year
mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day

form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)

#::: PDF DIRECTOR AGREGADA 17/10/2014 :::#
director = form_data.get("director_dij.datos_del_funcionario_generico.usuario")
form_data.set("director_dij.datos_del_funcionario_generico.usuario2", director)

#::: OBTENER PROVINCIA DE REVISION DE LA SOLICITUD EN ATTACHMENT :::#
_app_id = @application["id"]
result = WebserviceConsumer.get('/service/dij_helper/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
provincia = result["response"]["provincia"]
form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)

# :::::::::::::::::::::::::::::: DV: VIEJA IMPLEMENTACION MEJORADO ::::::::::::::::::::::::::::::::::#
# 	#############Consecutivo######################
#
# 	codf1= form_data.get("codigo_unico_dij.codigo_unico_dij.consecutivo")
# 	result = WebserviceConsumer.get( '/consecutive/generador_dij_f2/generate.json').parsed_response
# 	_consecutivo = result["response"]
# 	_consecutivo = "#{codf1}-"+"#{_consecutivo["value"]}"
# 	form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
#
# 	####código único######################
#         codigo_unico= form_data.get("datos_del_titular_rp.codigo_unico_dij.codigo_unico")
#         form_data.set("codigo_unico_dij.codigo_unico_dij.codigo_unico",codigo_unico)
# end
# :::::::::::::::::::::::::::::: DV: VIEJA IMPLEMENTACION MEJORADO ::::::::::::::::::::::::::::::::::#
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      ////////////////////// Al seleccionar que no se tiene version en fisico deshabilitar firma del director
$(document).ready(function(){
   valor = $("#field_retiro_record_policivo_retiro_record_policivo_version_fisico");
    if ($(valor).html() == "NO") {
       $("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").parent().parent().hide();
       $("#field_retiro_record_policivo_retiro_record_policivo_retiro_record_policivo").parent().parent().hide();
       $("#field_retiro_record_policivo_firma_director_si_no").parents(".part-box").hide();
    }
});

////Validación para ocultar seccion de confirmación si y motivo de solicitud
$(document).ready(function(){
	valor3 = $("#field_tipo_de_persona_dij_es_titular_o_no_si_no");
	if($(valor3).html() == "SÍ"){
		$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().hide();
	}
});

$(document).ready(function(){
  campoTipoDoc = $("#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento");
  campoTipoNac = $("#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_nacionalidad");
  campoNac   = $("#field_datos_del_titular_rp_datos_basicos_de_persona_natural_nacionalidad");
  if ($(campoTipoDoc).html() == "Cedula") {
    $(campoNac).parent().parent().hide();
    $(campoTipoNac).parent().parent().show();
    $(campoTipoNac).html("Nacional");
  } else if ($(campoTipoDoc).html() == "Pasaporte") {
    $(campoTipoNac).parent().parent().hide();
    $(campoNac).html("Extranjero");
    $(campoNac).parent().parent().show();
  }
});

$(document).ready(function(){
	tipo_de_solicitante = $("#field_tipo_de_persona_dij_tipo_de_solicitante_juridico_tipo_de_solicitante_juridico");
	provincia = $("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista");
	motivo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad");
	tipo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad");
$( function() {
if ($(tipo_de_solicitante).html() == "MINREX") {
				$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("Panamá");
				provincia.attr("disabled","disabled");
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().hide();
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').val('');
			} else if ($(tipo_de_solicitante).html() == "Autoridades") {
				//$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("");
				//provincia.removeAttr("disabled","disabled");
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
				// $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
			}
			if ($(motivo_auto).html() == "Otros") {
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().show();
			}else{
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
			}
			if ($(tipo_auto).html() == "Otros") {
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().show();
			} else{
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
			}
	});
});
    STEPAJAXCODE
  end
            
