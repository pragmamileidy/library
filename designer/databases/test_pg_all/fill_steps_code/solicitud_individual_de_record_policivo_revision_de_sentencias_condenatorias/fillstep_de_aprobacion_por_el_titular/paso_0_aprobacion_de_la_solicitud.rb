
  class Paso0AprobacionDeLaSolicitud < TemplateCode::Step

    on_becoming do
      #::: DV: AGREGADO 21/01/2016 :::#
#:::: SI EL TITULAR NO EXISTE EN LA DIJ Y NO ES EL owner, obtiene el nombre si el mismo viene vacio :::::#
if form_data.get("aprobacion_de_ciudadano.datos_del_funcionario_generico.usuario").blank?
	primerNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre")
	segundoNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre")
	primerApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido")
	segundoApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido")
	apellidoCasadat = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada")
	nombreCompletot = "#{primerNombret} #{segundoNombret} #{primerApellidot} #{segundoApellidot} #{apellidoCasadat}"
	form_data.set("aprobacion_de_ciudadano.datos_del_funcionario_generico.usuario",nombreCompletot.squish)
end
    end

    on_transition do
      _obs = form_data.get("aprobacion_de_ciudadano.datos_del_funcionario_generico.observaciones")
_aprob = form_data.get("aprobacion_de_ciudadano.datos_del_funcionario_generico.aprobacion")
if (_aprob =="NO" and _obs.blank?) 
   transition_errors << "Debe indicar el motivo de su desaprobación en el campo (Observación). "
end

########Generar código unico y datos para impresión##############

codigo= form_data.get("codigo_unico_dij.codigo_unico_dij.dia")

#if codigo.blank?
	#############Generar fecha para impresion###########
	form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
 
	anno = Time.now.year
	mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
	dia = Time.now.day

	form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
	form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
	form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)

	##############Consecutivo######################

	#codf1= form_data.get("codigo_unico_dij.codigo_unico_dij.consecutivo")
	#result = WebserviceConsumer.get( '/consecutive/generador_dij_f2/generate.json').parsed_response
	#_consecutivo = result["response"]
	#_consecutivo = "#{codf1}-"+"#{_consecutivo["value"]}"
	#form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)

	#####código único######################
        #codigo_unico= form_data.get("datos_del_titular_rp.codigo_unico_dij.codigo_unico")
        #form_data.set("codigo_unico_dij.codigo_unico_dij.codigo_unico",codigo_unico)
#end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      ///Cambiar el nombre del campo Nombre de Funcionario para la tarea de aprobacion del titular
$( function() {
        $("div").each (function(){
                if ($(this).html().trim() == "Nombre del Funcionario") { // aquí se coloca el nombre que se desea cambiar
                        $(this).html("Nombre"); // Aquí se coloca el Nombre que se desea que se muestre
                }      
        });              
});

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
            
