
  class Paso1ImprimirRecordPolicivo < TemplateCode::Step

    on_becoming do
      # SE SETEA EL CAMPO usuario2 CON EL MISMO NOMBRE DEL FUNCIONARIO YA QUE SE IMPRIME 2 VECES EN UNA MISMA PÁGINA DEL PDF 
#director= form_data.get("director_dij.datos_del_funcionario_generico.usuario")
#form_data.set("director_dij.datos_del_funcionario_generico.usuario2", director)

# Inicializacion de datos del agente ### AGREGADO CAMBIO DE RUTAS DE FUNCIONARIO 17/10/2014

_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]

form_data.set("director_dij.datos_del_funcionario_generico.usuario", _agente["name"])
form_data.set("director_dij.datos_del_funcionario_generico.usuario2", _agente["name"])


# OBTENER PROVINCIA DE REVISION DE LA SOLICITUD EN ATTACHMENT#
#_app_id = @application["id"]
#result = WebserviceConsumer.get('/service/dij_helper/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
#provincia = result["response"]["provincia"]
#form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)

#::: DV: AGREGADO 21/01/2016 :::#
#:::: SI EL TITULAR NO EXISTE EN LA DIJ Y NO ES EL owner, obtiene el nombre si el mismo viene vacio :::::#
if form_data.get("aprobacion_de_ciudadano.datos_del_funcionario_generico.usuario").blank?
	primerNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre")
	segundoNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre")
	primerApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido")
	segundoApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido")
	apellidoCasadat = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada")
	nombreCompletot = "#{primerNombret} #{segundoNombret} #{primerApellidot} #{segundoApellidot} #{apellidoCasadat}"
	form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.nombre_completo",nombreCompletot.squish)
end

#::: OBTENER PROVINCIA DE REVISION DE LA SOLICITUD EN ATTACHMENT :::#
_app_id = @application["id"]
## Chantal Valverde result = WebserviceConsumer.get('/service/dij_helper/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
## Chantal Valverde provincia = result["response"]["provincia"]
## Chantal Valverde form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)

########Generar código unico y datos para impresión##############
codigo= form_data.get("codigo_unico_dij.codigo_unico_dij.dia")

#############Generar fecha para impresion###########
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
 
anno = Time.now.year
mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day

form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)
    end

    on_transition do
      ########Generar código unico y datos para impresión##############
codigo= form_data.get("codigo_unico_dij.codigo_unico_dij.dia")

#############Generar fecha para impresion###########
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
 
anno = Time.now.year
mes= I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day

form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)
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
            
