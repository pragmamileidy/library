
  class Paso1RecepcionDeLaSolicitud < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente

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
      /////////////Habilitar campos si tipo documento es pasaporte
$(document).ready(function(){

    $.each( $('[id*=datos_del_autor_es_persona_natural_]'), function(index, campo) {

        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   

        var autor = "#field_datos_del_autor_es_persona_natural";
    //  var parte = "_datos_de_la_persona";
        var mod1 = autor.concat(pos);
        //var mod2 = mod1.concat(parte);

        var docs = "_datos_de_la_persona_tipo_documento_string";
        var identificacion = "_datos_de_la_persona_cedula_pasaporte";

        var documento_d = mod1.concat(docs);
        var ced = mod1.concat(identificacion);


        if($(documento_d).html() == 'Cédula' || $(documento_d).html() == 'Pasaporte'){ 
            $(ced).parents(".part-box").show();
        }else {
            $(ced).parents(".part-box").hide();
        }


        if ($(documento_d).html() == ''){
            $(documento_d).parents(".section-box").hide();
        }else{
            $(documento_d).parents(".section-box").show();
        }
        

        /////////////////////////VALIDACION SEUDONIMO//////////////////77
           
        var seudonimo = "_seudonimo_seudonimo";
        var indiqueSeudonimo = "_seudonimo_indique_seudonimo";

        var seu = mod1.concat(seudonimo);
        var indiqueSeu = mod1.concat(indiqueSeudonimo);

        
        if ($(indiqueSeu).html() == ''){
            $(indiqueSeu).parents(".part-box").hide();
        }else{
            $(indiqueSeu).parents(".part-box").show();
        }

        
        $(documento_d).parents(".section-box").next().hide();

    });
});




$(document).ready(function(){
$.each( $('[id*=datos_del_titular_es_persona_juridica_]'), function(index, campo) {
        
    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
      pos = (this.id).match(/_instance_[\d]/);
    }
    //alert(pos);
    var mod1 = "#field_datos_del_titular_es_persona_juridica";
    var mod2 = "_datos_de_la_empresa_ruc";
    var tipoDocRuc = "_datos_de_la_empresa_tipo_documento";
    var direccion = "_direccion_pais";

    var mod3 = mod1.concat(pos);
    var dato = mod3.concat(mod2);
    var tipoDocuRuc = mod3.concat(tipoDocRuc);
    var dire = mod3.concat(direccion);

        //alert(dato);
    if($(tipoDocuRuc).html() == 'RUC'){ 
        $(dato).parents(".part-box").show();
        $(dire).parents(".part-box").show();
    }else {
        $(dato).parents(".part-box").hide();
        $(dire).parents(".part-box").hide();
    }


    if ($(tipoDocuRuc).html() == ''){
            $(tipoDocuRuc).parents(".section-box").hide();
        }else{
            $(tipoDocuRuc).parents(".section-box").show();
    }
 
    $(tipoDocuRuc).parents(".section-box").next().hide()

  });
 
}); 




$(document).ready(function(){

	campoOtros = $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte");
	if ($(campoOtros).html() == "") {
		$("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parent().parent().hide();
	}else{
		$("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parent().parent().show();
	}

	transf = $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia");
	if ($(transf).html() == "") {
		$(transf).parents(".part-box").hide();
	}else{
		$(transf).parents(".part-box").show();
	}

});
    STEPAJAXCODE
  end
            
