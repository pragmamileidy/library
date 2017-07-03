
  class Paso3DatosDeLaEmpresaAInscribir < TemplateCode::Step

    on_becoming do
      if @owner["kind_of_user_type"] == "NaturalPerson"
    form_data.set("solicitante_natural.datos_del_local.se_dedicara_a_ofrecer","Préstamos en General")
else
     form_data.set("solicitante_juridico.datos_generales_de_empresa.se_dedicara_a_ofrecer_texto","Préstamos en General")
     #form_data.set("solicitante_juridico.datos_generales_de_empresa.ruc","")
end
    end

    on_transition do
      if @owner["kind_of_user_type"] == "JuridicalPerson"  
    #:::: fecha_de_inicio_de_operacione
    fecha_convenio = form_data.get("solicitante_juridico.datos_generales_de_empresa.fecha_de_inicio_de_operaciones")
    if (fecha_convenio.to_date > Date.today)
        transition_errors << "La fecha de inicio de operaciones de la empresa no puede ser posterior a la fecha actual, por favor verifique."
    end

    documento_presidente = form_data.get("miembros_de_la_junta_directiva.presidente.cedula_o_pasaporte")

    if documento_presidente != "Pasaporte"
        #VERIFICACIÒN NUMERO DE CEDULA DEL PRESIDENTE DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
        presidente = form_data.get("miembros_de_la_junta_directiva.presidente.cedula")   
        resultPresi = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{presidente}")).parsed_response
        datosPresidente = resultPresi["response"]
        if datosPresidente.blank? 
            transition_errors << "La Cédula del Presidente no fue encontrada. Por favor, verifique." 
        else            
            difuntoPresidente = datosPresidente["cod_mensaje"]
            if (difuntoPresidente == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{presidente} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL VICEPRESIDENTE DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    documento_vice = form_data.get("miembros_de_la_junta_directiva.vicepresidente.cedula_o_pasaporte")
    if documento_vice != "Pasaporte"                  
        vice = form_data.get("miembros_de_la_junta_directiva.vicepresidente.cedula")   
        resultVice = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{vice}")).parsed_response
        datosVice = resultVice["response"]
        if datosVice.blank? 
            transition_errors << "La Cédula del Vicepresidente no fue encontrada. Por favor, verifique." 
        else            
            difuntoVice = datosVice["cod_mensaje"]
            if (difuntoVice == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{vice} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL TESORERO DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    documento_tesorero = form_data.get("miembros_de_la_junta_directiva.tesorero.cedula_o_pasaporte") 
    if documento_tesorero != "Pasaporte"                      
        tesorero = form_data.get("miembros_de_la_junta_directiva.tesorero.cedula")   
        resultTesorero = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{tesorero}")).parsed_response
        datosTesorero = resultTesorero["response"]
        if datosTesorero.blank? 
            transition_errors << "La Cédula del Tesorero no fue encontrada. Por favor, verifique." 
        else            
            difuntoTesorero = datosTesorero["cod_mensaje"]
            if (difuntoTesorero == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{tesorero} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL SECRETARIO DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    documento_secretario = form_data.get("miembros_de_la_junta_directiva.secretrario.cedula_o_pasaporte") 
    if documento_secretario != "Pasaporte"                        
        secretario = form_data.get("miembros_de_la_junta_directiva.secretrario.cedula")   
        resultSecre = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{secretario}")).parsed_response
        datosSecre = resultSecre["response"]
        if datosSecre.blank? 
            transition_errors << "La Cédula del Secretario no fue encontrada. Por favor, verifique." 
        else            
            difuntoSecre = datosSecre["cod_mensaje"]
            if (difuntoSecre == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{secretario} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL REPRESENTANTE LEGAL DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    documento_representante = form_data.get("miembros_de_la_junta_directiva.representante_legal.cedula_o_pasaporte") 
    if documento_representante != "Pasaporte"                         
        representante = form_data.get("miembros_de_la_junta_directiva.representante_legal.cedula")   
        resultRepre = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{representante}")).parsed_response
        datosRepre = resultRepre["response"]
        if datosRepre.blank? 
            transition_errors << "La Cédula del Representante Legal no fue encontrada. Por favor, verifique." 
        else            
            difuntoRepre = datosRepre["cod_mensaje"]
            if (difuntoRepre == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{representante} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL APODERADO LEGAL DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    documento_apoderado = form_data.get("miembros_de_la_junta_directiva.apoderado_general.cedula_o_pasaporte") 
    if documento_apoderado != "Pasaporte"                           
        apoderado = form_data.get("miembros_de_la_junta_directiva.apoderado_general.cedula")   
        resultApo = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{apoderado}")).parsed_response
        datosApo = resultApo["response"]
        if datosApo.blank? 
            transition_errors << "La Cédula del Apoderado Legal no fue encontrada. Por favor, verifique." 
        else            
            difuntoApo = datosApo["cod_mensaje"]
            if (difuntoApo == "534")
                transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{apoderado} corresponde a un ciudadano Difunto."
            end
        end
    end

    #VERIFICACIÒN NUMERO DE CEDULA DEL APODERADO LEGAL DE LA JUNTA DIRECTIVA NO PERTENEZCA A UN DIFUNTO
    (1..3).each do |_num|
         documento_director = form_data.get("miembros_de_la_junta_directiva.director_instance_#{_num}.cedula_o_pasaporte") 
        if documento_director != "Pasaporte"  
            director = form_data.get("miembros_de_la_junta_directiva.director_instance_#{_num}.cedula")   
            resultDir = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{director}")).parsed_response
            datosDir = resultDir["response"]
            if !director.blank?
                if datosDir.blank? 
                    transition_errors << "La Cédula del Director #{_num} no fue encontrada. Por favor, verifique." 
                else            
                    difuntoDir = datosDir["cod_mensaje"]
                    if (difuntoDir == "534")
                        transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{director} corresponde a un ciudadano Difunto."
                    end
                end
            end
        end
    end
else
    #:::: fecha_de_inicio_de_operacione
    fecha_convenio = form_data.get("solicitante_natural.datos_del_local.fecha_de_inicio_de_operaciones")
    if (fecha_convenio.to_date > Date.today)
        transition_errors << "La fecha de inicio de operaciones de la empresa no puede ser posterior a la fecha actual, por favor verifique."
    end
end


# Obtener valor del config
valor = @config.route("Rates-payment-payment-payment")
if valor == "Electrónico"
    form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Electrónico")
end
if valor == "Manual"
    form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Cédula / Pasaporte*") {
          $(this).html("Número de Cédula *");        
      }
   });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Edificio/Casa*") {
          $(this).html("Edificio o Casa, local*");
      }
  });
});

$(function() {
$('#id_del_combo_distritos').html("");
$('#id_del_combo_corregimientos').html("");
});
$( function() {
    $("#field_solicitante_juridico_datos_de_ubicacion_provincia_lista").change(function(){
      var prov = $("#field_solicitante_juridico_datos_de_ubicacion_provincia_lista").find(':selected').val();
      distritosJuridico(prov);
    });
    $("#field_solicitante_juridico_datos_de_ubicacion_distrito_lista").change(function(){
      var distrito = $("#field_solicitante_juridico_datos_de_ubicacion_distrito_lista").find(':selected').val();
      corregimientosJuridicos(distrito);
    });
});

function distritosJuridico(provincia) {
 params = {
            "service_name":"ws_panama_distritos/where",
            "provincia":provincia
          }
$.post(
            "/proxy_service/get_service",
            params,
            function(data){
        var dist;
        var html_options = "";
        for (x in data){
          dist = data[x];
          html_options = html_options+'<option value="'+dist["distrito"] +'">'+dist["distrito"] +'</option>'
        } 
        $("#field_solicitante_juridico_datos_de_ubicacion_distrito_lista").html(html_options);
        $("#field_solicitante_juridico_datos_de_ubicacion_corregimiento_lista").html("");
            }
          );
}
function corregimientosJuridicos(distrito) {
 params = {
            "service_name":"ws_panama_corregimientos/where",
            "distrito":distrito
          }
$.post(
            "/proxy_service/get_service",
            params,
            function(data){
        var corr;
        var html_options = "";
        for (x in data){
          corr = data[x];
          html_options = html_options+'<option value="'+corr["corregimiento"] +'">'+corr["corregimiento"] +'</option>'
        } 
        $("#field_solicitante_juridico_datos_de_ubicacion_corregimiento_lista").html(html_options);
            }
          );
}

///////////// PERSONA NATURAL
$( function() {
  $("#field_solicitante_natural_datos_de_ubicacion_provincia_lista").change(function(){
    var prov = $("#field_solicitante_natural_datos_de_ubicacion_provincia_lista").find(':selected').val();
    distritos(prov);
  });
  $("#field_solicitante_natural_datos_de_ubicacion_distrito_lista").change(function(){
    var distrito = $("#field_solicitante_natural_datos_de_ubicacion_distrito_lista").find(':selected').val();
    corregimientos(distrito);
  });
});

function distritos(provincia) {
 params = {
            "service_name":"ws_panama_distritos/where",
            "provincia":provincia
          }
      $.post(
        "/proxy_service/get_service",
        params,
        function(data){
        var dist;
        var html_options = "";
            for (x in data){
              dist = data[x];
              html_options = html_options+'<option value="'+dist["distrito"] +'">'+dist["distrito"] +'</option>'
            } 
            $("#field_solicitante_natural_datos_de_ubicacion_distrito_lista").html(html_options);
            $("#field_solicitante_natural_datos_de_ubicacion_corregimiento_lista").html("");
        }
      );
}
function corregimientos(distrito) {
 params = {
            "service_name":"ws_panama_corregimientos/where",
            "distrito":distrito
          }
      $.post(
        "/proxy_service/get_service",
        params,
        function(data){
          var corr;
          var html_options = "";
          for (x in data){
            corr = data[x];
            html_options = html_options+'<option value="'+corr["corregimiento"] +'">'+corr["corregimiento"] +'</option>'
          } 
          $("#field_solicitante_natural_datos_de_ubicacion_corregimiento_lista").html(html_options);
        }
      );
}

$(document).ready(function(){
  //PRESIDENTE
   TiDoc = $('#field_miembros_de_la_junta_directiva_presidente_cedula_o_pasaporte');
  if ($(TiDoc).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").hide();
  }else if ($(TiDoc).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDoc.change(function() {
        if ($(TiDoc).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_presidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_presidente_pasaporte').val("");
        }
    }); 
  });

  // VIEPRESIDENTE
  TiDocV = $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula_o_pasaporte');
  if ($(TiDocV).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").hide();
  }else if ($(TiDocV).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDocV.change(function() {
        if ($(TiDocV).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').val("");
        }
        if ($(TiDocV).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').val("");
        }
        if ($(TiDocV).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_vicepresidente_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_vicepresidente_pasaporte').val("");
        }
    }); 
  });


  // TESORERO
  TiDocT = $('#field_miembros_de_la_junta_directiva_tesorero_cedula_o_pasaporte');
  if ($(TiDocT).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").hide();
  }else if ($(TiDocT).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDocT.change(function() {
        if ($(TiDocT).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').val("");
        }
        if ($(TiDocT).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').val("");
        }
        if ($(TiDocT).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_tesorero_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_tesorero_pasaporte').val("");
        }
    }); 
  });

  // SECRETARIO
  TiDocS = $('#field_miembros_de_la_junta_directiva_secretrario_cedula_o_pasaporte');
  if ($(TiDocS).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").hide();
  }else if ($(TiDocS).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDocS.change(function() {
        if ($(TiDocS).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').val("");
        }
        if ($(TiDocS).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').val("");
        }
        if ($(TiDocS).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_secretrario_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_secretrario_pasaporte').val("");
        }
    }); 
  });

  /// REPRESENTANTE LEGAL
  TiDocR = $('#field_miembros_de_la_junta_directiva_representante_legal_cedula_o_pasaporte');
  if ($(TiDocR).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").hide();
  } else if ($(TiDocR).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDocR.change(function() {
        if ($(TiDocR).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').val("");
        }
        if ($(TiDocR).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').val("");
        }
        if ($(TiDocR).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_representante_legal_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_representante_legal_pasaporte').val("");
        }
    }); 
  });

  // APODERADO
  TiDocA= $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula_o_pasaporte');
  if ($(TiDocA).find(':selected').val() == "Cédula"){
    $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").show();
    $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").hide();
  } else if ($(TiDocA).find(':selected').val() == "Pasaporte"){
    $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").show();
  }else{
    $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").hide();
    $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDocA.change(function() {
        if ($(TiDocA).find(':selected').val() == "") {
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').val("");
        }
        if ($(TiDocA).find(':selected').val() == "Cédula") {
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').val("");
        }
        if ($(TiDocA).find(':selected').val() == "Pasaporte") {
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').parents(".field-box").hide();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').parents(".field-box").show();
          $('#field_miembros_de_la_junta_directiva_apoderado_general_cedula').val("");
          $('#field_miembros_de_la_junta_directiva_apoderado_general_pasaporte').val("");
        }
    }); 
  });

  // DIRECTORES
  for (var i=1 ; i <= 3 ; i++){
      var field = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_cedula_o_pasaporte";
      var cedula = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_cedula";
      var pasaporte = "#field_miembros_de_la_junta_directiva_director_instance_"+i+"_pasaporte";
      TiDocD = $(field);
      if ($(TiDocD).find(':selected').val() == "Cédula"){
        $(cedula).parents(".field-box").show();
        $(pasaporte).parents(".field-box").hide();
      } else if ($(TiDocD).find(':selected').val() == "Pasaporte"){
        $(cedula).parents(".field-box").hide();
        $(pasaporte).parents(".field-box").show();
      }else{
        $(cedula).parents(".field-box").hide();
        $(pasaporte).parents(".field-box").hide();
      }
  }

  $("select").change(function(){
      if ($(this).attr("id").match("field_miembros_de_la_junta_directiva_director")){
        var pos = (this.id).match(/_instance_[\d+]/);
        var name1 = "#field_miembros_de_la_junta_directiva_director";
        var name2 = "_cedula";
        var name3 = "_pasaporte";
        var field1 = name1.concat(pos);
        var cedula = field1.concat(name2);
        var pasaporte = field1.concat(name3)
        if ($(this).find(':selected').val() == "") {
          $(cedula).parents(".field-box").hide();
          $(pasaporte).parents(".field-box").hide();
          $(cedula).val("");
          $(pasaporte).val("");
        }
        if ($(this).find(':selected').val() == "Cédula") {
          $(cedula).parents(".field-box").show();
          $(pasaporte).parents(".field-box").hide();
          $(cedula).val("");
          $(pasaporte).val("");
        }
        if ($(this).find(':selected').val() == "Pasaporte") {
          $(cedula).parents(".field-box").hide();
          $(pasaporte).parents(".field-box").show();
          $(cedula).val("");
          $(pasaporte).val("");
        }
      }
  });
});
    STEPAJAXCODE
  end
            
