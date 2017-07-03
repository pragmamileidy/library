
  class Paso3DatosDeLaFinca < TemplateCode::Step

    on_becoming do
      


    (1..10).each do |x|
 #////////////////////////////////////// FINCA ///////////////////////////////////////////
 #ESTA INVOCACION VIENE DEL SERVICIO REGISTRO PUBLICO
 nro_finca = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.numero_de_finca")
 cod_ubi = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.cod_ubicacion")
 tipo_p = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.tipo_propiedad")
 tipo_nro = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.numero_de_registro")
 next if (nro_finca.blank? || cod_ubi.blank? || tipo_p.blank?)

  # Carga de tabla de Propietarios de finca
  ####propietarios = WebserviceConsumer.get( '/service/bdin_propietarios_finca/records.json').parsed_response
    if tipo_nro == "Número de Finca"
    propietarios = WebserviceConsumer.get(URI.escape('/service/bdin_propietarios_finca/where.json?finca=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}")).parsed_response
    else
    propietarios = WebserviceConsumer.get(URI.escape('/service/bdin_propietarios_finca/where.json?cedula_catastral=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}")).parsed_response    
    end
  propietarios = propietarios["response"]
  
  _dataPropietarios = { 'config' => {
     "readonly" => "true",
    },
    'data' => propietarios,
    'citizen_selection' => [],
    'agent_selection' => []
  }
  
  _dataPropietarios = ActiveSupport::JSON.encode(_dataPropietarios)
  form_data.set("datos_de_la_finca_instance_#{x}.propietarios.fieldgrid", _dataPropietarios)
  
  
  
  # Carga de tabla de Gravamenes de finca
  ####gravamenes = WebserviceConsumer.get( '/service/bdin_gravamenes_finca/records.json').parsed_response
    if tipo_nro == "Número de Finca"
      gravamenes = WebserviceConsumer.get(URI.escape('/service/bdin_gravamenes_finca/where.json?finca=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}")).parsed_response
    else
      gravamenes = WebserviceConsumer.get(URI.escape('/service/bdin_gravamenes_finca/where.json?cedula_catastral=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}")).parsed_response    
    end
  gravamenes = gravamenes["response"]
  
  _dataGrav = { 'config' => {
     "readonly" => "true",
    },
    'data' => gravamenes,
    'citizen_selection' => [],
    'agent_selection' => []
  }
  
  _dataGrav = ActiveSupport::JSON.encode(_dataGrav)
  form_data.set("datos_de_la_finca_instance_#{x}.gravamenes.fieldgrid", _dataGrav)
end

    end

    on_transition do
      #Validar que ingrese los datos generales de la solicitud si es necesario y esta vacio
#_valor_estimado_de_la_obra = form_data.get("datos_generales_del_proyecto.datos_generales_del_proyecto.valor_estimado_de_la_obra")
#_valor_aproximado_de_las_instalaciones_de_seguridad = form_data.get("datos_generales_del_proyecto.datos_generales_del_proyecto.valor_aproximado_de_las_instalaciones_de_seguridad")

# if 	(_valor_estimado_de_la_obra.to_f > 100000.00)
#	if _valor_aproximado_de_las_instalaciones_de_seguridad.blank?
#		transition_errors << "Debe introducir el Valor aproximado de las instalaciones de seguridad."
#	end
#end

####Para el print
(1..5).each do |x|
    instance_x = "_instance_#{x}"
	_pirmerNombre = form_data.get("datos_del_co_participante#{instance_x}.nombre_completo.primer_nombre")
	_segundoNombre = form_data.get("datos_del_co_participante#{instance_x}.nombre_completo.segundo_nombre")
	_primerApellido = form_data.get("datos_del_co_participante#{instance_x}.nombre_completo.primer_apellido")
	_segundoApellido = form_data.get("datos_del_co_participante#{instance_x}.nombre_completo.segundo_apellido")
	_apellidoCasada = form_data.get("datos_del_co_participante#{instance_x}.nombre_completo.apellido_de_casada")


nombre_completo= "#{_pirmerNombre} "+"#{_segundoNombre} "+"#{_primerApellido} "+"#{_segundoApellido} "+"#{_apellidoCasada}"
form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.nombre_completo", nombre_completo)
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      ///ocultar o mostrar campo otro dependiendo de la selección
	$(document).ready(function(){
	$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().hide();
		$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_uso_de_la_obra").change(function(){
		dato= $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_uso_de_la_obra").find(':selected').val();
			if(dato != 'Otros'){
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").val('');
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().hide();
			}
			else{
  				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").val('');
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().show();
			}
		});
		dato= $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_uso_de_la_obra").find(':selected').val();
		if(dato != 'Otros'){
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").val('');
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().hide();
			}
			else{
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().show();
			}
	  });


			$(document).ready(function(){
			
			$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_valor_estimado_de_la_obra").keyup(function(event) {
				if ( event.which == 13 ) {
					event.preventDefault();
				}
				estimado_de_la_obra = $(this).val();
				newDato1= "";
				for (var i=0;i<estimado_de_la_obra.length;i++){
					if(estimado_de_la_obra[i]>=0 && estimado_de_la_obra[i]<=9){
						if((estimado_de_la_obra.length-2)==i)
							newDato1 =newDato1 +"."
						newDato1 = newDato1+estimado_de_la_obra[i];
					}
				}
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_valor_estimado_de_la_obra").val(newDato1);
				
		
			});
		});
		
		
			
		$(document).ready(function(){
			
			$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_valor_aproximado_de_las_instalaciones_de_seguridad").keyup(function(event) {
				if ( event.which == 13 ) {
					event.preventDefault();
				}
				instalaciones_de_seguridad = $(this).val();
				newDato2= "";
				for (var i=0;i<instalaciones_de_seguridad.length;i++){
					if(instalaciones_de_seguridad[i]>=0 && instalaciones_de_seguridad[i]<=9){
						if((instalaciones_de_seguridad.length-2)==i)
							newDato2 =newDato2 +"."
						newDato2 = newDato2+instalaciones_de_seguridad[i];
					}
				}
				$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_valor_aproximado_de_las_instalaciones_de_seguridad").val(newDato2);
		
			});
		});

$(function() {
$('#id_del_combo_distritos').html("");
$('#id_del_combo_corregimientos').html("");
})


$.each( $('[id*=field_datos_de_la_finca_instance_]'), function(index, campo) {

	//############### LIMPIAR COMBOS ###############
	if ($(campo).attr('id').match(/_datos_de_ubicacion_de_la_finca_distrito_lista/)) { 
		//alert(this.id);
		if ($(campo).val() == ''){
		$(campo).html("");}
	}
	if ($(campo).attr('id').match(/_datos_de_ubicacion_de_la_finca_corregimiento_lista/)) { 
		//alert(this.id);
		if ($(campo).val() == ''){
		$(campo).html("");}
	}	
	//############### LLAMANDO A LAS FUNCIONES DE CARGA PARA DISTRITO Y CORREGIMIENTO###############
	if ($(campo).attr('id').match(/datos_de_ubicacion_de_la_finca_provincia_lista/)) {
		$(campo).attr('onchange', 'distritos(this.value,this.id);')
	}

	//############### CARGAR MODELOS SEGÚN SELECCIÓN DEL MARCA DE EQUIPO ###############
	if ($(campo).attr('id').match(/datos_de_ubicacion_de_la_finca_distrito_lista/)) {
		$(campo).attr('onchange', 'corregimientos(this.value,this.id);')
	}

});
//############### MÉTODO PARA CARGAR DISTRITOS SEGUN LA PROVINCIA SELECCIONADA ############### 
function distritos(provincia,idmarca) {
	//alert(idmarca);
	var pos = idmarca.match(/[\d][\d]/);
	if (pos == null) {
	  pos = idmarca.match(/[\d]/);
	 }
	//alert(pos);
	var mod1 = "#field_datos_de_la_finca_instance_";


	 	params = {
			"service_name":"ws_panama_distritos/where",
			"provincia":provincia
		}
		var mod2 = "_datos_de_ubicacion_de_la_finca_distrito_lista";
 

	var mod3 = mod1.concat(pos);
	var lista_modelo = mod3.concat(mod2);
	//	alert(lista_modelo);
	$.post(
		"/proxy_service/get_service",
		params,
		function(data){			
			var model;
			var html_options = html_options+'<option value=""></option>';
			for (x in data){
				model = data[x];
				html_options = html_options+'<option value="'+model["distrito"] +'">'+model["distrito"] +'</option>';
			}
			$(lista_modelo).html(html_options);
		}
	);
}


//############### MÉTODO PARA CARGAR CORREGIMIENTOS SEGUN DISTRITO SELECCIONADO############### 
function corregimientos(distrito,idmarca) {
	
	var pos = idmarca.match(/[\d][\d]/);
	if (pos == null) {
	  pos = idmarca.match(/[\d]/);
	 }
	//alert(pos);
	var mod1 = "#field_datos_de_la_finca_instance_";


	 	params = {
			"service_name":"ws_panama_corregimientos/where",
			"distrito":distrito
		}
		var mod2 = "_datos_de_ubicacion_de_la_finca_corregimiento_lista";
 

	var mod3 = mod1.concat(pos);
	var lista_modelo = mod3.concat(mod2);
		//alert(lista_modelo);
	$.post(
		"/proxy_service/get_service",
		params,
		function(data){			
			var model;
			var html_options = html_options+'<option value=""></option>';
			for (x in data){
				model = data[x];
				html_options = html_options+'<option value="'+model["corregimiento"] +'">'+model["corregimiento"] +'</option>';
			}
			$(lista_modelo).html(html_options);
		}
	);
}

$(document).ready(function(){
$.each( $('[id*=field_datos_de_la_finca_]'), function(index, campo) {
		
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_datos_de_la_finca";
	var mod2 = "_datos_de_finca_numero_de_finca";
 	var mod3 = mod1.concat(pos);
	var dato = mod3.concat(mod2);

		//alert(dato);
  $(dato).parents(".section-box").next().hide()
  });
 
  
}); 

////////////////LP Ocultar Secciones vacías
	$(document).ready(function(){			
			$.each( $('[id*=datos_de_la_finca_]'), function(index, campo) {
				var pos = (this.id).match(/_instance_[\d][\d]/);
				if (pos == null){
					pos = (this.id).match(/_instance_[\d]/);
				}	
				var productor = "#field_datos_de_la_finca";
				var mod1 = productor.concat(pos)
				var docs = "_datos_de_finca_numero_de_plano_catastral";
				var documento_d = mod1.concat(docs);
						if($(documento_d).val()== ''){
							//$(documento_d).parents(".section-box").hide()
						}
			});
	});

//////////////////Habilitar o deshabilitar campos si están llenos o vacíos FINCA
tarea= $('#field_datos_generales_del_proyecto_datos_generales_del_proyecto_oculto').val();
if(tarea == "true"){
	$(document).ready(function(){			
			$.each( $('[id*=datos_de_la_finca_]'), function(index, campo) {
				var pos = (this.id).match(/_instance_[\d][\d]/);
				if (pos == null){
					pos = (this.id).match(/_instance_[\d]/);
				}	
				var productor = "#field_datos_de_la_finca";
				var mod1 = productor.concat(pos)
				var docs = "_datos_de_finca_folio";
				var docs1 = "_datos_de_finca_tomo";
				var docs2 = "_datos_de_finca_numero_de_plano_catastral";
				
				var folio = mod1.concat(docs);
				var tomo = mod1.concat(docs1);
				var catastro = mod1.concat(docs2);
				
						//if($(folio).val()== ''){
							//$(folio).removeAttr("disabled","disabled");
						//}else{ 
							//$(folio).attr("disabled","disabled");
						//}
						//if($(tomo).val()== ''){
						//	$(tomo).removeAttr("disabled","disabled");
						//}else{ 
						//	$(tomo).attr("disabled","disabled");
						//}
						//if($(catastro).val()== ''){
						//	$(catastro).removeAttr("disabled","disabled");
						//}else{ 
						//	$(catastro).attr("disabled","disabled");
						//}
			});
	});
}		
    STEPAJAXCODE
  end
            
