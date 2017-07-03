
  class Paso1ConsultaDeInfracciones < TemplateCode::Step

    on_becoming do
      #::: Generador de Consecutivos :::#
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
result = WebserviceConsumer.get('/consecutive/generador_pagoboletas/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)

#::: Llenado de Datos del Solicitante
#::: DV: Modificada sentencia 04/10/2016 Datos del Solcitante o Representante legal
_person = @application["person_id"]
_owner = @application["owner_person_id"]
if @owner["kind_of_user_type"] == "NaturalPerson"
    if _person == _owner
        tipodoc = !@owner["national_id"].blank? ? "Cédula" : "Pasaporte"
        numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
        form_data.set("datos_de_la_persona.datos_de_la_persona.tipo_documento_persona_natural",tipodoc)
        form_data.set("datos_de_la_persona.datos_de_la_persona.nro_de_documento",numdoc)
        form_data.set("es_deudor_o_no.es_deudor_o_no.nro_doc",numdoc)

        nombre = @owner["first_name"]+" "+@owner["second_name"]+" "+@owner["last_name"]+" "+@owner["second_last_name"]
        form_data.set("datos_de_la_persona.datos_de_la_persona.nombre_completo",nombre)
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
        form_data.set("es_deudor_o_no.es_deudor_o_no.nro_doc",numdoc)
        nombre = @owner["first_name"]+" "+@owner["second_name"]+" "+@owner["last_name"]+" "+@owner["second_last_name"]
        form_data.set("datos_de_la_persona.datos_de_la_persona.nombre_completo",nombre)
    end
end

#::: DV: 04/10/2016 Datos del Solcitante Juridico o Representante legal
if @owner["kind_of_user_type"] == "JuridicalPerson"
    form_data.set("datos_de_la_empresa.datos_de_la_empresa.nro_de_ruc",@owner["tax_id"])
    form_data.set("datos_de_la_empresa.datos_de_la_empresa.razon_social",@owner["name"])
    form_data.set("es_deudor_o_no.es_deudor_o_no.nro_doc",@owner["tax_id"])

    _idpersona = @application["person_id"].to_s
    result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?person_id=' + "#{_idpersona}" + '&include_all=true').parsed_response
    _hash = result["hash"]
    _persona = _hash["response"]
    tdoc = _persona ["person_gov_id_type"] == "national_id" ? "Cédula" : "Pasaporte"
    form_data.set("datos_de_la_empresa.representante.tipo_de_documento",tdoc)
    form_data.set("datos_de_la_empresa.representante.nro_de_documento", _persona["person_gov_id_number"])
    form_data.set("datos_de_la_empresa.representante.nombre_completo", _persona["name"])
end  
    end

    on_transition do
      #::: Si el deudor es el solicitante :::#
deudor = form_data.get("es_deudor_o_no.es_deudor_o_no.deudor")
if deudor == "Si"
    tipo_consulta = form_data.get("es_deudor_o_no.es_deudor_o_no.tipo_consulta")
    if tipo_consulta == "Documento"
        _person = @application["person_id"]
        _owner = @application["owner_person_id"]
        if @owner["kind_of_user_type"] == "NaturalPerson"
            if _person == _owner
                tipodDoc = !@owner["national_id"].blank? ? "CIP" : "PAS" 
            else
               tipodDoc = "RUC"
            end
            nro_doc  = form_data.get("es_deudor_o_no.es_deudor_o_no.nro_doc")
        end
    end

    if tipo_consulta == "Placa"
        tipodDoc = "PLACA"
        nro_doc  = form_data.get("es_deudor_o_no.es_deudor_o_no.placa")
    end

    form_data.set("es_deudor_o_no.consulta_placa.nro_doc", tipodDoc)
    #::: Sustituir la consulta del servicio :::#
    result = WebserviceConsumer.get(URI.escape('/service/dummy_bdin_pago_boletas_attt/call.json?method=findSelBoletasPendientesByDoc&nroDocumento=' + "#{nro_doc}" + '&tipoDocumento=' + "#{tipodDoc}")).parsed_response
else
    #::: Si los deudores son otros :::#                            
    tipo_docD = form_data.get("es_deudor_o_no.datos_de_la_persona.tipo_documento")
    if tipo_docD == "Cédula"
        tipo_docDe = "CIP"
    end
    if tipo_docD == "Pasaporte"
        tipo_docDe = "PAS"
    end
    if tipo_docD == "Placa"
        tipo_docDe = "PLACA"
    end
    if tipo_docD == "RUC"
        tipo_docDe = "RUC"
    end
    nro_doc = form_data.get("es_deudor_o_no.datos_de_la_persona.dato_a_consultar")

    result = WebserviceConsumer.get(URI.escape('/service/dummy_bdin_pago_boletas_attt/call.json?method=findSelBoletasPendientesByDoc&nroDocumento=' + "#{nro_doc}" + '&tipoDocumento=' + "#{tipo_docDe}")).parsed_response
end

if !result["response"].blank?
    result["response"].each_with_index do |data, index|
        index += 1
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.boleta", data["infNroDeBoleta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.placa", data["infNroDePlaca"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.fecha", data["infFechaDeBoleta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.motivo", data["infDescripcionFalta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.imposicion", data["infTipoImposicion"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_boleta", data["infMontoBoleta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_desacato", data["infMontoDesacato"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_total", data["infMontoTotal"])
        form_data.set("boletas_por_pagar.monto.motivo_de_la_multa", "true")
    end
else
    (1..20).each do |x|
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.boleta","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.placa","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.fecha","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.motivo","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.imposicion","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_boleta", "")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_desacato","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_total","")
        form_data.set("boletas_por_pagar.monto.monto_de_la_multa","0")
        form_data.set("boletas_por_pagar.monto.motivo_de_la_multa", "false")
        form_data.set("boletas_por_pagar.monto.mensaje_notificacion","Gracias Ud no tiene boletas pendientes por pagar")
    end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Validación para ocultar seccion de confirmación si y motivo de solicitud
$(document).ready(function(){
  $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".field-box").hide();
  var valor = $('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]:checked').val();
  if(valor == undefined){
    $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").hide();
    $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").hide();
  }
  var valor1 = $('input[name="[field][es_deudor_o_no_es_deudor_o_no_deudor]"]:checked').val();
  if(valor1 == undefined){
    $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").hide();
  }
});

//::: DV: Función para ocultar seccion de deudores ::://
$(document).ready(function(){
  $(function() {
    $('input[name="[field][es_deudor_o_no_es_deudor_o_no_deudor]"]').change(function() {
      if ($('input[name="[field][es_deudor_o_no_es_deudor_o_no_deudor]"]:checked').val() == "No"){
        $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").show();
        $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").hide();
        $('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]').val('');
        $('#field_es_deudor_o_no_consulta_placa_placa').val('');
      }else{
        $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").show();
        $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").hide();
        $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val('');
        $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento').val('');
      }
    });

    //::: Mantener los datos entre pasos ::://
    if ($('input[name="[field][es_deudor_o_no_es_deudor_o_no_deudor]"]:checked').val() == "No"){
      $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").hide();
      $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").show();
    }else if ($('input[name="[field][es_deudor_o_no_es_deudor_o_no_deudor]"]:checked').val() == "Si"){
      $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").show();
      $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").hide();
    }else{
      $('#field_es_deudor_o_no_consulta_placa_campo_oculto').parents(".part-box").hide();
      $('#field_es_deudor_o_no_datos_de_la_persona_campo_oculto').parents(".part-box").hide();
    }
  });

  $(function() {
    $('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]').change(function() {
      if ($('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]:checked').val() == "No"){
        $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").hide();
        $('#field_es_deudor_o_no_consulta_placa_placa').val('');
      }else{
        $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").show();
      }
    });

    //::: Mantener los datos entre pasos ::://
    if ($('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]:checked').val() == "No"){
      $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").hide();
    }else if ($('input[name="[field][es_deudor_o_no_consulta_placa_titular]"]:checked').val() == "Si"){
      $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").show();
    }else{
      $('#field_es_deudor_o_no_consulta_placa_placa').parents(".field-box").hide();
    }
  });
});

//::: Limpiar nro de documento cuando se cambia de tipo ::://
$(document).ready(function(){
  TiDoc = $('#field_es_deudor_o_no_datos_de_la_persona_tipo_documento');
  $( function() {
      TiDoc.change(function() {
        if ($(TiDoc).find(':selected').val() == "") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Cédula") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Pasaporte") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
        }
        if ($(TiDoc).find(':selected').val() == "RUC") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
        }
         if ($(TiDoc).find(':selected').val() == "Placa") {
          $('#field_es_deudor_o_no_datos_de_la_persona_dato_a_consultar').val("");
        }
    }); 
  });    
});

//::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){  
  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos de la Consulta") {  
        $(this).html("Datos de la Consulta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Consulta";
    $("span").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});
    STEPAJAXCODE
  end
            
