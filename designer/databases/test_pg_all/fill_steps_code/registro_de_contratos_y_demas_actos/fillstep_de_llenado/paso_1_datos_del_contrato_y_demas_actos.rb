
  class Paso1DatosDelContratoYDemasActos < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
numero_de_solicitud = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")
if !numero_de_solicitud.present?
result = WebserviceConsumer.get( '/consecutive/generador_registrocontratos/generate.json').parsed_response
_consecutivo = result["response"]
_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
end
    end

    on_transition do
      ### Validación de Fecha de Firma del Contrato - LP 23-02-17 ###

fecha_firma1 = form_data.get("especificaciones_del_contrato_y_demas_actos.lugar_y_fecha_de_la_firma_instance_1.fecha_en_que_fue_firmado_el_contrato") 
if (fecha_firma1.present? && fecha_firma1.to_date > Date.today)
    transition_errors << "La fecha de la firma 1, no debe ser mayor a la fecha actual"
end


fecha_firma2 = form_data.get("especificaciones_del_contrato_y_demas_actos.lugar_y_fecha_de_la_firma_instance_2.fecha_en_que_fue_firmado_el_contrato") 
if (fecha_firma2.present? && fecha_firma2.to_date > Date.today)
    transition_errors << "La fecha de la firma 2, no debe ser mayor a la fecha actual"
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //-------------------------------------------------------------------------------------------
// LP Para Habilitar campo dependiendo dependiendo del valor del radio seleccionado 22/02/17
//-------------------------------------------------------------------------------------------
$(document).ready(function(){
    //Comportamiento al cambiar selección del radio
    $('input[name="[field][especificaciones_del_contrato_y_demas_actos_clase_de_contrato_tipo_de_contrato]"]').change(function() {  
    //Meter el valor seleccionado del radio butonn en una variable  
        var dato = $("input[name='[field][especificaciones_del_contrato_y_demas_actos_clase_de_contrato_tipo_de_contrato]']:checked").val();     
        if(dato =="Otros"){
            //Habilitar campo especificar
                $("#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo").parents(".field-box").show();
        } else {
            //Limpiar campo especificar
            $('#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo').val("");
            //Deshabilitar campo especificar
            $("#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo").parents(".field-box").hide();
        }   
    }); 

    //Mantener cambios entre pasos
        //Meter el valor seleccionado del radio butonn en una variable  
    var dato = $("input[name='[field][especificaciones_del_contrato_y_demas_actos_clase_de_contrato_tipo_de_contrato]']:checked").val();     
    if(dato =="Otros"){
        //Habilitar campo especificar
            $("#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo").parents(".field-box").show();
    } else {
        //Limpiar campo especificar
        $('#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo').val("");
        //Deshabilitar campo especificar
        $("#field_especificaciones_del_contrato_y_demas_actos_clase_de_contrato_especificar_tipo").parents(".field-box").hide();
    }   
});
    STEPAJAXCODE
  end
            
