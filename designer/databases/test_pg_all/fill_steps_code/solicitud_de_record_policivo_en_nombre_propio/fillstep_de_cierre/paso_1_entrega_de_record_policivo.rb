
  class Paso1EntregaDeRecordPolicivo < TemplateCode::Step

    on_becoming do
      #::: INICIALIZAR LOS DATOS DEL AGENTE :::#
_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]
form_data.set("entrega_de_record_policivo.funcionario_vu_dij.usuario", _agente["name"])

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
## Chantal Valverde result = WebserviceConsumer.get('/service/dij_helper/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
## Chantal Valverde provincia = result["response"]["provincia"]
## Chantal Valverde form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)

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
      //::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){ 
   $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Tipo de Solicitud") {  
        $(this).html("Tipo de Solicitud"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Solicitante") {  
        $(this).html("Gestión de Solicitud"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Titular") {  
        $(this).html("Información del Titular"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Recepción Ventanilla Única") {  
        $(this).html("Recepción de Ventanilla Única"); 
      }
    });
  });
});

$(document).ready(function(){ 
  TiDoc = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento');
  nacio = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_nacionalidad');
  if ($(TiDoc).html() == "Cedula") {
    $(nacio).html("Nacional");
  } else if($(TiDoc).html() == "Pasaporte") {
    $(nacio).html("Extranjero");
  }
});
    STEPAJAXCODE
  end
            
