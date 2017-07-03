
  class Paso2DatosDeLosTitulares < TemplateCode::Step

    on_becoming do
      #Este código fuera del  ciclo:
########Fecha Impresion##############
#form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"]) ##no la colocas
 
### COMENTADO POR PRUEBAS 17/10/2014
#director = @config.route("Config P6.defaults100.rolname_id.nombre_director", ".")
#form_data.set("director_dij.datos_del_funcionario_generico.usuario", director)

#_director= @config.route("Config P6.defaults100.rolname_id.nombre_director", ".")
#form_data.set("director_dij.datos_del_funcionario_generico.usuario2", _director)
    end

    on_transition do
      #::: DV: Código de calculo de fechas y edad modificado el 12/12/2016 :::#
require 'date'
_titular = form_data.get("tipo_de_persona_dij.es_titular_o_no.si_no")
if _titular == "SÍ"
	fechaho = Date.today.to_s
	fecha_nac = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.fecha_de_nacimiento").to_s
	fechanac = Date.parse(fecha_nac).strftime("%d/%m/%Y")
	fecha_hoy = Date.parse(fechaho).strftime("%d/%m/%Y")
	
	#::: DV: Calcular edad dada la fecha de nacimiento y la fecha actual :::#
	edad = ((Date.parse(fecha_hoy) - Date.parse(fechanac)).to_i/365)
	if (edad.to_i < 18.to_i)
	 	transition_errors << "La edad del Titular no debe ser menor a 18 años de edad. Por favor, verifique"
	end
	form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.edad",edad)
else
	(1..20).each do |x|
		fecha_i = form_data.get("datos_del_titular_rp_instance_#{x}.datos_basicos_de_persona_natural.fecha_de_nacimiento").to_s
		next if fecha_i.blank?
		fechaho_i = Date.today.to_s
		fecha_na_i = Date.parse(fecha_i).strftime("%d/%m/%Y")
		fecha_hoy_i = Date.parse(fechaho_i).strftime("%d/%m/%Y")

		#::: DV: Calcular edad dada la fecha de nacimiento y la fecha actual :::#
		edad_i = ((Date.parse(fecha_hoy_i) - Date.parse(fecha_na_i)).to_i/365)
		if (edad_i.to_i < 18.to_i)
			transition_errors << "La edad del Titular #{x} no debe ser menor a 18 años de edad. Por favor, verifique"
		end
		form_data.set("datos_del_titular_rp_instance_#{x}.datos_basicos_de_persona_natural.edad",edad_i)
	end
end

#::: DV: AGREGADO 21/01/2016 :::#
#:::: SI EL TITULAR NO EXISTE EN LA DIJ Y NO ES EL owner, obtiene el nombre si el mismo viene vacio :::::#
(1..20).each do |_num|
	primerNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre")
	segundoNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre")
	primerApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido")
	segundoApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido")
	apellidoCasada = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada")
	nombreCompleto = "#{primerNombre} #{segundoNombre} #{primerApellido} #{segundoApellido} #{apellidoCasada}"
	form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.nombre_completo",nombreCompleto.squish)
end

#::::::::::::::DV: Integración guardar nro de documento Datos de los Titulares::::::::::::::#
_titular = form_data.get("tipo_de_persona_dij.es_titular_o_no.si_no")
if _titular == "SÍ"
	nro_doc_t = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte")
	form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.doc_oculto",nro_doc_t)	
else 
	(1..20).each do |_num|
		nro_doc_d = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte")
		form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.doc_oculto",nro_doc_d)
	end	
end

tipo_documento = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_documento")
if tipo_documento == "Cedula"
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_nacionalidad","Nacional")
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //#::: DV: Al seleccionar que no se tiene version en fisico deshabilitar firma del director :::#//
$(document).ready(function(){
	function ocultar(){
		var valor1 = $('input[name="[field][retiro_record_policivo_retiro_record_policivo_version_fisico]"]:checked').val();
		if(valor1 == "NO" || valor1 == undefined){
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").parent().parent().hide();
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_record_policivo").parent().parent().hide();
			$("#field_retiro_record_policivo_firma_director_si_no").parent().parent().parent().parent().parent().hide();
		}
		$(function() {
			$("input:radio").click(function(){
			check7(this);
	});
});

//AV: FUNCION ALERT SI NO SELECCIONA OPCIONES CUANDO REQUERIERE VERSIÓN EN FISICO
function check007(obj){
	if($("input[name='[field][retiro_record_policivo_retiro_record_policivo_version_fisico]']:radio:checked" ).val()[0]=='S' && 
		$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").val().length == 0 &&
		$("#field_retiro_record_policivo_firma_director_si_no").val().length == 0 ){
		alert("Los Campos, Indicar por quién será retirado el Récord Policivo y Firma del Director deben ser llenados");
		return false;
	}

	if($("input[name='[field][retiro_record_policivo_retiro_record_policivo_version_fisico]']:radio:checked" ).val()[0]=='S' && 
		$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").val().length == 0 &&
		$("#field_retiro_record_policivo_firma_director_si_no").val().length > 0 ){
		alert("Indicar por quién será retirado el Récord Policivo debe ser llenado");
		return false;
	}

	if($("input[name='[field][retiro_record_policivo_retiro_record_policivo_version_fisico]']:radio:checked" ).val()[0]=='S' && 
		$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").val().length > 0 &&
		$("#field_retiro_record_policivo_firma_director_si_no").val().length == 0 ){
		alert("Firma del Director debe ser llenado");
		return false;
	}
		return true;
	}

	$("input[id='Paso 3 - Adjuntar archivos']").click(function(){
		return check007(this);
	});

	$("input[value='Guardar y Cerrar']").click(function(){
		return check007(this);
	});

	$("input[value='Guardar']").click(function(){
		return check007(this);
	});

	function check7(obj){
		if (obj.value == "SÍ" && obj.name=="[field][retiro_record_policivo_retiro_record_policivo_version_fisico]"){
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").parent().parent().show();
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_record_policivo").parent().parent().show();
			$("#field_retiro_record_policivo_firma_director_si_no").parent().parent().parent().parent().parent().show();  
		} 
		if (obj.value == "NO" && obj.name=="[field][retiro_record_policivo_retiro_record_policivo_version_fisico]"){
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").parent().parent().hide();
			$("#field_retiro_record_policivo_retiro_record_policivo_retiro_record_policivo").parent().parent().hide();
			$("#field_retiro_record_policivo_firma_director_si_no").parent().parent().parent().parent().parent().hide(); 
		}
	}	
	}
	ocultar();
});

//#::: DV: TIPO PASAPORTE = EXTRANJERO :::#//
$(document).ready(function(){
    //:::::::::::::Habilitar Campos Cuando el Tipo de Documento sea Pasaporte en CO-PARTICIPANTE ::::::::::::::::://
	$.each( $('[id*=datos_del_titular_rp_]'), function titular(index, campo) {       
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
		pos = (this.id).match(/_instance_[\d]/);
		}   
		var InicioRuta  = "#field_datos_del_titular_rp";
		var tipoDoc     = "_datos_basicos_de_persona_natural_tipo_de_documento";
		var tipoNac   	= "_datos_basicos_de_persona_natural_tipo_de_nacionalidad";
		var nacio    	= "_datos_basicos_de_persona_natural_nacionalidad";
		var doc  		= "_datos_basicos_de_persona_natural_cedula_pasaporte";
		var nom1 		= "_datos_basicos_de_persona_natural_primer_nombre";
		var nom2 		= "_datos_basicos_de_persona_natural_segundo_nombre";
		var ape1 		= "_datos_basicos_de_persona_natural_primer_apellido";
		var ape2 		= "_datos_basicos_de_persona_natural_segundo_apellido";
		var apec 		= "_datos_basicos_de_persona_natural_apellido_de_casada";
		var fec  		= "_datos_basicos_de_persona_natural_fecha_de_nacimiento";
		var direccion 	= "_datos_de_ubicacion_direccion";
		var telefono 	= "_datos_de_ubicacion_numero_de_telefono";
		var correo 		= "_datos_de_ubicacion_correo_electronico";
		var coincide    = InicioRuta.concat(pos);
		var doc2 		= coincide.concat(doc);
		var tipoDoc2    = coincide.concat(tipoDoc);
		var tipoNac2  	= coincide.concat(tipoNac);
		var nacio2   	= coincide.concat(nacio);
		var nombre1_d 	= coincide.concat(nom1);
		var nombre2_d 	= coincide.concat(nom2);
		var apellido1_d = coincide.concat(ape1);
		var apellido2_d = coincide.concat(ape2);
		var apellidocas = coincide.concat(apec);
		var fecha_naci 	= coincide.concat(fec);
		var direcc 		= coincide.concat(direccion);
		var telef 		= coincide.concat(telefono);
		var email 		=  coincide.concat(correo);
		var inicio 		= "input[name='[field][datos_del_titular_rp";
		var fin 		= "_datos_basicos_de_persona_natural_sexo]']";
		var coincide 	= inicio.concat(pos);
		var sex 		= coincide.concat(fin);

		$(tipoNac2).parent().parent().hide();
		$(nacio2).parent().parent().hide();

		if ($(tipoDoc2).html() == ''){
            $(tipoDoc2).parents(".section-box").hide();
        }else{
            $(tipoDoc2).parents(".section-box").show();
        }
        
		if ($(tipoDoc2).html() == "Cedula") {
			$(nacio2).parent().parent().hide();
			$(tipoNac2).parent().parent().show();
			$(tipoNac2).val("Nacional");
			$(tipoNac2).attr("disabled","disabled");
		} else if($(tipoDoc2).html() == "Pasaporte") {
			$(nacio2).parent().parent().show();
			$(tipoNac2).parent().parent().hide();
			$(nacio2).html("Extranjero");
		}

		if($(tipoDoc2).html() == "Pasaporte") {
			$(nombre1_d).removeAttr("disabled");
			$(nombre2_d).removeAttr("disabled");
			$(apellido1_d).removeAttr("disabled");
			$(apellido2_d).removeAttr("disabled");
			$(apellidocas).removeAttr("disabled");
			$(fecha_naci).removeAttr("disabled");
			$(direcc).removeAttr("disabled");
			$(telef).removeAttr("disabled");
			$(email).removeAttr("disabled");
			if (!sex.checked) {
				$(sex).removeAttr("disabled");
			}
		}
		if($(direcc).val() == ''){
			$(direcc).removeAttr("disabled");
		}
		if($(telef).val() == ''){
			$(telef).removeAttr("disabled");
		}
		if($(email).val() == ''){
			$(email).removeAttr("disabled");
		}
		if($(doc).html() == ''){
			$(doc).parents(".section-box").hide();
		}else{
			$(doc).parents(".section-box").show();
		}
	//#::: OCULTAR BOTONES AGREGAR/ELIMINAR :::#//
	$(doc2).parents(".section-box").next().hide();
	});
});

//#::: CALCULAR EDAD :::#//
$(document).ready(function(){
	$.each( $('[id*=datos_del_titular_rp_]'), function(index, campo) {	
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		var iniciorut 	= "#field_datos_del_titular_rp";
		var fecha 		= "_datos_basicos_de_persona_natural_fecha_de_nacimiento";
		var edad 		= "_datos_basicos_de_persona_natural_edad";
		var coincide 	= iniciorut.concat(pos);
		var Fnac 		= coincide.concat(fecha);
		var Edad1 		= coincide.concat(edad);

		$(Fnac).change(function(){
			var fecha1  = $(Fnac).val();
			var values 	= fecha1.split("-");
			var dia    	= values[0];
			var mes    	= values[1];
			var ano    	= values[2];

			//::: OBTENER LOS VALORES ACTUALES ::://
			var fecha_hoy = new Date();
			var ahora_ano = fecha_hoy.getYear();
			var ahora_mes = fecha_hoy.getMonth();
			var ahora_dia = fecha_hoy.getDate();
			//::: REALIZAR EL CALCULO ::://
			var edad2 = (ahora_ano + 1900) - ano;
			if ( ahora_mes < (mes - 1)){
				edad2--;
			}
			if (((mes - 1) == ahora_mes) && (ahora_dia < dia)){
				edad2--;
			}
			if (((mes) == ahora_mes) && (ahora_dia < dia)){
				edad2--;
			}
			if (edad2 > 1900){
				edad2 -= 1900;
			}
			$(Edad1).val(edad2);
		});
	});
});

//::::: DV: BLANQUEAR CAMPOS SI EL NRO DE DOCUMENTO GUARDADO NO COINCIDE...//
$.each( $('[id*=datos_del_titular_rp_]'), function(index, campo) {
    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
        pos = (this.id).match(/_instance_[\d]/);
    }
 
	var titular 	= "#field_datos_del_titular_rp";
	var coincidet 	= titular.concat(pos);
	var tiponaci 	= "_datos_basicos_de_persona_natural_tipo_de_nacionalidad";
	var psp 		= "_datos_basicos_de_persona_natural_campo_psp";
	var data 		= "_datos_basicos_de_persona_natural_campo_data";
	var nom1 		= "_datos_basicos_de_persona_natural_primer_nombre";
	var nom2 		= "_datos_basicos_de_persona_natural_segundo_nombre";
	var ape1 		= "_datos_basicos_de_persona_natural_primer_apellido";
	var ape2 		= "_datos_basicos_de_persona_natural_segundo_apellido";
	var edad 		= "_datos_basicos_de_persona_natural_edad";
	var fecha 		= "_datos_basicos_de_persona_natural_fecha_de_nacimiento";
	var pais 		= "_datos_de_ubicacion_pais";
	var direc 		= "_datos_de_ubicacion_direccion";
	var telefono 	= "_datos_de_ubicacion_numero_de_telefono";
	var correo 		= "_datos_de_ubicacion_correo_electronico";
	var nom1dp 		= "_datos_del_padre_primer_nombre";
	var nom2dp 		= "_datos_del_padre_segundo_nombre";  
	var ape1dp 		= "_datos_del_padre_primer_apellido";  
	var ape2dp 		= "_datos_del_padre_segundo_apellido";
	var nom1dm 		= "_datos_de_la_madre_primer_nombre";   
	var nom2dm 		= "_datos_de_la_madre_segundo_nombre";   
	var ape1dm 		= "_datos_de_la_madre_primer_apellido";   
	var ape2dm 		= "_datos_de_la_madre_segundo_apellido";   
	var doc 		= "_datos_basicos_de_persona_natural_cedula_pasaporte";
	var doc_c  		= "_datos_basicos_de_persona_natural_doc_oculto";
	var TipoDoc 	= "_datos_basicos_de_persona_natural_tipo_de_documento";
	var civil		= "_datos_basicos_de_persona_natural_estado_civil";
	var anexo1		= "_copia_de_la_pagina_principal_del_pasaporte_anexo";
	var anexo2		= "_copia_del_carnet_de_permiso_de_trabajo_temporal_o_indefinido_vigente_expedido_por_mitradel_anexo";
	var anexo3		= "_autorizacion_del_titular_para_solicitud_del_record_policivo_anexo";
	var anexo4		= "_cedula_de_identidad_personal_anexo";
	var tipo_doc2 	= coincidet.concat(TipoDoc);
	var docOculto 	= coincidet.concat(doc_c);
	var doc2 		= coincidet.concat(doc);
	var tipodena 	= coincidet.concat(tiponaci);
	var camdata 	= coincidet.concat(data);
	var pspfinal 	= coincidet.concat(psp);
	var nombre1_d 	= coincidet.concat(nom1);
	var nombre2_d 	= coincidet.concat(nom2);
	var apellido1_d = coincidet.concat(ape1);
	var apellido2_d = coincidet.concat(ape2);
	var edad1 		= coincidet.concat(edad);
	var fecha1 		= coincidet.concat(fecha); 
	var pais1 		= coincidet.concat(pais);
	var direc1 		= coincidet.concat(direc);
	var telefono1 	= coincidet.concat(telefono);
	var correo1 	= coincidet.concat(correo);    
	var nom1dp1 	= coincidet.concat(nom1dp);
	var nom2dp1 	= coincidet.concat(nom2dp);  
	var ape1dp1 	= coincidet.concat(ape1dp);  
	var ape2dp1 	= coincidet.concat(ape2dp);
	var nom1dm1 	= coincidet.concat(nom1dm);  
	var nom2dm1 	= coincidet.concat(nom2dm);   
	var ape1dm1 	= coincidet.concat(ape1dm);   
	var ape2dm1 	= coincidet.concat(ape2dm);
	var civil2 	 	= coincidet.concat(civil);
	var anexo1_1 	= coincidet.concat(anexo1);
	var anexo2_2 	= coincidet.concat(anexo2);
	var anexo3_3 	= coincidet.concat(anexo3);
	var anexo4_4 	= coincidet.concat(anexo4);

	$(docOculto).parents(".field-box").hide();
	if($(tipo_doc2).html() == "Pasaporte" && $(docOculto).val() != '' && $(doc2).html() != $(docOculto).val()){
		$(nombre1_d).val('');
		$(nombre2_d).val('');
		$(apellido1_d).val('');
		$(apellido2_d).val('');
		$(edad1).val('');
		$(fecha1).val('');  
		$(pais1).val('');
		$(direc1).val('');
		$(telefono1).val(''); 
		$(correo1).val('');   
		$(nom1dp1).val(''); 
		$(nom2dp1).val(''); 
		$(ape1dp1).val('');   
		$(ape2dp1).val(''); 
		$(nom1dm1).val('');   
		$(nom2dm1).val('');   
		$(ape1dm1).val('');   
		$(ape2dm1).val('');
		$(civil2).val('');
		$(anexo1_1).val('');   
		$(anexo2_2).val('');
		$(anexo3_3).val('');
		$(':input[value*="Femenino"]').prop('checked', false);
		$(':input[value*="Masculino"]').prop('checked', false);
	}
	if($(tipo_doc2).html() == "Cedula"  && $(docOculto).val() != '' && $(doc2).html() != $(docOculto).val()){
		$(civil2).val('');
		$(pais1).val('');
		$(telefono1).val(''); 
		$(correo1).val('');
		$(anexo4_4).val('');
		$(telefono1).removeAttr("disabled"); 
		$(correo1).removeAttr("disabled");
	}   
});
    STEPAJAXCODE
  end
            
