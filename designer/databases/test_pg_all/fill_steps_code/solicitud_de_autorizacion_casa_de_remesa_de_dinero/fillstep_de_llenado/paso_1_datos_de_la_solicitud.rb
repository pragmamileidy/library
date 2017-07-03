
  class Paso1DatosDeLaSolicitud < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      if @owner["kind_of_user_type"] == "NaturalPerson"
    typeDoc = form_data.get("solicitante_natural.datos_del_abogado_litigante.cedula_o_pasaporte")
    if typeDoc != "Pasaporte" 
        numdoc = form_data.get("solicitante_natural.datos_del_abogado_litigante.cedula_a_autorizar")
        result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
        datosSol = result["response"]
        if datosSol.blank? 
            transition_errors << "La Cédula #{numdoc} no fue encontrada. Por favor, verifique." 
        else            
            difunto = datosSol["cod_mensaje"]
            if (difunto == "534")
                transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{numdoc} del Señor(a), corresponde a un ciudadano Difunto."
            end
        end
    end
end

###form_data.set("solicitante_juridico.datos_generales_de_empresa.fecha_de_inscripcion","salió del if de natural")

#Solicitante Jurídico
#Empresa
## Chantal Valverde 01-Abr-2017. Agregado para que la fecha se setee en el formato correcto y corregir error en logs por fecha cuando viene vacía en el servicio
if @owner["kind_of_user_type"] == "JuridicalPerson"
    _ruc = form_data.get("solicitante_juridico.datos_generales_de_empresa.ruc")
    _ti_so = form_data.get("solicitante_juridico.datos_generales_de_empresa.tipo_sociedad")
    result = WebserviceConsumer.get( '/service/bdin_registro_publico_empresas/find.json?ruc=' + _ruc +'&tipo_sociedad=' + _ti_so).parsed_response
    emp = result["response"]
    if emp.nil?
        transition_errors << "Los datos de la empresa no fueron encontrados, por favor verifique."
    else
        fecha=emp["fecha_inscripcion"].to_s
        if !fecha.blank?
            if fecha.index("-")==nil 
                fecha.insert(2,"-")
                fecha.insert(5,"-")
            end
        end
        ##form_data.set("solicitante_juridico.datos_generales_de_empresa.fecha_de_inscripcion",emp["fecha_inscripcion"])
        form_data.set("solicitante_juridico.datos_generales_de_empresa.fecha_de_inscripcion",fecha)
        form_data.set("solicitante_juridico.datos_generales_de_empresa.se_dedicara_a_ofrecer_texto", "Transferencia de Dinero")
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.tomo",emp["rollo-tomo"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.folio",emp["imagen-folio"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.asiento",emp["asiento"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.domicilio_legal",emp["sociedad_domicilio"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.nombre_comercial",emp["nombre_empresa"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.digito_verificador",emp["digito_verificador"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.apartado_postal",emp["codigo_postal"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.telefono_o_celular",emp["tlf_movil"])
    	form_data.set("solicitante_juridico.datos_generales_de_empresa.correo_electronico",emp["email"])
    	form_data.set("solicitante_juridico.datos_de_ubicacion.provincia",emp["provincia"])
    	form_data.set("solicitante_juridico.datos_de_ubicacion.distrito",emp["distrito"])
    	form_data.set("solicitante_juridico.datos_de_ubicacion.corregimiento",emp["corregimiento"])
    	form_data.set("solicitante_juridico.datos_de_ubicacion.calle_o_avenida",emp["calle"])
    	form_data.set("solicitante_juridico.datos_de_ubicacion.edificio_casa",emp["nro-casa-apto"])
    end
end

##LP comentado por solicitud ticket 20 25-0-2-17
#::: DV: Descomentado por solicitud
#Solicitante Natural
if @owner["kind_of_user_type"] == "NaturalPerson"
    #   #Empresa
    #   _ruc = form_data.get("solicitante_natural.datos_del_local.ruc")
    #   _ti_so = form_data.get("solicitante_natural.datos_del_local.tipo_sociedad")
    #   result = WebserviceConsumer.get('/service/bdin_registro_publico_empresas/find.json?ruc=' + _ruc + '&tipo_sociedad=' + _ti_so).parsed_response
    #   emp = result["response"]
    #   if emp.nil?
    #       transition_errors << "Los datos del local no fueron encontrados, por favor verifique."
    #   else
    #   #   direccion =  "#{emp["calle"]} "+",#{emp["nro-casa-apto"]} "+",#{emp["corregimiento"]} "+",#{emp["distrito"]} "+",#{emp["provincia"]}"
            
    #       form_data.set("solicitante_natural.datos_del_local.nombre_comercial",emp["nombre_empresa"])
    #       form_data.set("solicitante_natural.datos_del_local.digito_verificador",emp["digito_verificador"])
    #       form_data.set("solicitante_natural.datos_del_local.telefono_o_celular",emp["tlf_movil"])
    #       form_data.set("solicitante_natural.datos_del_local.correo_electronico",emp["email"])
    #   #   form_data.set("solicitante_natural.datos_del_local.apartado_postal",emp["codigo_postal"])
    #       #form_data.set("solicitante_natural.datos_del_local.ubicacion_del_establecimiento_comercial")
    #         form_data.set("solicitante_natural.datos_del_local.se_dedicara_a_ofrecer", "Transferencia de Dinero")
    #   end
    form_data.set("solicitante_natural.datos_del_local.se_dedicara_a_ofrecer", "Transferencia de Dinero")
 end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $("div").each (function(){
      if ($(this).html().trim() == "Número de Cédula/Pasaporte del Señor(a) a autorizar*") {
          $(this).html("Número de Cédula del Señor(a) a autorizar*");
      }
  });
});

$(document).ready(function(){
   TiDoc = $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_o_pasaporte');
  if ($(TiDoc).find(':selected').val() == "Cédula"){
    $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").show();
    $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").hide();
  }else if ($(TiDoc).find(':selected').val() == "Pasaporte"){
    $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").hide();
    $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").show();
  } else {
    $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").hide();
    $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").hide();
  }
  $( function() {
      TiDoc.change(function() {
        if ($(TiDoc).find(':selected').val() == "") {
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").hide();
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").hide();
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').val("");
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Cédula") {
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").show();
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").hide();
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').val("");
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').val("");
        }
        if ($(TiDoc).find(':selected').val() == "Pasaporte") {
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').parents(".field-box").hide();
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').parents(".field-box").show();
          $('#field_solicitante_natural_datos_del_abogado_litigante_cedula_a_autorizar').val("");
          $('#field_solicitante_natural_datos_del_abogado_litigante_pasaporte').val("");
        }
    }); 
  });

});
    STEPAJAXCODE
  end
            
