
  class RecepcionDeLaSolicitud < TemplateCode::Step

    on_becoming do
      _idagente = @task["agent_id"].to_s

                result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
                _hash = result["hash"]
                _agente = _hash["response"]


                form_data.set("recibido_por.datos_del_funcionario_generico.usuario", _agente["name"])
                form_data.set("recibido.datos_del_funcionario_generico.usuario", _agente["name"])
    end

    on_transition do
      ##### RECEPCION DE SOLICITUD #####
_obs = form_data.get("recibido_por.datos_del_funcionario_generico.observaciones")
if _obs.blank?
	_obs = form_data.get("recibido.datos_del_funcionario_generico.observaciones")
end

_eval = form_data.get("recibido_por.datos_del_funcionario_generico.evaluacion")
if _eval.blank?
	_eval = form_data.get("recibido.datos_del_funcionario_generico.evaluacion_ok_rechazo")
end


if (_eval =="REPARO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del reparo en el campo (Observación). "
end

if (_eval =="RECHAZO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del rechazo en el campo (Observación). "
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Cédula/Pasaporte del Señor(a) a autorizar") {
          $(this).html("Número de Cédula del Señor(a) a autorizar");
      }
  });
});

$( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Cédula / Pasaporte") {
          $(this).html("Número de Cédula");        
      }
   });
});

// Chantal Valverde 05-Abr-2017, Asignando la etiqueta del adjunto "Modelo del Contrato"

$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Modelo del Contrato") {
          $(this).html("Modelo del contrato que contemple por lo menos la información del artículo 18 de la Ley 48 del 23 de julio de 2003.");
      }
  });
});

$(document).ready(function(){
    $.each( $('[id*=field_miembros_de_la_junta_directiva_director]'), function(index, campo) {

        var pos = (this.id).match(/_instance_[\d+]/);

        var name1 = "#field_miembros_de_la_junta_directiva_director";
        var name2 = "_cedula_o_pasaporte";
        var field1 = name1.concat(pos);
        var finalField = field1.concat(name2);


        if($(finalField).html() == 'Cédula' || $(finalField).html() == 'Pasaporte'){ 
            $(finalField).parents(".part-box").show();
        }else {
            $(finalField).parents(".part-box").hide();
        }

    });
});
//VALIDACION PARA MOSTRAR INSTANCIAS DE DIRECTORES DE LA JUNTA DIRECTIVA


$(document).ready(function(){
  //PRESIDENTE
   TiDoc = $('#field_miembros_de_la_junta_directiva_presidente_cedula_o_pasaporte');
  if ($(TiDoc).html() == "Cédula" || $(TiDoc).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").show();
  }

  // VIEPRESIDENTE
  TiDocV = $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula_o_pasaporte');
  if ($(TiDocV).html() == "Cédula" || $(TiDocV).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").show();
  }

  // TESORERO
  TiDocT = $('#field_miembros_de_la_junta_directiva_tesorero_cedula_o_pasaporte');
  if ($(TiDocT).html() == "Cédula" || $(TiDocT).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").show();
  }

  // SECRETARIO
  TiDocS = $('#field_miembros_de_la_junta_directiva_secretrario_cedula_o_pasaporte');
  if ($(TiDocS).html() == "Cédula" || $(TiDocS).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").show();
  }

  /// REPRESENTANTE LEGAL
  TiDocR = $('#field_miembros_de_la_junta_directiva_representante_legal_cedula_o_pasaporte');
  if ($(TiDocR).html() == "Cédula" || $(TiDocR).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").show();
  }

  // APODERADO
  TiDocA= $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula_o_pasaporte');
  if ($(TiDocA).html() == "Cédula" || $(TiDocA).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").show();
  }

  // DIRECTORES
  for (var i=1 ; i <= 3 ; i++){
      var field = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_cedula_o_pasaporte";
      var cedula = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_cedula";
      var pasaporte = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_pasaporte";
      TiDocD = $(field);
      if ($(TiDocD).html() == "Cédula" || $(TiDocD).find(':selected').val() == "Cédula"){
        $(cedula).parents(".field-box").show();
        $(pasaporte).parents(".field-box").hide();
      }else{
        $(cedula).parents(".field-box").hide();
        $(pasaporte).parents(".field-box").show();
      }
  }

});

$(document).ready(function(){
   autorizado = $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_o_pasaporte');
  if ($(autorizado).html() == "Cédula" || $(autorizado).find(':selected').val() == "Cédula"){
    $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").show();
    $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").hide();
  }else{
    $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").hide();
    $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").show();
  }
});
    STEPAJAXCODE
  end
            
