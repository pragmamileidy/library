
  class Paso0RecepcionDeLaSolicitud < TemplateCode::Step

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
  $(".field-hint").each (function(){
      if ($(this).html().trim() == "Indicar el número de cédula del abogado litigante") {
          $(this).html("Número de Cédula del Abogado");
      }
  });
});

$( function() {
  $(".field-hint").each (function(){
      if ($(this).html().trim() == "Nombre de la firma a la cual pertenece el abogado litigante") {
          $(this).html("Nombre de la firma a la cual pertenece el abogado");
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

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Edificio/Casa") {
          $(this).html("Edificio o Casa, local");
      }
  });
});

//Comentado Chantal Valverde 04-Abr-2017
//$( function() {
//  $(".hint").each (function(){
//      if ($(this).html().trim() == "Artículo 16 de la Ley 22 de mayo del 2002: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una agencia de información de datos sobre historial de crédito, deberán estar dom") {
//          $(this).html("	Artículo 16 de la Ley 22 de mayo del 2002: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una agencia de información de datos sobre historial de crédito, deberán estar domiciliados en la República de Panamá.");
//      }
//  });
//});

//Agregado Chantal Valverde 04-Abr-2017
$( function() {
  $(".hint").each (function(){
      if ($(this).html().trim() == "Artículo 16") {
          $(this).html("Artículo 16 de la Ley 22 de mayo del 2002: Las personas naturales y los representantes legales de las personas jurídicas autorizadas para desarrollar los negocios propios de una agencia de información de datos sobre historial de crédito, deberán estar domiciliados en la República de Panamá.");
      }
  });
});

//VALIDACION PARA MOSTRAR INSTANCIAS DE DIRECTORES DE LA JUNTA DIRECTIVA

$(document).ready(function(){
  		
    $.each( $('[id*=miembros_de_la_junta_directiva_director_]'), function director(index, campo) {       
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   
        var InicioRuta  = "#field_miembros_de_la_junta_directiva_director";
        var nomb    = "_nombre";

        var coincide    = InicioRuta.concat(pos);
        var nombre    = coincide.concat(nomb);

        if($(nombre).html() != ""){
            $(nombre).parents(".part-box").show();
        }else{
			$(nombre).parents(".part-box").hide();
        }

    });
});


//VALIDACION PARA MOSTRAR INSTANCIAS DE ANEXOS DE CEDULAS DE MIEMBROS DE LA JUNTA DIRECTIVA

/*$(document).ready(function(){
  		
    $.each( $('[id*=cedula_de_identidad_]'), function director(index, campo) {       
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   
        var InicioRuta  = "#cedula_de_identidad";
        //var ced    = "_anexo";

        var cedula    = InicioRuta.concat(pos);
        //var cedula    = coincide.concat(ced);

        if($(cedula) != null){
            $(cedula).parents(".part-box").show();
        }else{
			$(cedula).parents(".part-box").hide();
        }

    });
});*/

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

    STEPAJAXCODE
  end
            
