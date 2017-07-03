
  class Paso1CerradoPor < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente - LG

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
      if ($(this).html().trim() == "Número de Teléfono") {
          $(this).html("Número de Teléfono (Fijo)");
      }
  });
});

var dato = $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_estatus_de_la_obra")
         if ($(dato).html() == 'Inédita') {
               $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").hide();
         } else {
               $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").show();
         }

////////////////// AUTOR //////////////////

$(document).ready(function(){
    $.each( $('[id*=datos_del_autor_]'), function(index, campo) {
            
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
          pos = (this.id).match(/_instance_[\d]/);
        }
        var mod1 = "#field_datos_del_autor";
        var mod2 = "_tipo_de_identificacion_tipo_identificacion_texto";
        var mod_c = "_datos_de_la_persona_cedula_pasaporte";
        var mod_r = "_datos_de_la_empresa_ruc";
        var mod_s = "_seudonimo_indique_seudonimo"
        var mod3 = mod1.concat(pos);
        var dato = mod3.concat(mod2);
        var ced = mod3.concat(mod_c);
        var ruc =  mod3.concat(mod_r);
        var seu = mod3.concat(mod_s);

         if ($(dato).html() == '') {
                $(ruc).parents(".section-box").hide();
         } else {
            $(ced).parents(".section-box").show();
            if($(dato).html() == 'Cédula' || $(dato).html() == 'Pasaporte'){ 
                $(ruc).parents(".part-box").hide();
                $(ced).parents(".part-box").show();
                if ($(seu).html() == ""){
                    $(seu).parents(".part-box").hide();
                }else{
                    $(seu).parents(".part-box").show();
                }
            }else if ($(dato).html() == 'RUC') {
                $(ruc).parents(".part-box").show();
                $(ced).parents(".part-box").hide();
                $(seu).parents(".part-box").hide();
            }
         }
        
        $(dato).parents(".section-box").next().hide();

    });
});


////////////////// EDITORES //////////////////

    
$(document).ready(function(){
    $.each( $('[id*=datos_de_los_editores_]'), function(index, campo) {

    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
        pos = (this.id).match(/_instance_[\d]/);
    }   

    var mod1 = "#field_datos_de_los_editores";
    var mod2 = "_tipo_de_identificacion_tipo_identificacion_texto";
    var mod_c = "_datos_de_la_persona_cedula_pasaporte";
    var mod_r = "_datos_de_la_empresa_ruc";
    var mod3 = mod1.concat(pos);
    var dato = mod3.concat(mod2);
    var ced = mod3.concat(mod_c);
    var ruc =  mod3.concat(mod_r);

     if ($(dato).html() == '') {
            $(ruc).parents(".section-box").hide();
     } else {
        $(ced).parents(".section-box").show();
        if($(dato).html() == 'Cédula' || $(dato).html() == 'Pasaporte'){ 
            $(ruc).parents(".part-box").hide();
            $(ced).parents(".part-box").show();
        }else if ($(dato).html() == 'RUC') {
            $(ruc).parents(".part-box").show();
            $(ced).parents(".part-box").hide();
        }
     }

    $(dato).parents(".section-box").next().hide()
    }); 
         
});


/////////////////////// IMPRESORES /////////////////////////


    
$(document).ready(function(){
    $.each( $('[id*=datos_de_los_impresores_]'), function(index, campo) {

    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
        pos = (this.id).match(/_instance_[\d]/);
    }   

    var mod1 = "#field_datos_de_los_impresores";
    var mod2 = "_tipo_de_identificacion_tipo_identificacion_texto";
    var mod_c = "_datos_de_la_persona_cedula_pasaporte";
    var mod_r = "_datos_de_la_empresa_ruc";
    var mod3 = mod1.concat(pos);
    var dato = mod3.concat(mod2);
    var ced = mod3.concat(mod_c);
    var ruc =  mod3.concat(mod_r);
    
     if ($(dato).html() == '') {
            $(ruc).parents(".section-box").hide();
     } else {
        $(ced).parents(".section-box").show();
        if($(dato).html() == 'Cédula' || $(dato).html() == 'Pasaporte'){ 
            $(ruc).parents(".part-box").hide();
            $(ced).parents(".part-box").show();
        }else if ($(dato).html() == 'RUC') {
            $(ruc).parents(".part-box").show();
            $(ced).parents(".part-box").hide();
        }
     }
        $(dato).parents(".section-box").next().hide()
    }); 
});


    STEPAJAXCODE
  end
            
