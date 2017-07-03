
  class Paso2DatosDeBoletasPendientesDePago < TemplateCode::Step

    on_becoming do
      #::: DV: 08/09/2016: Obtener valor del config :::#
valor = @config.route("Rates-payment-payment-payment")
if valor == "Electrónico"
  form_data.set("formas_de_pagos_generico.pago_electronico_mensaje.tipo_de_pago_electronico", "Pago Electrónico")
end
    end

    on_transition do
      #::: Validar se chequee la tabla para pagar el monto de la boleta :::#
if form_data.get("boletas_por_pagar.monto.motivo_de_la_multa") == "true"
    boletas_selec = form_data.get("boletas_por_pagar.monto.field_oculto")
    boletas = boletas_selec.blank? ? nil : ActiveSupport::JSON.decode(boletas_selec)
    if boletas.blank?
        transition_errors << "Para procesar su pago usted debe seleccionar las boletas a cancelar. Por favor, seleccione un valor en pagar boleta."
    end
end
    
#::: CODIGO PARA INVOCAR EL SERVICIO payment_computing_service :::#
form_id = @task["form"]
monto_total = form_data.get("boletas_por_pagar.monto.oculto_multa")
result = WebserviceConsumer.get('/service/helper_update_payment/call.json?method=update_amount_payment&form_id=' + "#{form_id}" + '&amount=' + "#{monto_total}").parsed_response
if result["response"] == true
    #::: CODIGO PARA INVOCAR EL SERVICIO payment_computing_service
    _applicationId = @application["id"]
    _configRoute = "Rates-rates"
    _formId = @task["form"]

    hash = {:application_id => "#{_applicationId}", 
            :config_route   => "#{_configRoute}",
            :form_id        => "#{_formId}"}
    result = PaymentProxy.payment_computing_service(hash)

    _payment_id= result["response"]["payment_id"]
    _detail = result["response"]["detail"]
    _total = result["response"]["result"]["total"]

    form_data.set("variables_pago_generico.variables_pago_generico.payment",_payment_id)
    form_data.set("variables_pago_generico.variables_pago_generico.detail",_detail)
    form_data.set("datos_del_evaluador_generico.monto_total.monto_total", _total)
    #form_data.set("datos_del_evaluador_generico.monto_total.monto_total","0.01")

    result["response"]["result"]["items"].each do |key, value|
        if(key =~ /item_instance_([\d]+)/)
            _i = $1.to_i - 1
            form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.nombre_de_la_entidad", value["name"])
            form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.pagada", "Iniciada")
            form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.monto_a_pagar", value["formula"])
            #form_data.set("datos_del_evaluador_generico.entidad_evaluadora_#{_i}.monto_a_pagar","0.01")
        end 
    end
else
    transition_errors << "Ha ocurrido un error"
end

app_id = @application["id"]
form_data.set("boletas_por_pagar.monto.app_id", app_id)
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){ 
  $("#field_boletas_por_pagar_monto_mensaje_notificacion").css({'color':'#0F698D','font-size':'1.0em','text-align':'justify','font-weight:':'bold','white-space':'pre-line'});
  $("#field_boletas_por_pagar_monto_motivo_de_la_multa").parents(".field-box").hide();
  $("#field_boletas_por_pagar_monto_field_oculto").parents(".field-box").hide();
  var boletasSel = $("#field_boletas_por_pagar_monto_motivo_de_la_multa").val();
  if (boletasSel == 'false'){
    $('#field_boletas_por_pagar_monto_monto_de_la_multa').parents(".field-box").hide();
    $('#field_boletas_por_pagar_boletas_instance_1_placa').parents(".part-box").hide();
    $('#field_boletas_por_pagar_boletas_instance_1_placa').parents(".part-box").next().hide()
  }else{
    $("#field_boletas_por_pagar_monto_mensaje_notificacion").parents(".field-box").hide();
    $.each( $('[id*=boletas_por_pagar_boletas_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
          pos = (this.id).match(/_instance_[\d]/);
        }
        var InicioRuta  = "#field_boletas_por_pagar_boletas";
        var boleta     = "_boleta";
        var coincide  = InicioRuta.concat(pos);
        var boleta2    = coincide.concat(boleta);
        $(boleta2).parents(".part-box").next().hide();
    });
  }

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Boletas por Pagar") {  
        $(this).html("Detalles de las Boletas"); 
      }
    });
  });

  $( function() {
    var hint = "Detalles de las Boletas";
      $("span").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});


/*

Legend:

==== FIELDS ====
"0": Check          (Position)
"1": Nro de Boleta  (Position)
"2": Nro de Placa   (Position)
"3": Fecha          (Position)
"4": Motivo         (Position)
"5": Imposicion     (Position)
"6": Monto Boleta   (Position)
"7": Monto Desacato (Position)
"8": Monto Total    (Position)
"9": Campo Oculto   (Position)

*/

$(document).ready(function(){

var show_tickets = $("#boletas_por_pagar .section-body .vertical").children(".dynamic-element-show");
var acum         = 0;

$.fn.hasAttr = function(name) {  
  var attr = this.attr(name)
  return (typeof attr !== typeof undefined && attr !== false);
};

$.each(show_tickets, function(index, item) {
  
  var label      = $(item).children(".label2").find(".panel-title");
  var body       = $(item).children(".part-body");
  var fields     = $($(body).children(".vertical")).children(".field-box");
  var check_hist = $(fields[9]).find("textarea").val();
  var checkboxes = $(fields[0]).find("input");
  var isChecked  = check_hist == "" ? true
                                    : (check_hist == "true" && $(checkboxes[1]).hasAttr("checked"));
  
  var check      = isChecked ? "checked='checked'" : "";
  
  acum = isChecked ? (acum + parseFloat($(fields[8]).find("input").val())) 
                   : acum  + 0;
  
  $(checkboxes[1]).addClass("groupHeader");
  $(checkboxes[1]).prop("checked", isChecked);

  var label_str = ""; // <input  type='checkbox' class='groupHeader' " + check +"/> 
  label_str    += "Nro. de Boleta: " + $(fields[1]).find("input").val() + " | ";
  label_str    += "Fecha: "          + $(fields[3]).find("input").val() + " | ";
  label_str    += "Monto Total: "    + $(fields[8]).find("input").val();
  label.html(label_str);

  // Set Amount
  $("#field_boletas_por_pagar_monto_oculto_multa").val(acum);
  $("#field_boletas_por_pagar_monto_monto_de_la_multa").html(acum);

  //$(fields[0]).css("display","none");
  $(fields[1]).css("display","none");
  $(fields[3]).css("display","none");
  $(fields[8]).css("display","none");

});

$(".groupHeader").click(function(event) {
  var item       = $(this).parents(".part-box");
  var body       = $(item).children(".part-body");
  var fields     = $($(body).children(".vertical")).children(".field-box");
  var checkboxes = $(fields[0]).find("input");
  var acum       = 0;

  $(checkboxes[1]).prop("checked", $(this).is(":checked"));

  if ($(this).is(":checked")) {
    acum = roundToTwo(
      parseFloat($("#field_boletas_por_pagar_monto_monto_de_la_multa").text()) + 
      parseFloat($(fields[8]).find("input").val())
    );
    $(fields[9]).find("textarea").val("true");
    $(checkboxes[0]).val("true"); // Este valor no se esta guardando en DB
  } else {
    acum = roundToTwo(
      parseFloat($("#field_boletas_por_pagar_monto_monto_de_la_multa").text()) - 
      parseFloat($(fields[8]).find("input").val())
    )
    $(fields[9]).find("textarea").val("false");
    $(checkboxes[0]).val("false"); // Este valor no se esta guardando en DB
  }

  $("#field_boletas_por_pagar_monto_oculto_multa").val(acum);
  $("#field_boletas_por_pagar_monto_monto_de_la_multa").html(acum);

  build_json_data();
});

function roundToTwo(value) {
  return (Math.round(value * 100) / 100);
}

function build_json_data() {
  var tickets   = $("#boletas_por_pagar .section-body .vertical").children(".dynamic-element-show");
  var grid_data = [];

  $.each(tickets, function(index, item) {
    var body       = $(item).children(".part-body");
    var fields     = $($(body).children(".vertical")).children(".field-box");
    var checkboxes = $(fields[0]).find("input");
    var isChecked  = $(checkboxes[1]).is(":checked");

    if (isChecked) {
      row = {};

      row['checkbox']       = $(checkboxes[0]).is(":checked");
      row['Nro de Placa']   = $($(fields[2]).find(".only_view_label")).children("div").text();
      row['Nro Boleta']     = $(fields[1]).find("input").val();
      row['Fecha']          = $(fields[3]).find("input").val();
      row['Motivo']         = $($(fields[4]).find(".only_view_label")).children("div").text();
      row['Imposición']     = $($(fields[5]).find(".only_view_label")).children("div").text();
      row['Monto Boleta']   = $($(fields[6]).find(".only_view_label")).children("div").text();
      row['Monto Desacato'] = $($(fields[7]).find(".only_view_label")).children("div").text();
      row['Monto Total']    = $(fields[8]).find("input").val();
      row['yml_data']       = "- Nro de Placa: " + row['Nro de Placa']      + "\n" +
                              "  Nro Boleta: " + row['Nro Boleta']          + "\n" +
                              "  Fecha: " + row['Fecha']                    + "\n" +
                              "  Motivo: " + row['Motivo']                  + "\n" +
                              "  Imposición: " + row['Imposición']          + "\n" +
                              "  Monto Boleta: " + row['Monto Boleta']      + "\n" +
                              "  Monto Desacato: " + row['Monto Desacato']  + "\n" +
                              "  Monto Total: " + row['Monto Total']        + "\n";

      grid_data.push(row);
    }
  });
  $("#field_boletas_por_pagar_monto_campo_data").val(JSON.stringify(grid_data));
  $("#field_boletas_por_pagar_monto_field_oculto").html(JSON.stringify(grid_data));
}
build_json_data();
});
    STEPAJAXCODE
  end
            
