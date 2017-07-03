
  class Paso3DatosDeLaObra < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      _creacion = form_data.get("datos_de_la_obra_artistica.detalles_de_la_obra.fecha_de_creacion")
_terminacion = form_data.get("datos_de_la_obra_artistica.detalles_de_la_obra.fecha_de_terminacion")
_publicacion= form_data.get("datos_de_la_obra_artistica.detalles_de_la_obra.fecha_de_publicacion")

    if (_creacion.to_date > _terminacion.to_date)
        transition_errors << "La fecha de creación, no debe ser posterior a la fecha de terminación"
    end if _creacion.present? && _terminacion.present?

    if (_terminacion.to_date > _publicacion.to_date)
        transition_errors << "La fecha de terminación, no debe ser posterior a la fecha de publicación"
    end if _terminacion.present? && _publicacion.present?
        
    if (_creacion.to_date > _publicacion.to_date)
        transition_errors << "La fecha de creación, no debe ser posterior a la fecha de publicación"
    end if _creacion.present? && _publicacion.present?
    
    if (_creacion.to_date > Date.today)
        transition_errors << "La fecha de creación, no debe ser posterior a la fecha actual"
    end if _creacion.present?
            
    if (_terminacion.to_date > Date.today)
        transition_errors << "La fecha de terminación, no debe ser posterior a la fecha actual"
    end if _terminacion.present?
    
    if (_publicacion.to_date > Date.today)
        transition_errors << "La fecha de publicación, no debe ser posterior a la fecha actual"
    end if _publicacion.present?




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
      $(document).ready(function(){
    ocultaCampoTransferencia();
    if($('input[name="[field][datos_de_la_obra_artistica_detalles_de_la_obra_tipo_de_arte]"]:checked').val() == "Otros"){
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parents(".field-box").show();
    }else{
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parents(".field-box").hide();
    }
    if($('input[name="[field][datos_de_la_obra_artistica_detalles_de_la_obra_estatus_de_la_obra]"]:checked').val() == "Publicada"){
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_fecha_de_publicacion").parents(".field-box").show();
    }else{
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_fecha_de_publicacion").parents(".field-box").hide();
    }
});



$( function() {
    $( "input:radio" ).click(function() {
        checkHideField(this);
    });
});

function checkHideField(obj) {
    if (obj.value == "Otros" && obj.name=="[field][datos_de_la_obra_artistica_detalles_de_la_obra_tipo_de_arte]"){
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parents(".field-box").show();
    }else if (obj.value != "Otros" && obj.name=="[field][datos_de_la_obra_artistica_detalles_de_la_obra_tipo_de_arte]"){  
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").val('')
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_otro_arte").parents(".field-box").hide();
    } else if (obj.value == "Inédita" && obj.name=="[field][datos_de_la_obra_artistica_detalles_de_la_obra_estatus_de_la_obra]"){
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_fecha_de_publicacion").val('')
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_fecha_de_publicacion").parents(".field-box").hide();
    }else if (obj.value == "Publicada" && obj.name=="[field][datos_de_la_obra_artistica_detalles_de_la_obra_estatus_de_la_obra]"){  
        $("#field_datos_de_la_obra_artistica_detalles_de_la_obra_fecha_de_publicacion").parents(".field-box").show();
    }
}

$( function() {
   $(document).ready(function(){
     $("input[name='[field][datos_de_la_obra_artistica_transferencia_transferencia][]']").click(function(event){
        $(this).each(function(){
            if (this.checked) {
                var dato = $(this).val();
                if(dato == 'Transferencia'){
                    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").parents(".field-box").show();
                }
            }
            if (!this.checked) {
                var dato = $(this).val();
                if(dato == 'Transferencia'){
                    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").val('');
                    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").parents(".field-box").hide();
                }
            }
        });
    });
 });
});



function ocultaCampoTransferencia(){
  if($("input[name='[field][datos_de_la_obra_artistica_transferencia_transferencia][]']:checked").val() == "Transferencia"){
    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").parents(".field-box").show();
  }
  else {
    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").val('');
    $("#field_datos_de_la_obra_artistica_transferencia_descripcion_transferencia").parents(".field-box").hide();
  }  
}
    STEPAJAXCODE
  end
            
