
  class Paso1DatosDelSolicitante < TemplateCode::Step

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
        nombre = @owner["first_name"]+" "+@owner["second_name"]+" "+@owner["last_name"]+" "+@owner["second_last_name"]
        form_data.set("datos_de_la_persona.datos_de_la_persona.nombre_completo",nombre)
    end
end

#::: DV: 04/10/2016 Datos del Solcitante Juridico o Representante legal
if @owner["kind_of_user_type"] == "JuridicalPerson"
    form_data.set("datos_de_la_empresa.datos_de_la_empresa.nro_de_ruc",@owner["tax_id"])
    form_data.set("datos_de_la_empresa.datos_de_la_empresa.razon_social",@owner["name"])

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
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){  
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Datos de la Persona que debe pagar la boleta") {  
        $(this).html("Datos de la Persona que debe pagar la boleta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Persona que debe pagar la boleta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Información de la Persona Jurídica") {  
        $(this).html("Datos de la Persona Jurídica que debe pagar la boleta"); 
      }
    });
  });

  $( function() {
    var hint = "Datos de la Persona Jurídica que debe pagar la boleta";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});
    STEPAJAXCODE
  end
            
