
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
if form_data.get("boletas_por_pagar.boletas.motivo_de_la_multa") == "true"
    boletas_selec = form_data.get("boletas_por_pagar.boletas.campo_data")
    boletas = boletas_selec.blank? ? nil : ActiveSupport::JSON.decode(boletas_selec)
    if boletas.blank?
        transition_errors << "Para procesar su pago usted debe seleccionar las boletas a cancelar. Por favor, seleccione un valor en la tabla."
    end
end
    
#::: CODIGO PARA INVOCAR EL SERVICIO payment_computing_service :::#
form_id = @task["form"]
monto_total = form_data.get("boletas_por_pagar.boletas.oculto_multa")
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
form_data.set("boletas_por_pagar.boletas.app_id", app_id)
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){ 
   // creo un div que contendrá la tabla de las boletas antes de la parte "boletas"
   $("div#boletas.part-box").before("<div class='dynamic-table' id='dynamic-table' style='margin-top: 30px; margin-left: 24px;'></div>");
   $("#field_boletas_por_pagar_resultado_de_la_consulta_resultado_de_la_consulta").css({'color':'#0F698D','font-size':'1.0em','text-align':'justify','font-weight:':'bold','white-space':'pre-line'});
   $("#field_informacion_licencia_licencia_sertracen_nro_licencia").parents(".section-box").hide();
   var boletasSel = $("#field_boletas_por_pagar_boletas_campo_data").val();
   parteBoletas = $("#field_boletas_por_pagar_boletas_campo_data");
   seccionevaluador = $('#field_datos_del_evaluador_generico_entidad_evaluadora_0_monto_a_pagar');
   $(parteBoletas).parents(".part-box").hide();
   $(seccionevaluador).parents(".section-box").hide();
   if ((boletasSel != '{"data":[]}') && (boletasSel != '')){
     $(parteBoletas).parents(".part-box").show();
     $(seccionevaluador).parents(".section-box").show();
     $("#field_boletas_por_pagar_boletas_motivo_de_la_multa").parents(".field-box").hide();
     monto = JSON.parse(boletasSel)["data"];
     sumaMultas=0;
     for(pos=0; pos < monto.length; pos++){
        sumaMultas += parseFloat(monto[pos]["infMontoTotal"]);
        $("#field_boletas_por_pagar_boletas_monto_de_la_multa").html(sumaMultas);
        $("#field_boletas_por_pagar_boletas_oculto_multa").val(sumaMultas);
     }
   }else{
     $(parteBoletas).parents(".part-box").hide();
     $(seccionevaluador).parents(".section-box").hide();
   }
   
});

//::: DV: 08/09/2016 Mostrar Tabla de Boletas de pago :::/
$(document).ready(function(){
  

  function build_grib(elements, table_name){
    //json_selector = $("#grid-saver").val();
    //json_dat = $("#"+json_selector).val();
    json_dat = $("#field_boletas_por_pagar_boletas_campo_oculto").val();
    json_data = json_dat.toString().replace(/\=>/g,':'); 
    column_names = ['Seleccione','childrens','total_amount','yml_data'];
    grid_data = [];
    models = [
                {name:'Seleccione',index:6,sortable:false,editable:true,edittype:'checkbox', hidden: true, classes: 'cbox',editoptions:{ value:"true:false"}, formatter: "checkbox", formatoptions: {disabled : true}},
                {name:'childrens', index:'childrens', sortable:false, sorttype:"float", hidden: true, summaryTpl: "Sum: {0}", summaryType: "sum"},
                {name:'total_amount', index:'total_amount', sortable:false, sorttype:"float", hidden: true, summaryTpl: "Sum: {0}", summaryType: "sum"},
                {name:'yml_data', index:'yml_data', sortable:false, hidden: true, classes: 'yml_item_data'}
             ];

    if(json_data.length != 0){
      datatype = "jsonstring";
      json_data = JSON.parse(json_data)["response"];
      for(pos=0; pos < json_data.length; pos++){

        row = {};

        row['Seleccione']     = json_data[pos]['Seleccione']          || true;
        row['Nro de Placa']   = json_data[pos]['infNroDePlaca']       || json_data[pos]['Nro de Placa'];
        row['Nro Boleta']     = json_data[pos]['infNroDeBoleta']      || json_data[pos]['Nro Boleta'];
        row['Fecha']          = json_data[pos]['infFechaDeBoleta']    || json_data[pos]['Fecha'];
        row['Motivo']         = json_data[pos]['infDescripcionFalta'] || json_data[pos]['Motivo'];
        row['Imposición']     = json_data[pos]['infTipoImposicion']   || json_data[pos]['Imposición'];
        row['Monto Boleta']   = json_data[pos]['infMontoBoleta']      || json_data[pos]['Monto Boleta'];
        row['Monto Desacato'] = json_data[pos]['infMontoDesacato']    || json_data[pos]['Monto Desacato'];
        row['Monto Total']    = json_data[pos]['infMontoTotal']       || json_data[pos]['Monto Total'];
        row['total_amount']   = parseFloat(json_data[pos]['infMontoTotal'] || json_data[pos]['Monto Total']);
        row['childrens']      = 1;
        row['yml_data']       = "- Nro de Placa: " + row['Nro de Placa']      + "\n" +
                                "  Nro Boleta: " + row['Nro Boleta']          + "\n" +
                                "  Fecha: " + row['Fecha']                    + "\n" +
                                "  Motivo: " + row['Motivo']                  + "\n" +
                                "  Imposición: " + row['Imposición']          + "\n" +
                                "  Monto Boleta: " + row['Monto Boleta']      + "\n" +
                                "  Monto Desacato: " + row['Monto Desacato']  + "\n" +
                                "  Monto Total: " + row['Monto Total']        + "\n";




        grid_data.push(row);

        $.each(grid_data[pos], function(key,value){
          //column_name = key
          if ((key == "infCodigoFalta") || (key == "infNroDocumento") || (key == "infIndicadorRespuesta") || (key == "infEstadoBoleta") || (key == "infTipoDocumento") || (key == "infDetalleRespuesta")){
            delete key;
          }else{
            column_name = key;
          }
          if($.inArray(column_name,column_names) == -1){
            column_names.push(column_name);
            
            if ($.inArray(column_name, new Array("Monto Boleta", "Monto Desacato", "Monto Total")) !== -1) {
              models.push({name:column_name,index:column_name.length,sortable:false,editable:false,edittype:'text', align:'right'}); //, sorttype:"float", summaryTpl: "{0}", summaryType: "sum"
            } else {
              models.push({name:column_name,index:column_name.length,sortable:false,editable:false,edittype:'text'});
            }
            
          }
        });
      }
    }

      /*
      count = {}
      grid_data.forEach(function(row){
        count[row['Nro Boleta']]  = ( count[row['Nro Boleta']] || 0)+1;
      });
      
      grid_data.forEach(function(row){ 
        if(count[row['Nro Boleta']] > 1){
          row['Seleccione'] = 'true';
        }
      });
      */

      if (grid_data.length != 0){
         $("#grid").jqGrid({
            data: grid_data,
            datastr: grid_data,
            datatype: datatype,
            width: 756,
            height: 150,
            rowNum: 800,
            colNames: ['', '', '', '','', '', '', '', '', '', '', ''],
            multiboxonly: true,
            altRows: true,
            colModel: models,
            viewrecords: true,
            autowidth: true,
            caption: table_name,
            editurl: 'clientArray',
            cellsubmit: 'clientArray',
            cellEdit: true,
            grouping:true,
            hidegrid: true,
            /* begin block Add by JUrbano at 25-11-16 */
            groupingView : {
              groupField : ['Nro Boleta'],
              groupColumnShow : [false],
              groupText: [group_count_text("{0}", "{childrens}", "{total_amount}")], 
              groupSummary: [true],
              groupCollapse: true
            },
            onSelectAll: function(rowIds, allChecked) {
              $("input.groupHeader").attr('checked', allChecked);
            },
            /* end block  */
            beforeEditCell:function(rowid,cellname,v,iRow,iCol){
              lastrow = iRow;
              lastcell = iCol;
            }
         });
         // Fix Hide Collapsable button
         $('.tree-wrap-ltr').hide();
      }
  }

  // end build_grib function

   $("#dynamic-table").html("<table id='grid'></table><div id='pager'></div>"); 

   prepareDialog();

   build_grib({}, "Multas pendientes");
   set_selected_rows("field_boletas_por_pagar_boletas_campo_data");
   var boletasSel = $("#field_boletas_por_pagar_boletas_campo_data").val();
   if  ((boletasSel != '{"data":[]}') || (boletasSel != "")){
     $("#field_boletas_por_pagar_boletas_campo_data").parents(".part-box").show();
     $("#field_boletas_por_pagar_boletas_motivo_de_la_multa").parents(".field-box").hide();
     monto = JSON.parse(boletasSel)["data"];
     sumaMultas=0;
     for(pos=0; pos < monto.length; pos++){
        sumaMultas += parseFloat(monto[pos]["Monto Total"]);
        $("#field_boletas_por_pagar_boletas_monto_de_la_multa").html(sumaMultas);
        $("#field_boletas_por_pagar_boletas_oculto_multa").val(sumaMultas);
      }
    }

   // OBTENGO LAS FILAS SELECCIONADAS Y LUEGO LAS SETEO EN EN CAMPO DATA DE ESTA MANERA PUEDO REALIZAR LA SUMA DE LAS BOLETAS SELECCIONADAS
   function set_selected_rows(clean_hidden_field){
      var selected = [];
      rows = $("#grid").getRowData();
      $.each(rows, function(_,value){
         if(value["Seleccione"] == "true"){ // verifica si se seleccionó algun regstro en la tabla
            delete(value["Seleccione"]);
            delete(value["childrens"]);
            delete(value["total_amount"]);
            delete(value["yml_data"]);
            selected.push(value);
         }else{
          $("#field_boletas_por_pagar_boletas_monto_de_la_multa").html("");
          $("#field_boletas_por_pagar_boletas_oculto_multa").val("");
         }
      });
      json_grid_data = JSON.stringify({data:selected}); // trae los registros seleccionados en la tala
      $("#"+clean_hidden_field).html(json_grid_data); // se stea en el campo "data" los registros seleccionados
   }

   // AL MOMENTO DE SELECCIONAR UNA O MAS FILAS DE LA TABLA, LLAMO A LA FUNCION "set_selected_rows" PARA OBTENER LAS FILAS SELECCIONADAS
   // Y REALIZAR SUMA DE LOS MONTOS DE LAS BOLETAS
   $("#grid").on("change", null, function(){

      grid_submit_data = $("#grid").getRowData();
      if (grid_submit_data.length != 0){
         json_grid_data = JSON.stringify({response:grid_submit_data});
         //selector = $("field_boletas_por_pagar_boletas_campo_oculto").val();
         //$("#"+selector).val(json_grid_data);
         $("#field_boletas_por_pagar_boletas_campo_oculto").val(json_grid_data);
      }

      set_selected_rows("field_boletas_por_pagar_boletas_campo_data");

      // REALIZO LA SUMA DE LOS MOTOS SELECCIONADOS
      var boletasSel = $("#field_boletas_por_pagar_boletas_campo_data").val();
      if  ((boletasSel != '{"data":[]}') || (boletasSel != "")){
         $("#field_boletas_por_pagar_boletas_campo_data").parents(".part-box").show();
         $("#field_boletas_por_pagar_boletas_motivo_de_la_multa").parents(".field-box").hide();
         monto = JSON.parse(boletasSel)["data"];
         sumaMultas=0;
         for(pos=0; pos < monto.length; pos++){
          sumaMultas += parseFloat(monto[pos]["Monto Total"]);
          $("#field_boletas_por_pagar_boletas_monto_de_la_multa").html(sumaMultas);
          $("#field_boletas_por_pagar_boletas_oculto_multa").val(sumaMultas);
         }
      }else{
        $("#field_boletas_por_pagar_boletas_campo_data").parents(".part-box").hide();
      }
      // FIN DE LA SUMA

      if  ((boletasSel == '{"data":[]}') || (boletasSel == "")){
        $("#field_boletas_por_pagar_boletas_campo_data").parents(".part-box").hide();
      }

   });
});

/* begin block Add by JUrbano at 25-11-16 */
$(document).ready(function(){
  // table    
  $("#grid tbody").on("change", "input[type=checkbox]", function (e) {    
        
    var currentCB = $(this);
    var grid = $('#grid');
    var isChecked = this.checked;

    if (currentCB.is(".groupHeader")) { //if group header is checked, to check all child checkboxes   
      
      var checkboxes = currentCB.closest('tr').nextUntil('tr.gridghead_0').find('.cbox').find('input[type="checkbox"]');

      checkboxes.each(function(){
        if (!this.checked || !isChecked){
          $(this).prop('checked', isChecked);
        }
      });
    } else {  //when child checkbox is checked
      var allCbs = currentCB.closest('tr').prevAll("tr.gridghead_0:first").nextUntil('tr.gridghead_0').andSelf().find('[type="checkbox"]');
      var allSlaves = allCbs.filter('.cbox').find('input[type="checkbox"]');
      var master = allCbs.filter(".groupHeader");
      var allChecked = !isChecked ? false : allSlaves.filter(":checked").length === allSlaves.length;
      master.prop("checked", allChecked);
    }
  }); 

  group_disableds();
});

 function group_disableds()
 {
   $.each($("#grid tbody input[type=checkbox]").filter(".groupHeader"), function(index, item) {
     var currentCB = $(item);
     if (currentCB.is(".groupHeader"))
     {
      var checkboxes = currentCB.closest('tr').nextUntil('tr.gridghead_0').find('.cbox').find('input[type="checkbox"]');

      currentCB.prop("checked", $(checkboxes[0]).is(":checked"));

      if(checkboxes.length > 1)
      {
        currentCB.prop("checked", true); // mandatorio si tiene mas de una falta al mismo nro de boleta
        currentCB.attr('disabled', true);
      }
     }
    
   });
 }

function group_count_text(nro_boleta, nro_rows, total_amount)
{
  
  return "<input  type='checkbox' class='groupHeader' checked='checked'/>" + 
         "<a href='#!' onclick='jqGridSelected(this);'><strong> Nro. de Boleta:  " + nro_boleta + " - Monto Total: " + total_amount + " </strong></a>";
  
}

function jqGridSelected(element)
{
  var ymls    = $(element).closest('tr').nextUntil('tr.gridghead_0').find('.yml_item_data');
  var str_yml = "";

  ymls.each(function(){
    str_yml += this.textContent
  });
  $("#yml_dialog").val(str_yml);
  $("#dialog").dialog("open");
}

function prepareDialog()
{
  $('<div/>', {
    id: 'dialog',
    title: 'Boleta'
   }).appendTo('#dynamic-table');

  $("#dialog").html("<p>Información de Multas</p> <textarea id='yml_dialog' rows='6' style='width:100%' readonly=''></textarea>");
  $("#dialog").dialog({
    autoOpen : false, 
    modal : true, //show : "blind", hide : "blind", minWidth: 400
  });
}
/* end block  */

$(document).ready(function(){  
  $( function() {
    $("div").each (function(){
      if ($(this).html().trim() == "Sección: Boletas por Pagar") {  
        $(this).html("Boletas por Pagar"); 
      }
    });
  });

  $( function() {
    var hint = "Boletas por Pagar";
    $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    var hint = "Información de Boletas por pagar en la ATTT";
      $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })

  $( function() {
    var hint = "Información de multas por pagar en la ATTT";
      $("div").each (function(){
      if ($(this).html().trim() == hint) {  
        $(this).html(hint).css({'color':'#0F698D','font-weight':'bold'}); 
      }
    });
  })
});
    STEPAJAXCODE
  end
            
