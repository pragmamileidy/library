
  class Paso3DatosDeLaObra < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      #:::: VALIDACION DE FECHAS - DV ::::#
## CHANTAL VALVERDE. Descomentado 06-Abr-2017 por ticket 183
require 'date'

fecha_publicacion = form_data.get("informacion_de_la_obra_literaria.datos_de_la_obra.fecha_de_publicacion")
ano_creacion = form_data.get("informacion_de_la_obra_literaria.datos_de_la_obra.ano_creacion_de_la_obra")

if (fecha_publicacion.to_date > Date.today)
   transition_errors << "La Fecha de Publicación, no debe ser posterior a la fecha actual"
end

#:::: DV: Modificado para validar el año de creación con el año de publicación ::::#
_publicacion = Date.parse(fecha_publicacion).strftime("%Y")
if (ano_creacion.to_i > _publicacion.to_i)
   transition_errors << "El Año de Creación de la Obra no debe ser mayor al año de la Fecha de Publicación"
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
   // $( "input:radio" ).click( check1 ).filter( "[value='O']" ).attr( "checked", "checked" );
   $( "input:radio" ).click(function() {
   	check3(this);
   });
});

function check3(obj) {

	if (obj.value == "Otras" && obj.name=="[field][informacion_de_la_obra_literaria_datos_de_la_obra_tipo_de_obra]"){
		$("#field_informacion_de_la_obra_literaria_datos_de_la_obra_otro").parent().parent().show();

	} else if (obj.value != "Otras" && obj.name=="[field][informacion_de_la_obra_literaria_datos_de_la_obra_tipo_de_obra]"){	
		$("#field_informacion_de_la_obra_literaria_datos_de_la_obra_otro").val('');					
		$("#field_informacion_de_la_obra_literaria_datos_de_la_obra_otro").parent().parent().hide();
	} else if (obj.value == "Inédita" && obj.name=="[field][informacion_de_la_obra_literaria_datos_de_la_obra_estatus_de_la_obra]"){
        $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").val('')
        $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").hide();
    } else if (obj.value == "Publicada" && obj.name=="[field][informacion_de_la_obra_literaria_datos_de_la_obra_estatus_de_la_obra]"){  
        $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").show();
    }
}



$(document).ready(function(){
	ocultaCampoTransferencia();
	if($('input[name="[field][informacion_de_la_obra_literaria_datos_de_la_obra_tipo_de_obra]"]:checked').val() == "Otras"){
		$("#field_informacion_de_la_obra_literaria_datos_de_la_obra_otro").parent().parent().show();
	}else{
		$("#field_informacion_de_la_obra_literaria_datos_de_la_obra_otro").parent().parent().hide();
	}
	if($('input[name="[field][informacion_de_la_obra_literaria_datos_de_la_obra_estatus_de_la_obra]"]:checked').val() == "Publicada"){
        $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").show();
    }else{
        $("#field_informacion_de_la_obra_literaria_datos_de_la_obra_fecha_de_publicacion").parents(".field-box").hide();
    }
});

function ocultaCampoTransferencia(){
  if($("input[name='[field][transferencia_sinopsis_de_la_obra_transferencia][]']:checked").val() == "Transferencia"){
    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").parents(".field-box").show();
  }
  else {
    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").val('');
    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").parents(".field-box").hide();
  }  
}

$( function() {
   $(document).ready(function(){
     $("input[name='[field][transferencia_sinopsis_de_la_obra_transferencia][]']").click(function(event){
        $(this).each(function(){
            if (this.checked) {
                var dato = $(this).val();
                if(dato == 'Transferencia'){
                    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").parents(".field-box").show();
                }
            }
            if (!this.checked) {
                var dato = $(this).val();
                if(dato == 'Transferencia'){
                    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").val('');
                    $("#field_transferencia_sinopsis_de_la_obra_descripcion_transferencia").parents(".field-box").hide();
                }
            }
        });
    });
 });
});

    STEPAJAXCODE
  end
            
