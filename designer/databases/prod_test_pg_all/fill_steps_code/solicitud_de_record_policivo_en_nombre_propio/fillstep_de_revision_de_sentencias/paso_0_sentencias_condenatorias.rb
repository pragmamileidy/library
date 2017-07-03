
  class Paso0SentenciasCondenatorias < TemplateCode::Step

    on_becoming do
      #::: INICIALIZAR LOS DATOS DEL AGENTE :::#
_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]
form_data.set("recibido_sentencias.datos_del_funcionario_generico.usuario", _agente["name"])

#::: MOSTRAR MENSAJE SENTENCIAS :::#
dato3 = "Para aplicar la ley 14, desmarque las sentencias que desee exonerar"
form_data.set("mensaje_dij.mensaje_dij.mensaje_sentencia",dato3)

#::: OBTENER PROVINCIA DE REVISION DE LA SOLICITUD EN ATTACHMENT :::#
#_app_id = @application["id"]
#result = WebserviceConsumer.get('/service/dij_helper_nombre_propio/call.json?method=provincia_print_design&app_id=' + "#{_app_id}").parsed_response
#provincia = result["response"]["provincia"]
#form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia", provincia)
    end

    on_transition do
      #::: USADO PARA MOSTRAR O NO LA TABLA DE SENTENCIAS DEPENDIENDO SI EXONERAN O NO LAS SENTENCIAS EN EL PRINT DESIGNER :::#
tipo_persona_juridico = form_data.get("tipo_de_persona_dij.tipo_de_solicitante_juridico.tipo_de_solicitante_juridico")
tipo_solicitud = form_data.get("tipo_de_solicitud_dij.tipo_de_solicitud_dij.tipo_de_solicitud_dij")
sentencias_seleccionadas = form_data.get("mensaje_dij.mensaje_dij.campo_data")
sentencias = sentencias_seleccionadas.blank? ? nil : ActiveSupport::JSON.decode(sentencias_seleccionadas)

####LP Validar si revisó la tabla y verificó las sentencias
if sentencias.blank?
		transition_errors << "No es posible continuar, usted debe ver la tabla y aprobar las sentencias antes de enviar el formulario, por favor realice la verificación."
end

if !sentencias.blank?
	if tipo_persona_juridico == "Autoridades"
		if sentencias["data"].blank?
			#::: NO HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA JURIDICA SEA AUTORIDADES :::#
			imprimir_sin_sentencia_a = "Si"
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_a)
		else
			#::: SI HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA JURIDICA SEA AUTORIDADES :::#
			imprimir_sin_sentencia_a =" "
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_a)
		end
	end
	if tipo_persona_juridico == "MINREX"
		if sentencias["data"].blank?
			#::: NO HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA JURIDICA SEA MINREX :::#
			imprimir_sin_sentencia_m = "Si"
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_m)
		else
			#::: SI HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA JURIDICA SEA MINREX :::#
			imprimir_sin_sentencia_m =" "
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_m)
		end
	end
	if (tipo_solicitud == "Laboral") && (tipo_persona_juridico !="Autoridades" && tipo_persona_juridico !="MINREX")
		if sentencias["data"].blank?
			#::: NO HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA PROPIO Y TIPO DE SOLICITUD SEA LABORAL :::#
			imprimir_sin_sentencia_t = "Si"
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_t)
		else
			#::: SI HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA PROPIO Y TIPO DE SOLICITUD SEA LABORAL :::#
			imprimir_sin_sentencia_t =" "
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_t)
		end
	end
	if (tipo_solicitud == "Migración") && (tipo_persona_juridico !="Autoridades" && tipo_persona_juridico !="MINREX")
		if sentencias["data"].blank?
			#::: NO HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA PROPIO Y TIPO DE SOLICITUD SEA MIGRATORIA :::#
			imprimir_sin_sentencia_mi = "Si"
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_mi)
		else
			#::: SI HAY SENTENCIAS EN EL CAMPO Y TIPO DE PERSONA PROPIO Y TIPO DE SOLICITUD SEA MIGRATORIA :::#
			imprimir_sin_sentencia_mi =" "
			form_data.set("mensaje_dij.mensaje_dij.imprimir_sin_sentencia",imprimir_sin_sentencia_mi)
		end
	end
end
#::: GENERAR CÓDIGO UNICO Y DATOS PARA IMPRESIÓN :::#
codigo = form_data.get("codigo_unico_dij.codigo_unico_dij.dia")

#::: GENERAR FECHA PARA IMPRESION :::#
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])

anno = Time.now.year
mes = I18n.t("views.calendar.#{Time.now.strftime("%B").downcase}")
dia = Time.now.day
form_data.set("codigo_unico_dij.codigo_unico_dij.year",anno)
form_data.set("codigo_unico_dij.codigo_unico_dij.mes",mes)
form_data.set("codigo_unico_dij.codigo_unico_dij.dia",dia)

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      /::: Mostrar Tabla de Sentencias :::/

$(document).ready(function(){
  function build_grib(elements, max_instances, table_name){
    json_selector = $("#grid-saver").val();
    json_data = $("#"+json_selector).html();
    column_names = ['Seleccione'];
    grid_data = [];
    models = [{name:'Seleccione',index:4,sortable:false,editable:true,edittype:'checkbox',editoptions:{ value:"true:false"}, formatter: "checkbox", formatoptions: {disabled : false} }];
    if(json_data.length != 0){
      datatype = "jsonstring";
      grid_data = JSON.parse(json_data)["data"];
      for(pos=0; pos < grid_data.length; pos++){
        $.each(grid_data[pos], function(key,value){
          column_name = key
          if($.inArray(column_name,column_names) == -1){
            column_names.push(column_name);
            models.push({name:column_name,index:column_name.length,sortable:false,editable:false,edittype:'text'});
          }
        });
      }
    }else{
    column = {'Seleccione':'true'};
    ids = [];
    datatype = "local";
    for (i=1; i <= max_instances; i++){
      for (pos=0; pos < elements.length; pos++){
        for(pos2=0; pos2 < elements[pos].length; pos2++){
          column_name = elements[pos][pos2]["column_name"]
          if(typeof elements[pos][pos2]["column_value"] == "undefined"){
            column_value = "";
            selector = elements[pos][pos2]["field_id"].replace("instance_","instance_"+i);
            if (selector.search(/[\[\]]/) != -1){
              nodo = $("[name='"+selector+"']:checked");
              if (nodo.length > 0){
                column_value = nodo.val();
              }
            }else{
              column_value = $("#"+selector).val();
            }
          }else{
            column_value = elements[pos][pos2]["column_value"];
            selector = elements[pos][pos2]["field_id"];
          }
          if(column_name.length != 0){
            if ($.isEmptyObject(column[column_name])){
              column[column_name] = column_value;
            }
            ids.push(selector);
            if($.inArray(column_name,column_names) == -1){
              column_names.push(column_name);
              models.push({name:column_name,index:column_name.length,sortable:false,editable:elements[pos][pos2]["editable"],edittype:'text'});
            }
          }
        }
        if(! $.isEmptyObject(column)){
          grid_data.push(column);
        }
        column = {'Seleccione':'true'};
      }
    }
    }
    if (grid_data.length != 0){
      $("#grid").jqGrid({
      data: grid_data,
      datastr: grid_data,
      datatype: datatype,
      height: 150,
      rowNum: 800,
      colNames: column_names,
      multiboxonly: true,
      altRows: true,
      colModel: models,
        viewrecords: true,
        caption: table_name,
        editurl: 'clientArray',
        cellsubmit: 'clientArray',
        cellEdit: true,
        beforeEditCell:function(rowid,cellname,v,iRow,iCol){
          lastrow = iRow;
          lastcell = iCol;
        }
      });

    }else{
      $("#pager").html("Disculpe, no existen datos para mostrar");
    }
  }

  function set_selected_rows(clean_hidden_field){
    //alert('me estoy ejecutando');
    var selected = [];
    rows = $("#grid").getRowData();
    $.each(rows, function(_,value){
      if(value["Seleccione"] == "true"){
        delete(value["Seleccione"]);
        selected.push(value);
      }
    });
    json_grid_data = JSON.stringify({data:selected});
    $("#"+clean_hidden_field).html(json_grid_data);
  }

  function show_table(elements, max_instances, table_name, nodo_route, submit){
    route = nodo_route.split(".");
    switch(route.length){
      case 1:
        $("div#"+route[0]+".section-box").after("<div class='dynamic-table'><a href='#' class='show-dinamic-table'><img class='table-ico' src='/assets/table.png'/>Ver en Tabla</a></div>");
        break;
      case 2:
        $("div#"+route[0]+".section-box").find("div#"+route[1]+".part-box").after("<div class='dynamic-table'><a href='#' class='show-dinamic-table'><img class='table-ico' src='/assets/table.png'/>Ver en Tabla</a></div>");
        break;
      case 3:
        $("div#"+route[0]+".section-box").find("div#"+route[1]+".part-box").find("#"+route[2]).after("<div class='dynamic-table'><a href='#' class='show-dinamic-table'><img class='table-ico' src='/assets/table.png'/>Ver en Tabla</a></div>");
        break;
    }
    $(".dynamic-table").click(function() {
      $( "#dynamic-table" ).dialog("open");
    });
    $("#grid-saver").val(submit);
    $(".show-dinamic-table").on("click", null, function(){
      build_grib(elements, max_instances, table_name);
    });
  }

  $( "#dynamic-table" ).dialog({
    autoOpen: false,
    show: "blind",
    hide: "explode",
    modal: true,
    height: 'auto',
    width: 'auto',
    buttons: {
      Ok: function() {
        if(typeof(lastrow) != "undefined" && typeof(lastcell) != "undefined"){
          $("#grid").jqGrid("saveCell",lastrow,lastcell);
        }
        grid_submit_data = $("#grid").getRowData();
        if (grid_submit_data.length != 0){
          json_grid_data = JSON.stringify({data:grid_submit_data});
          selector = $("#grid-saver").val();
          $("#"+selector).html(json_grid_data);
        }
        set_selected_rows("field_mensaje_dij_mensaje_dij_campo_data");
        $("#dynamic-table").html("<table id='grid'></table><div id='pager'></div>");
          $( this ).dialog( "close" );
      }
    }
  });

  show_table( {}, 1, "Sentencias", "mensaje_dij", "field_mensaje_dij_mensaje_dij_campo_oculto");
});

//::: DV: Cambiar nombre sección y color  paso 1::://
$(document).ready(function(){ 
   $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Tipo de Solicitud") {  
        $(this).html("Tipo de Solicitud"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Solicitante") {  
        $(this).html("Gestión de Solicitud"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Datos del Titular") {  
        $(this).html("Información del Titular"); 
      }
    });
  });

  $( function() {
    $("span").each (function(){
      if ($(this).html().trim() == "Sección: Recepción Ventanilla Única") {  
        $(this).html("Recepción de Ventanilla Única"); 
      }
    });
  });
});

$(document).ready(function(){ 
  TiDoc = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_tipo_de_documento');
  nacio = $('#field_datos_del_titular_rp_datos_basicos_de_persona_natural_nacionalidad');
  if ($(TiDoc).html() == "Cedula") {
    $(nacio).html("Nacional");
  } else if($(TiDoc).html() == "Pasaporte") {
    $(nacio).html("Extranjero");
  }
});
    STEPAJAXCODE
  end
            
