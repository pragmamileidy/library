
  class Paso1CierreDeLaSolicitud < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente

_idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]


form_data.set("cerrado_por.datos_del_funcionario_generico.usuario", _agente["name"])

    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
  $.each( $('[id*=especificaciones_del_contrato_y_demas_actos_lugar_y_fecha_de_la_firma]'), function(index, campo) {    
    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
      pos = (this.id).match(/_instance_[\d]/);
    } 

    // ocultar partes vacias ================================================
        var inicRuta    = "#field_especificaciones_del_contrato_y_demas_actos_lugar_y_fecha_de_la_firma";
        var pais   = "_pais"


        var coincide  = inicRuta.concat(pos);
        var pais1     = coincide.concat(pais);

        if ($(pais1).html() == ""){
            $(pais).parents(".part-box").hide();
        } else {
            $(pais1).parents(".part-box").show();
        }
        $(pais1).parents(".section-box").next().hide();  
    // fin ocultar partes vacias ============================================
  });

  otro     = "#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo";
  if ($(otro).html() == ""){
        $(otro).parents(".field-box").hide();
  }else {
        $(otro).parents(".field-box").show();
  }
});
    STEPAJAXCODE
  end
            
