
  class Paso1DatosBasicosDeLaSolicitud < TemplateCode::Step

    on_becoming do
      #::::: Obtener numero consecutivo y crear consecutivo de tramite
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
if form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud").blank?
  result = WebserviceConsumer.get( '/consecutive/generador_dij2/generate.json').parsed_response
  consecutivo = result["response"]
  consecutivo = "#{@application["id"]}-"+"#{consecutivo["value"]}"
  form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",consecutivo)
end

##LP: Setear motivo trabajo si en PN
form_data.set("tipo_de_solicitud_dij.tipo_de_solicitud_dij.motivo_de_la_solicitud_dij","Trabajo")
form_data.set("tipo_de_solicitud_dij.tipo_de_solicitud_dij.tipo_de_solicitud_dij","Laboral")

_person = @application["person_id"]
_owner = @application["owner_person_id"]
if @owner["kind_of_user_type"] == "NaturalPerson"
  if _person == _owner
    tipodoc = !@owner["national_id"].blank? ? "Cedula" : "Pasaporte"
    numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento",tipodoc)
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",numdoc)
  end
end


    end

    on_transition do
      #:::::DV:  UN SOLO TITULAR - OnTransition Paso 1:::::#
_person = @application["person_id"]
_owner = @application["owner_person_id"]
if @owner["kind_of_user_type"] == "NaturalPerson"
  if _person == _owner
    tipodoc = !@owner["national_id"].blank? ? "Cedula" : "Pasaporte"
    numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.tipo_de_documento",tipodoc)
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.cedula_pasaporte",numdoc)
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre",@owner["first_name"])
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre",@owner["second_name"])
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido",@owner["last_name"])
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido",@owner["second_last_name"])
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada",@owner["married_name"])
    sexo = ((@owner["gender"] == "female")) ? "Femenino" : "Masculino"
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.sexo",sexo)
    form_data.set("datos_del_titular_rp.datos_de_ubicacion.direccion",@owner["full_address"])
    form_data.set("datos_del_titular_rp.datos_de_ubicacion.numero_de_telefono",@owner["fixed_number"])
    form_data.set("datos_del_titular_rp.datos_de_ubicacion.correo_electronico",@owner["email"])
    form_data.set("datos_del_titular_rp.datos_del_padre.documento_hijo",numdoc)
    form_data.set("datos_del_titular_rp.datos_de_la_madre.documento_hijo",numdoc)
    
    #::: CONVERSION FECHA DE NACIEMIENTO :::#
    fecha = @owner["birthday"]
    fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_n)
    #::: CALCULA EDAD :::#
    edad = ((Date.today - fecha.to_date).to_f / 365).to_i
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.edad",edad)

    #:::: USADO PARA PRINT DESIGN
    primerNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_nombre")
    segundoNombret = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_nombre")
    primerApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.primer_apellido")
    segundoApellidot = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.segundo_apellido")
    apellidoCasadat = form_data.get("datos_del_titular_rp.datos_basicos_de_persona_natural.apellido_de_casada")
    nombreCompletot = "#{primerNombret} #{segundoNombret} #{primerApellidot} #{segundoApellidot} #{apellidoCasadat}"
    form_data.set("datos_del_titular_rp.datos_basicos_de_persona_natural.nombre_completo",nombreCompletot.squish)

    #:::: CODIGO UNICO PARA TITULAR
    co_result = WebserviceConsumer.default_get( '/consecutive/codigo_unico_dij2/generate.json').parsed_response
    cod_unico = co_result["response"]
    cod_unico = cod_unico["value"]
    form_data.set("datos_del_titular_rp.codigo_unico_dij.codigo_unico",cod_unico)

    #:::: GENERA CONSECUTIVO INDIVIDUAL
    form_data.set("datos_del_titular_rp.datos_de_solicitud.fecha_de_solicitud",@application["created_at"])
    result_cons = WebserviceConsumer.default_get( '/consecutive/generador_dij3/generate.json').parsed_response
    consecut = result_cons["response"]
    consecut = "#{@application["id"]}-"+"#{consecut["value"]}"
    form_data.set("datos_del_titular_rp.datos_de_solicitud.numero_de_solicitud",consecut)
  end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
  $("#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento").parents(".part-box").hide();
  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Gestion solicitud") {  
        $(this).html("Estimado usuario si Usted requiere su Récord Policivo con firma diríjase a la DIJ más cercana; de lo contrario continúe con el trámite."); 
      }
    });
  });

  $( function() {
    var part_name = "Estimado usuario si Usted requiere su Récord Policivo con firma diríjase a la DIJ más cercana; de lo contrario continúe con el trámite.";
    $("span").each (function(){
      if ($(this).html().trim() == part_name) {  
        $(this).html(part_name).css({'color':'#FF5733','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Datos de la Persona") {  
        $(this).html(""); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Gestión de Solicitud") {  
        $(this).html("Gestión de Solicitud"); 
      }
    });
  });

  $( function() {
    var hint = "Por favor adjuntar archivo correspondiente";
      $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#088A08','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Titular") {  
        $(this).html("Adjuntos requeridos"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Recepción Ventanilla Única") {  
        $(this).html("Recepción Ventanilla Única"); 
      }
    });
  });
});
    STEPAJAXCODE
  end
            
