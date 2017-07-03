
  class Paso1ConsultaDeInfracciones < TemplateCode::Step

    on_becoming do
      form_data.set("es_deudor_o_no.datos_de_la_persona.dato_a_consultar","")
form_data.set("es_deudor_o_no.datos_de_la_persona.cedula","")


#::: Generador de Consecutivos :::#
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get('/consecutive/generador_pagoboletas/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)

infraccion_propia = form_data.get("es_deudor_o_no.datos_de_la_persona.tipo_documento")
if (infraccion_propia.blank?)
    form_data.set("es_deudor_o_no.datos_de_la_persona.infraccion_propia","Si")
    #::: Llenado de Datos del Solicitante
    #::: DV: Modificada sentencia 04/10/2016 Datos del Solcitante o Representante legal
    _person = @application["person_id"]
    _owner = @application["owner_person_id"]
    if @owner["kind_of_user_type"] == "NaturalPerson"
        if _person == _owner
            tipodoc = !@owner["national_id"].blank? ? "Cédula" : "Pasaporte"
            numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
            form_data.set("es_deudor_o_no.datos_de_la_persona.tipo_documento",tipodoc)
            form_data.set("datos_de_la_persona.datos_de_la_persona.nro_de_documento",numdoc)
            form_data.set("es_deudor_o_no.datos_de_la_persona.cedula",numdoc)
    
            nombre = @owner["first_name"]+" "+@owner["second_name"]+" "+@owner["last_name"]+" "+@owner["second_last_name"]
            form_data.set("es_deudor_o_no.datos_de_la_persona.nombre_completo",nombre)
        else
            _idpersona = @application["person_id"].to_s
            result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?person_id=' + "#{_idpersona}" + '&include_all=true').parsed_response
            _hash = result["hash"]
            _persona = _hash["response"]
            tdoc = _persona ["person_gov_id_type"] == "national_id" ? "Cédula" : "Pasaporte"
            form_data.set("datos_de_la_persona.representante.tipo_de_documento",tdoc)
            form_data.set("datos_de_la_persona.representante.nro_de_documento", _persona["person_gov_id_number"])
            form_data.set("datos_de_la_persona.representante.nombre_completo", _persona["name"])
    
            tipodoc = !@owner["national_id"].blank? ? "Cédula" : "Pasaporte"
            numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
            form_data.set("datos_de_la_persona.datos_de_la_persona.tipo_documento_persona_natural",tipodoc)
            form_data.set("datos_de_la_persona.datos_de_la_persona.nro_de_documento",numdoc)
            #form_data.set("es_deudor_o_no.es_deudor_o_no.nro_doc",numdoc)
            form_data.set("es_deudor_o_no.datos_de_la_persona.dato_a_consultar",numdoc)
            nombre = @owner["first_name"]+" "+@owner["second_name"]+" "+@owner["last_name"]+" "+@owner["second_last_name"]
            form_data.set("datos_de_la_persona.datos_de_la_persona.nombre_completo",nombre)
        end
    end
    
    #::: DV: 04/10/2016 Datos del Solcitante Juridico o Representante legal
    if @owner["kind_of_user_type"] == "JuridicalPerson"
        form_data.set("datos_de_la_empresa.datos_de_la_empresa.nro_de_ruc",@owner["tax_id"])
        form_data.set("es_deudor_o_no.datos_de_la_persona.nombre_completo",@owner["name"])
        form_data.set("es_deudor_o_no.datos_de_la_persona.dato_a_consultar",@owner["tax_id"])
        form_data.set("es_deudor_o_no.datos_de_la_persona.tipo_documento","RUC")
    
        _idpersona = @application["person_id"].to_s
        result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?person_id=' + "#{_idpersona}" + '&include_all=true').parsed_response
        _hash = result["hash"]
        _persona = _hash["response"]
        tdoc = _persona ["person_gov_id_type"] == "national_id" ? "Cédula" : "Pasaporte"
        form_data.set("datos_de_la_empresa.representante.tipo_de_documento",tdoc)
        form_data.set("datos_de_la_empresa.representante.nro_de_documento", _persona["person_gov_id_number"])
        form_data.set("datos_de_la_empresa.representante.nombre_completo", _persona["name"])
    end 
else
    form_data.set("es_deudor_o_no.datos_de_la_persona.infraccion_propia","")
end
    end

    on_transition do
      ## MODIFICADO  10-02-2017 MT: Esto debido a que incialmente el valor a buscar en el servicio 
# proxy_bdin_pago_boletas_attt era el numero  del solicitante, sin importar que se cambiara desde 
#el principio.. Por ello se decidio pasar esta validacion al ON BECOMING del segundo paso, donde 
# solo se extraera la informacion hallada en el campo  es_deudor_o_no.datos_de_la_persona.dato_a_consultar

#::: Obtener los datos a consultar :::#
#::: Si el deudor es el solicitante :::#
#if form_data.get("es_deudor_o_no.datos_de_la_persona.infraccion_propia") == "Si"
#    _person = @application["person_id"]
#    _owner = @application["owner_person_id"]
#    if @owner["kind_of_user_type"] == "NaturalPerson"
#        if _person == _owner
#            tipodDoc = !@owner["national_id"].blank? ? "CIP" : "PAS"
#            tipoDoc = !@owner["national_id"].blank? ? "Cédula" : "Pasaporte"
#            nro_doc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
#        end
#    else
#       tipodDoc = "RUC"
#       tipoDoc = "RUC"
#       nro_doc = @owner["tax_id"]
#    end
#    form_data.set("es_deudor_o_no.datos_de_la_persona.tipo_documento",tipoDoc)
#    form_data.set("es_deudor_o_no.datos_de_la_persona.dato_a_consultar",nro_doc)
#else
#    #::: Si los deudores son otros :::#                            
#    tipo_docD = form_data.get("es_deudor_o_no.datos_de_la_persona.tipo_documento")
#    if tipo_docD == "Cédula"
#        tipodDoc = "CIP"
#    end
#    if tipo_docD == "Pasaporte"
#        tipodDoc = "PAS"
#    end
#    if tipo_docD == "Placa"
#        tipodDoc = "PLACA"
#    end
#    if tipo_docD == "RUC"
#        tipodDoc = "RUC"
#    end
#    nro_doc = form_data.get("es_deudor_o_no.datos_de_la_persona.dato_a_consultar")
#end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Validación para ocultar seccion de confirmación si y motivo de solicitud
/* $(document).ready(function(){
  var valor = $('input[name="[field][es_deudor_o_no_datos_de_la_persona_infraccion_propia]"]:checked').val();
  if(valor == undefined){
    $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").hide();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
  }
});

//::: DV: Función para ocultar campo de deudores ::://
$(document).ready(function(){
  $(function() {
    $('input[name="[field][es_deudor_o_no_datos_de_la_persona_infraccion_propia]"]').change(function() {
      if ($('input[name="[field][es_deudor_o_no_datos_de_la_persona_infraccion_propia]"]:checked').val() == "No"){
        $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").show();
        $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
        $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').val("");
        $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
      }else{
        $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").hide();
        $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
      }
    });
  });

  //::: Mantener los datos entre pasos ::://
  if ($('input[name="[field][es_deudor_o_no_datos_de_la_persona_infraccion_propia]"]:checked').val() == "No"){
    $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").show();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
  }else if ($('input[name="[field][es_deudor_o_no_datos_de_la_persona_infraccion_propia]"]:checked').val() == "Si"){
    $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").hide();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
  }else{
    $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').parents(".field-box").hide();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
  }
}); */

//::: Limpiar nro de documento cuando se cambia de tipo ::://
$(document).ready(function(){
   TiDoc = $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento');
  if ($(TiDoc).find(':selected').val() == "Cédula"){
    $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").show();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
  }else{
    $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").hide();
    $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
  }
  $('#field_es_deudor_o_no_datos_de_la_persona_infraccion_propia').parents(".field-box").hide();
  $( function() {
      TiDoc.change(function() {
        if ($(TiDoc).find(':selected').val() == "") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").hide();
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
        }
        if ($(TiDoc).find(':selected').val() == "Cédula") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").show();
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").hide();
        }
        if ($(TiDoc).find(':selected').val() == "Pasaporte") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").hide();
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
        }
        if ($(TiDoc).find(':selected').val() == "RUC") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").hide();
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
        }
         if ($(TiDoc).find(':selected').val() == "Placa") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').val("");
          $('#field_es_deudor_o_no_datos_de_la_persona_cedula').parents(".field-box").hide();
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').parents(".field-box").show();
        }
    }); 
  });    
});

//::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){  
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Datos de la Consulta") {  
        $(this).html("Datos de la Consulta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Consulta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});


$(document).ready(function(){
  // VDIAZ - cambios de presentación
  // elimina el boton de maximizar    
  $(".panel-control-fullscreen2").remove();
  $(".panel-control-collapse").remove();
  $(".panel-control-collapse-all").remove();
  
});
    STEPAJAXCODE
  end
            
