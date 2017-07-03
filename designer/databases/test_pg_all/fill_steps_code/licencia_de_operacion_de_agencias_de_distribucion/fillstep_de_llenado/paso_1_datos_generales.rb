
  class Paso1DatosGenerales < TemplateCode::Step

    on_becoming do
      ## Chantal Valverde 21-Mar-2017. Movido del OT de paso 1 a este OB
###Setear informaciòn de tipo de solicitud para mostrar tipo de sociedad en el paso siguiente LP 1-03-17
tipo_so = form_data.get("tipo_de_solicitud.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia.tipo_de_solicitud")
form_data.set("datos_del_establecimiento.datos_de_la_empresa.campo_oculto",tipo_so)
    end

    on_transition do
      #VERIFICACIÒN NUMERO DE CEDULA DEL SOLICITANTE NO PERTENEZCA A UN DIFUNTO

if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
    numdoc = form_data.get("datos_del_solicitante.datos_de_la_persona.cedula")
    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
    datosSol = result["response"]
    if datosSol.blank? 
        transition_errors << "La Cédula #{numdoc} no fue encontrada. Por favor, verifique." 
    else            
        difunto = datosSol["cod_mensaje"]
        if (difunto == "534")
            transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{numdoc} del Solicitante, corresponde a un ciudadano Difunto."
        end
        #setear nombre completo para print design
		primer_nombre = form_data.get("datos_del_solicitante.datos_de_la_persona.primer_nombre")
		segundo_nombre = form_data.get("datos_del_solicitante.datos_de_la_persona.segundo_nombre")
		primer_apellido = form_data.get("datos_del_solicitante.datos_de_la_persona.primer_apellido")
		segundo_apellido = form_data.get("datos_del_solicitante.datos_de_la_persona.segundo_apellido")
		apellido_casada = form_data.get("datos_del_solicitante.datos_de_la_persona.apellido_de_casada")
		nombre_completo = "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido} #{apellido_casada}"
		form_data.set("datos_del_solicitante.datos_de_la_persona.nombre_completo",nombre_completo)
    end
end

###Limpiar valor de licencia de operaciones si tipo de solicitud es igual a inicio
###Lp 09-03-17
valor = form_data.get("tipo_de_solicitud.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia.tipo_de_solicitud")

if valor =="Inicio"

  form_data.set("datos_del_establecimiento.registro_de_empresa.licencia_de_operacion","")

end

##Chantal Valverde. 12-Abr-2107. Limpiar valor de Tipo de Sociedad si tipo de solicitud es inicio

##tipo_solicitud = form_data.get("tipo_de_solicitud.tipo_de_solicitud_de_licencia_de_operaciones_de_farmacia.tipo_de_solicitud")

##if tipo_solicitud =="Inicio"
##  form_data.set("datos_del_establecimiento.datos_de_la_empresa.tipo_sociedad","")
##end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $( function() {
  $("#field_datos_del_establecimiento_direccion_provincia_lista").change(function(){
    var prov = $("#field_datos_del_establecimiento_direccion_provincia_lista").find(':selected').val();
    distritos(prov);
  });
  $("#field_datos_del_establecimiento_direccion_distrito_lista").change(function(){
    var distrito = $("#field_datos_del_establecimiento_direccion_distrito_lista").find(':selected').val();
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
        $("#field_datos_del_establecimiento_direccion_distrito_lista").html(html_options);
        $("#field_datos_del_establecimiento_direccion_corregimiento_lista").html("");
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
        $("#field_datos_del_establecimiento_direccion_corregimiento_lista").html(html_options);
            }
          );
}

$(document).ready(function(){

  cedula = $("#field_datos_del_solicitante_datos_de_la_persona_cedula");
  if ($(cedula).val() == ""){
    $("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().hide();
    $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().show();
  }

  pasaporte = $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte");
  if ($(pasaporte).val() == "") {
    $("#field_datos_del_solicitante_datos_de_la_persona_cedula").parent().parent().show();
    $("#field_datos_del_solicitante_datos_de_la_persona_pasaporte").parent().parent().hide();
  }
});

////////////////////// CAMBIANDO ALGUNOS LABELS

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Teléfono de Oficina*") {
          $(this).html("Número de teléfono Fijo*");
      }
  });
});

$( function() {
  $(".field-label").each (function(){
      if ($(this).html().trim() == "Número de Fax") {
          $(this).html("Número de teléfono Móvil");
      }
  });
});

////Mostrar licencia de operaciòn si tipo de solicitud es Inicio LP 13-03-17
var t_solicitud = $('#field_datos_del_establecimiento_datos_de_la_empresa_campo_oculto').val();   
if(t_solicitud =="Inicio" ){
   //mostrar parte licencia_de_operacion
   $("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").hide();
   } else {
   $("#field_datos_del_establecimiento_registro_de_empresa_licencia_de_operacion").parents(".part-box").show();
}
    STEPAJAXCODE
  end
            
