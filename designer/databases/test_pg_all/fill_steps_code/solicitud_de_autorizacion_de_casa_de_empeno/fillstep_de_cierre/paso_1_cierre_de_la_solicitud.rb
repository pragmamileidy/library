
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
      // Cambiando label del anexo dado que desde el designer no queda espacio para más caracteres
$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Certificado del registro público expedido dentro de los sesenta(60) días anteriores a la fecha de presentación de la solicitud, donde conste el nombre de la sociedad, la vigencia, el capital autorizado, el representante legal, los dignatarios, los poderes") {
          $(this).html("Certificado del registro público expedido dentro de los sesenta(60) días anteriores a la fecha de presentación de la solicitud, donde conste el nombre de la sociedad, la vigencia, el capital autorizado, el representante legal, los dignatarios, los poderes generales y datos de inscripción de la sociedad.");
      }
  });
});

$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Modelo del contrato que contemple por lo menos la información del Artículo 23 de la Ley 16 de 23 de Mayo de") {
          $(this).html("Modelo del contrato que contemple por lo menos la información del Artículo 23 de la Ley 16 de 23 de Mayo de 2005.");
      }
  });
});

// Chantal Valverde 04-Abr-2017
$( function() {
  $(".panel-title").each (function(){
      if ($(this).html().trim() == "Escritura Pública") {
          $(this).html("Copia de la escritura pública donde conste la propiedad o derecho de uso, o del contrato de arrendamiento del local comercial donde estará ubicada la empresa, que presentará al momento de la notificación de la resolución que autoriza las operaciones de la casa de empeño");
      }
  });
});

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
            
