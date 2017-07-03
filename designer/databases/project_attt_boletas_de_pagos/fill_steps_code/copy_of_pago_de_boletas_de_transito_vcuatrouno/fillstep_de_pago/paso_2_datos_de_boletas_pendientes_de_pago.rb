
  class Paso2DatosDeBoletasPendientesDePago < TemplateCode::Step

    on_becoming do
      ##### Agregado recientemente 10-02-2017 MT: Como cambio para poder tomar el actual
#valor del campo "es_deudor_o_no.datos_de_la_persona.dato_a_consultar"

tipo_docD = form_data.get("es_deudor_o_no.datos_de_la_persona.tipo_documento")
if tipo_docD == "Cédula"
    tipodDoc = "CIP"
elsif tipo_docD == "Pasaporte"
    tipodDoc = "PAS"
elsif tipo_docD == "Placa"
    tipodDoc = "PLACA"
elsif tipo_docD == "RUC"
    tipodDoc = "RUC"
end
nro_doc = form_data.get("es_deudor_o_no.datos_de_la_persona.dato_a_consultar")
if nro_doc.blank?
    nro_doc = form_data.get("es_deudor_o_no.datos_de_la_persona.cedula")
    form_data.set("es_deudor_o_no.datos_de_la_persona.dato_a_consultar",nro_doc)
end
Rails.logger.info(">>>>>>>> PARAMETROS >>>>>>>>>>>>>>> #{nro_doc}")
#::: Sustituir la consulta del servicio :::#
result = WebserviceConsumer.get(URI.escape('/service/proxy_bdin_pago_boletas_attt/call.json?method=findSelBoletasPendientesByDoc&nroDocumento=' + "#{nro_doc}" + '&tipoDocumento=' + "#{tipodDoc}")).parsed_response
Rails.logger.info(">>>>>>>> RESPONDE SERVICES>>>>>>>>>>>>>>> #{result}")

if result["response"].present? && !result["response"]["error"].present?
  datos = result["response"]
else 
  Rails.logger.info("findSelBoletasPendientesByDoc con error >>>>>> #{result}")
  Rails.logger.info("findSelBoletasPendientesByDoc respuesta vacía") if !result["response"].present?
  datos = nil
end
  
if datos.present?
    datos.each_with_index do |data, index|
        Rails.logger.info(">>>>>>>> RESPONDE INDEX >>>>>>>>>>>>>>> #{index}")
        Rails.logger.info(">>>>>>>> RESPONDE DATA >>>>>>>>>>>>>>> #{data}")
        index += 1
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.boleta", data["infNroDeBoleta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.placa", data["infNroDePlaca"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.fecha", data["infFechaDeBoleta"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.faltas_json", data["infFaltas"]).to_json
        #form_data.set("boletas_por_pagar.boletas_instance_#{index}.motivo", data["infDescripcionFalta"])
        #form_data.set("boletas_por_pagar.boletas_instance_#{index}.imposicion", data["infTipoImposicion"])
        #form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_boleta", data["infMontoBoleta"])
        #form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_desacato", data["infMontoDesacato"])
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_total", data["infMontoBoletaTotal"])
        form_data.set("boletas_por_pagar.monto.motivo_de_la_multa", "true")
        # data["infFaltas"].each do |detalle|
        #     form_data.set("boletas_por_pagar.boletas_instance_#{index}.motivo", detalle["infDescripcionFalta"])
        #     form_data.set("boletas_por_pagar.boletas_instance_#{index}.imposicion", detalle["infTipoImposicion"])
        #     form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_boleta", detalle["infMontoBoleta"])
        #     form_data.set("boletas_por_pagar.boletas_instance_#{index}.monto_desacato", detalle["infMontoDesacato"])
        # end
        faltas = "<table>"
        data["infFaltas"].each do |falta|
            faltas += "<tr><td><strong>Motivo Falta:</strong> </td> <td>#{falta["infDescripcionFalta"]}</td></tr>" 
            faltas += "<tr><th>Imposición: </th> <td>#{falta["infTipoImposicion"]}</td></tr>"
            faltas += "<tr><th>Monto Boleta: </th> <td>#{falta["infMontoBoleta"]}</td></tr>"
            faltas += "<tr><th>Monto Desacato: </th> <td>#{falta["infMontoDesacato"]}</td></tr>"
            faltas += "<tr><th>Monto Total: </th> <td>#{falta["infMontoTotal"]}</td></tr>"
            faltas += "<tr><td><hr></td><td><hr></td></tr>"
        end
        faltas += "</table>"
        form_data.set("boletas_por_pagar.boletas_instance_#{index}.faltas_html", faltas.html_safe)
    end
else
    transition_errors << "Ha ocurrido un error interno estamos trabajando para resolverlo, por favor intente más tarde."
    (1..20).each do |x|
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.boleta","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.placa","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.fecha","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.faltas_html","")
        form_data.set("boletas_por_pagar.boletas_instance_#{x}.faltas_json","")
        # form_data.set("boletas_por_pagar.boletas_instance_#{x}.motivo","")
        # form_data.set("boletas_por_pagar.boletas_instance_#{x}.imposicion","")
        # form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_boleta", "")
        # form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_desacato","")
        # form_data.set("boletas_por_pagar.boletas_instance_#{x}.monto_total","")
    end
    form_data.set("boletas_por_pagar.monto.monto_de_la_multa","0")
    form_data.set("boletas_por_pagar.monto.motivo_de_la_multa", "false")
    form_data.set("boletas_por_pagar.monto.mensaje_notificacion","Usted no tiene multas pendientes. Avance al próximo paso.")
end
multa = form_data.get("boletas_por_pagar.monto.motivo_de_la_multa")
##################################
Rails.logger.info(">>>>>... FIN DEL CICLO >> MULTA >> #{multa} >>>>>>>>")
#::: DV: 08/09/2016: Obtener valor del config :::#
valor = @config.route("Rates-payment-payment-payment")
Rails.logger.info(">>>>>... FIN DEL valor > #{valor} >>>>>>>>")
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
        transition_errors << "Para continuar Usted debe seleccionar al menos una boleta para pagar. Por favor, seleccione la(s) boleta(s) que desea pagar."
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
    Rails.logger.info("recibiendo result pago >>>>>>>>>>>>>>>>>>>> #{result}")

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
  $("#field_boletas_por_pagar_monto_oculto_multa").parents(".field-box").hide();
  var boletasSel = $("#field_boletas_por_pagar_monto_motivo_de_la_multa").val();
  if (boletasSel == 'false'){
    $('#field_boletas_por_pagar_monto_monto_de_la_multa').parents(".field-box").hide();
     $.each( $('[id*=boletas_por_pagar_boletas_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
          pos = (this.id).match(/_instance_[\d]/);
        }
        var InicioRuta  = "#field_boletas_por_pagar_boletas";
        var boleta     = "_boleta";
        var coincide  = InicioRuta.concat(pos);
        var boleta2    = coincide.concat(boleta);
        $(boleta2).parents(".part-box").hide();
        $(boleta2).parents(".part-box").next().hide();
    });
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
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Boletas por Pagar") {  
        $(this).html("Detalles de las Boletas"); 
      }
    });
  });

  $( function() {
    var hint = "Detalles de las Boletas";
      $("div").each (function(){
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

var show_tickets  = $("#boletas_por_pagar .section-body .vertical").children(".dynamic-element-show");
var acum          = 0;
var group_tickets = [];
var auxgp_tickets = [];
var auxgp_amounts = [];
var flagp_tickets = [];

$.fn.hasAttr = function(name) {  
  var attr = this.attr(name)
  return (typeof attr !== typeof undefined && attr !== false);
};

// Check For Repeats

function get_total_amount_by_ticket(ticket)
{
  var acum = 0;

  for (var i = 0; i < auxgp_tickets.length; i++) {
    acum +=  auxgp_tickets[i] === ticket ? auxgp_amounts[i] : 0;
  }

  return acum;
}

function set_checked_by_ticket(ticket, isChecked)
{
  $.each(show_tickets, function(index, item) {
    var body       = $(item).children(".part-body");
    var fields     = $($(body).children(".vertical")).children(".field-box");
    var ticket_num = $(fields[1]).find("input").val();
    var checkboxes = $(fields[0]).find("input");

    if (ticket == ticket_num)
    {
      $(checkboxes[1]).prop("checked", isChecked);
      $(fields[9]).find("textarea").val( isChecked ? "true" : "false");
    }

  });
}

$.each(show_tickets, function(index, item) {

  var body          = $(item).children(".part-body");
  var fields        = $($(body).children(".vertical")).children(".field-box");
  var ticket_num    = $(fields[1]).find("input").val();
  var ticket_amount = parseFloat($(fields[8]).find("input").val());

  if ($.inArray(ticket_num, auxgp_tickets) !== -1 &&
      $.inArray(ticket_num, group_tickets) === -1)
  {
    group_tickets.push(ticket_num);
    flagp_tickets.push(true);
  }
  auxgp_tickets.push(ticket_num);
  auxgp_amounts.push(ticket_amount);
});

// End Check For Repeats

$.each(show_tickets, function(index, item) {
  
  var label      = $(item).children(".label2").find(".panel-title");
  var body       = $(item).children(".part-body");
  var fields     = $($(body).children(".vertical")).children(".field-box");
  var ticket_num = $(fields[1]).find("input").val();
  var ticket_pos = $.inArray(ticket_num, group_tickets);
  var check_hist = $(fields[9]).find("textarea").val();
  var checkboxes = $(fields[0]).find("input");
  var isChecked  = check_hist == "" ? true
                                    : (check_hist == "true" && $(checkboxes[1]).hasAttr("checked"));
  
  var check      = isChecked ? "checked='checked'" : "";
  
  $(checkboxes[1]).addClass("groupHeader");
  //$(checkboxes[1]).removeClass("groupHeader");
  //$(checkboxes[1]).attr('onClick','stopMoving()');
  $(checkboxes[1]).prop("checked", isChecked);

  if (ticket_pos === -1)
  {
    acum = isChecked ? (acum + parseFloat($(fields[8]).find("input").val())) 
                     : acum  + 0;

    var label_str = ""; // <input  type='checkbox' class='groupHeader' " + check +"/> 
    label_str    += "<h5 style='padding:2px;margin:0px;'>Nro. de Boleta: " + ticket_num                       + " </h5> ";
    label_str    += "<h4 style='padding:2px;margin:0px;'>Monto Total:"    + format1(parseFloat($(fields[8]).find("input").val()),"") + "</h4>";
    label.html(label_str);
  } else {
    
    if (flagp_tickets[ticket_pos])
    {
      var total_ticket = get_total_amount_by_ticket(ticket_num);
      acum = isChecked ? acum + total_ticket
                       : acum + 0;

      var label_str = ""; // <input  type='checkbox' class='groupHeader' " + check +"/> 
      label_str    += "<h5 style='padding:2px;margin:0px;'>Nro. de Boleta: <b>" + ticket_num                       + "</b></h5> ";
      label_str    += "<h4 style='padding:2px;margin:0px;'>Monto Total: "    + format1(total_ticket,"") + "</h4>";
      label.html(label_str);

      flagp_tickets[ticket_pos] = false;
    } else {
      label.html("");
      $(fields[0]).css("display","none");
    }
    
  }

  // Set Amount
  $("#field_boletas_por_pagar_monto_oculto_multa").val(acum);
  $("#field_boletas_por_pagar_monto_monto_de_la_multa").html(format1((acum < 0 ? 0 : acum),""));

  //
  $(fields[1]).css("display","none");
  //$(fields[2]).css("display","none");
  //$(fields[3]).css("display","none");
  $(fields[4]).css("display","none");
  $(fields[5]).css("display","none");
  $(fields[6]).css("display","none");
  $(fields[7]).css("display","none");
  $(fields[8]).css("display","none");

});

$(".groupHeader").click(function(event) {
  var item       = $(this).parents(".part-box");
  var body       = $(item).children(".part-body");
  var fields     = $($(body).children(".vertical")).children(".field-box");
  var ticket_num = $(fields[1]).find("input").val();
  var checkboxes = $(fields[0]).find("input");
  var acum       = 0;

  var acum_amount = parseFloat($("#field_boletas_por_pagar_monto_oculto_multa").text());
  var acum_amount = parseFloat($("#field_boletas_por_pagar_monto_monto_de_la_multa").text());
  var amount      = $.inArray(ticket_num, group_tickets) !== -1 ? get_total_amount_by_ticket(ticket_num)
                                                                : parseFloat($(fields[8]).find("input").val());


  $(checkboxes[1]).prop("checked", $(this).is(":checked"));

  if ($.inArray(ticket_num, group_tickets) !== -1)
  {
    set_checked_by_ticket(ticket_num, $(this).is(":checked"));
  }
  

  if ($(this).is(":checked")) {
    acum = roundToTwo(acum_amount + amount);
    $(fields[9]).find("textarea").val("true");
    //$(checkboxes[0]).val("true"); // Este valor no se esta guardando en DB
  } else {
    acum = roundToTwo(acum_amount - amount);
    $(fields[9]).find("textarea").val("false");
    //$(checkboxes[0]).val("false"); // Este valor no se esta guardando en DB
  }

  $("#field_boletas_por_pagar_monto_oculto_multa").val(acum);
  $("#field_boletas_por_pagar_monto_monto_de_la_multa").html("<h3>"+format1((acum < 0 ? 0 : acum),"")+"</h3>"); //VDIAZ - estilo

  build_json_data();
  
});

function roundToTwo(value) {
  return (Math.round(value * 100) / 100);
}

function format1(n, currency) {
    return currency + " " + n.toFixed(2).replace(/./g, function(c, i, a) {
        return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "" + c : c;
    });
}

function format2(n, currency) {
    return currency + " " + n.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
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

      //row['checkbox']       = $(checkboxes[0]).is(":checked");
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


$(document).ready(function(){
  // VDIAZ - cambios de presentación
  // elimina el boton de maximizar    
  $(".panel-control-fullscreen2").remove();
  $(".panel-control-collapse-all").remove();
  $(".section-box").find(".panel-controls2")[0].remove();
  
  
  // cambia estilo de botón pŕoximo
  $('input[value=Próximo]').attr("style", "background: #aeb404; height: 40px; font-size: 16px;text-align: center; border-radius: 10px;");

  var multa = $("#field_boletas_por_pagar_monto_motivo_de_la_multa").val();
  if (multa == 'false'){
     // Modifica el nombre del botón próximo 
  	$('input[value=Próximo]').val("Completar Solicitud");
  } else {
  	  // Modifica el nombre del botón próximo 
  	$('input[value=Próximo]').val("Ver Resumen de Pago");
  }
  
  //obtiene todas las partes de boletas
  var boletas = $('.part-box[id*="boletas_instance_"]');
  
  //colocar check para pagar todos
  //var pagarTodos = '<br> <input type="checkbox" id="check-all" /> <span>Pagar todas las boletas</span> '; 
  var pagarTodos = '<div style="float:right;padding:15px"><h3> <input type="checkbox" id="check-all" /> Pagar todas las boletas</h3></div> '; 
  
  $(pagarTodos).prependTo($('#boletas_por_pagar').children(".section-body"));
  var checkPagar = $("#check-all")
  var multa = $("#field_boletas_por_pagar_monto_motivo_de_la_multa").val();
  if (multa == 'false'){
    $(checkPagar).hide();
    $(checkPagar).parents("h3").hide();
  }
  
  // HANDLER change check-all
  // se usa evento click() ya que fue el que implementaron para gestionar la sumatoria
  $( "#check-all" ).on( "change", function() {
      if ($(this).prop('checked')){    
        $("input[class='checkclone']:checked").click();  
        $("input[class='checkclone']").click();    
      }else{         
        $("input[class='checkclone']:checked").click(); 
      }
  });

  // -----------------------------------------------
  // Inyectar texto en control de minimizar y maximizar
  //    Ocultar todas las partes de boleta
  $(".part-box").find(".ui-icon-minusthick").click();
  //    Mostrar la parte de Total General
  $("#monto").find(".ui-icon-plusthick").click(); 
  //    Eliminar controles de min-max de Total General
  $("#monto").find(".label2").remove()
          
  //    Agregar el texto
  //    Para que se muestre en texto en la misma linea
  $(".part-box").find(".ui-icon-plusthick, .ui-icon-minusthick").attr("style","display: inherit;");
  $(".part-box").find(".ui-icon-plusthick").parent().attr("style","width: inherit;text-decoration: none;background: #a6a9ad;color: #1b1a19;padding: 2px;");
  //    Agregando el texto
  $(".part-box").find(".ui-icon-plusthick").parent().append($("<span> Ver detalle</span>"));
  $(".part-box").find(".ui-icon-minusthick").parent().append($("<span> Ocultar detalle</span>"));
  
  //    Handler para reinyectar cuando cambie el icono del botón  
  $(".panel-control-collapse").on( "click", function() {
     $(this).find(".ui-icon-plusthick, .ui-icon-minusthick").attr("style","display: inherit;");    
     $("<span> Ocultar detalle</span>").appendTo($(this).children(".ui-icon-minusthick").parent());
     $("<span> Ver detalle</span>").appendTo($(this).children(".ui-icon-plusthick").parent());
  });
  // -----------------------------------------------
          
  //Para cada boleta, cambiar presentación en html
  $.each( boletas, function(k, v) {    
    if ($(v).find(".groupHeader").length > 0){
      var panel = $(v).find('.panel-title');    
      var newfieldcheck = $(v).find("input[type='checkbox']").parent().parent().clone();


      $(newfieldcheck).find("input[type='hidden']").remove();
      var newcheck= newfieldcheck.find("input[key='Pagar boleta']");

      $(newfieldcheck).find(".checkbox").attr("style", "font-size: 16px;padding-top:10px;color: #088A08;");    
      $(newcheck).removeClass("groupHeader").addClass("checkclone").attr("name","").attr("key","").attr("id","");

      $(v).find("input[type='checkbox']").parent().parent().hide();

      //se mueve el checkbox
      $(newfieldcheck).appendTo($(panel));


      //se agrega botón de ver detalle
      //var verDetalle = "<a class='opener-dialog' id='"+ $(v).attr('id') +"' style='float: right;background: -webkit-gradient(linear, left top, left bottom, from(#eeeff1), to(#828384));border-radius: 200px;    text-decoration: none;margin-right: 3px;font-weight: bold;font-size: 1.0em;cursor: pointer;padding: .4em 1.4em .3em 1.3em;border: none;color: #3c3a3a;'>Ver Detalle</a><br>";
      //$(".part-box .panel-control-collapse").html($(verDetalle));

      //$(verDetalle).appendTo($(panel));
      }
  });
  
  // Handler para sincronizar checkboxes
  $( ".checkclone" ).on( "change", function() {
      var part = $(this).parent().parent().parent().parent().parent(); 
      $(part).find("input[key='Pagar boleta']").click();
      // Prende o apaga checkall
      if ($('.checkclone:checked').length == $('.checkclone').length){
        $("#check-all").prop("checked",true);
      }else{
        $("#check-all").prop("checked",false);
      }
      
    
  });
  
  //Valida la primera vez si debe marcar el checkall
  //console.log(('.checkclone:checked').length +" - "+ $('.checkclone').length);
  if ($('.checkclone:checked').length == $('.checkclone').length){
    $("#check-all").prop("checked",true);
  }else{
    $("#check-all").prop("checked",false);
  }

  // Cambia estilo al resumen de la boleta        
  $(".part-box .label2").attr("style","background-color: #f1efef;padding-bottom: 15px;");


  var montoGlobal = $("#field_boletas_por_pagar_monto_monto_de_la_multa").html();
  
  $("#field_boletas_por_pagar_monto_monto_de_la_multa").html("<h3>"+montoGlobal+"</h3>");
  
  $(window).scrollTop(0);
  
  //se agrega modal
  /*
  var dialog = '<div id="dialog" title="Detalle de la Boleta"></div>';    
  $(dialog).appendTo($('input[value=PAGAR]').parent());

  //Se inicializa el modal
  $(function() {
    $( "#dialog" ).dialog({
      modal: true,
      width: 650,
      autoOpen: false,
      buttons: {
      Ok: function() {
        $( this ).dialog( "close" );
        }
      },
      show: {
        effect: "blind",
        duration: 500
      },
      hide: {
        effect: "explode",
        duration: 500
      }
    });

    $( ".opener-dialog" ).on( "click", function() {
      var html = $('.part-box[id="'+$(this).attr("id")+'"]').children(".part-body");
      $( "#dialog" ).html(html.show());          
      $( "#dialog" ).dialog( "open" );
    });
    
  });
    
  */
  
});
  

    STEPAJAXCODE
  end
            
