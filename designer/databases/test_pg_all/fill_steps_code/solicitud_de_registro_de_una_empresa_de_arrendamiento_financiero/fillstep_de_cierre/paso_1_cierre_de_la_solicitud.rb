
  class Paso1CierreDeLaSolicitud < TemplateCode::Step

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
      $( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Tipo de Documento del Señor(a) a autorizar") {
          $(this).html("Tipo de Documento de la persona natural a autorizar");
      }
  });
});

$( function() {
  $(".field-hint").each (function(){
      if ($(this).html().trim() == "Número de Cédula del Abogado Litigante") {
          $(this).html("Número de Cédula del Abogado");
      }
  });
});

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
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Nombre del Señor(a) a autorizar") {
          $(this).html("Nombre de la persona natural a autorizar");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Cédula/Pasaporte del Señor(a) a autorizar") {
          $(this).html("Número de cédula de la persona natural a autorizar");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Pasaporte del Señor(a) a autorizar") {
          $(this).html("Número de pasaporte de la persona natural a autorizar");
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

$(document).ready(function(){

  representado_por = $("#field_datos_del_solicitante_representado_por_cedula_pasaporte");
  if ($(representado_por).html() == ""){
    $("#representado_por").remove();
  }

        cedula = $("#field_datos_del_solicitante_datos_de_la_persona_cedula");
  if ($(cedula).html() == ""){
    $("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().hide();
    $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().show();
  }
  pasaporte = $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte");
  if ($(pasaporte).html() == "") {
    $("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().show();
    $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().hide();
  }
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
            
