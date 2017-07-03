
  class Paso5ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      _numeroPlano = form_data.get("datos_generales_del_proyecto.categoria_del_proyecto.numero_de_plano")
form_data.set("asignacion_de_entidades.datos_especificados_por_el_analista.no_de_plano_asignado", _numeroPlano)

_categoria = form_data.get("datos_generales_del_proyecto.categoria_del_proyecto.categoria_del_proyecto")
form_data.set("asignacion_de_entidades.datos_especificados_por_el_analista.categoria_del_proyecto", _categoria)
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
(1..15).each do |x|
	anexo_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.plano_de_arquitectura")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.anexo_oculto",anexo_1)

	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.plano_de_estructura")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.anexo_oculto",anexo_2)
	
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.plano_de_electricidad")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.anexo_oculto",anexo_3)
	
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_4 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.plano_de_plomeria")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.anexo_oculto",anexo_4)

	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	
	anexo_5 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.memoria_tecnica_por_especialidad_del_proyecto")
	form_data.set("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.anexo_oculto",anexo_5)

	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_6 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.certificado_de_registro_publico")
	form_data.set("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.anexo_oculto",anexo_6)
	
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_7 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.aprobacion_del_miviot")
	form_data.set("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.anexo_oculto",anexo_7)

	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_8 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.certificacion_del_ingeniero_disenador")
	form_data.set("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.anexo_oculto",anexo_8)
											
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_9 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.escritura_o_contrato_de_arrendamiento")
	form_data.set("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.anexo_oculto",anexo_9)

	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_10 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.nota_de_autorizacion_del_profesional_original")
	form_data.set("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.anexo_oculto",anexo_10)
	
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	anexo_10 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.anexos_adicionales_del_solicitante")
	form_data.set("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.anexo_oculto",anexo_10)
end
    end

    on_transition do
      fecha = Time.now
(1..15).each do |x|
	fecha_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.fecha")
	anexo_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.plano_de_arquitectura")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.adjunto_oculto",anexo_1)
	adjunto_oculto_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.adjunto_oculto")
	anexo_oculto_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.anexo_oculto")
	if ((anexo_1 != "") && (fecha_1 == "") || (adjunto_oculto_1 != anexo_oculto_1))
		form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	fecha_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.fecha")
	anexo_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.plano_de_estructura")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.adjunto_oculto",anexo_2)
	adjunto_oculto_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.adjunto_oculto")
	anexo_oculto_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.anexo_oculto")
	if ((anexo_2 != "") && (fecha_2 == "") || (adjunto_oculto_2 != anexo_oculto_2))
		form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end	
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.fecha")
	anexo_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.plano_de_electricidad")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.adjunto_oculto",anexo_3)
	adjunto_oculto_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.adjunto_oculto")
	anexo_oculto_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.anexo_oculto")
	if ((anexo_3 != "") && (fecha_3 == "") || (adjunto_oculto_3 != anexo_oculto_3))
		form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_4 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.fecha")
	anexo_4 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.plano_de_plomeria")
	form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.adjunto_oculto",anexo_4)
	adjunto_oculto_4 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.adjunto_oculto")
	anexo_oculto_4 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.anexo_oculto")
	if ((anexo_4 != "") && (fecha_4 == "") || (adjunto_oculto_4 != anexo_oculto_4))
		form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_5 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.fecha")
	anexo_5 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.memoria_tecnica_por_especialidad_del_proyecto")
	form_data.set("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.adjunto_oculto",anexo_5)
	adjunto_oculto_5 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.adjunto_oculto")
	anexo_oculto_5 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.anexo_oculto")
	if ((anexo_5 != "") && (fecha_5 == "") || (adjunto_oculto_5 != anexo_oculto_5))
		form_data.set("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_6 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.fecha")
	anexo_6 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.certificado_de_registro_publico")
	form_data.set("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.adjunto_oculto",anexo_6)
	adjunto_oculto_6 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.adjunto_oculto")
	anexo_oculto_6 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.anexo_oculto")
	if ((anexo_6 != "") && (fecha_6 == "") || (adjunto_oculto_6 != anexo_oculto_6))
		form_data.set("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_7 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.fecha")
	anexo_7 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.aprobacion_del_miviot")
	form_data.set("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.adjunto_oculto",anexo_7)
	adjunto_oculto_7 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.adjunto_oculto")
	anexo_oculto_7 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.anexo_oculto")
	if ((anexo_7 != "") && (fecha_7 == "") || (adjunto_oculto_7 != anexo_oculto_7))
		form_data.set("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_8 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.fecha")
	anexo_8 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.certificacion_del_ingeniero_disenador")
	form_data.set("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.adjunto_oculto",anexo_8)
	adjunto_oculto_8 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.adjunto_oculto")
	anexo_oculto_8 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.anexo_oculto")
	if ((anexo_8 != "") && (fecha_8 == "") || (adjunto_oculto_8 != anexo_oculto_8))
		form_data.set("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end												
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_9 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.fecha")
	anexo_9 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.escritura_o_contrato_de_arrendamiento")
	form_data.set("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.adjunto_oculto",anexo_9)
	adjunto_oculto_9 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.adjunto_oculto")
	anexo_oculto_9 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.anexo_oculto")
	if ((anexo_9 != "") && (fecha_9 == "") || (adjunto_oculto_9 != anexo_oculto_9))
		form_data.set("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_10 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.fecha")
	anexo_10 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.nota_de_autorizacion_del_profesional_original")
	form_data.set("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.adjunto_oculto",anexo_10)
	adjunto_oculto_10 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.adjunto_oculto")
	anexo_oculto_10 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.anexo_oculto")
	if ((anexo_10 != "") && (fecha_10 == "") || (adjunto_oculto_10 != anexo_oculto_10))
		form_data.set("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
	#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#
	fecha_11 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.fecha")
	anexo_11 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.anexos_adicionales_del_solicitante")
	form_data.set("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.adjunto_oculto",anexo_11)
	adjunto_oculto_11 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.adjunto_oculto")
	anexo_oculto_11 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.anexo_oculto")
	if ((anexo_11 != "") && (fecha_11 == "") || (adjunto_oculto_11 != anexo_oculto_11))
		form_data.set("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.fecha",fecha.strftime("%d/%m/%Y %H:%M:%S"))
	end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_parte_oculta]'), function(index, campo) {
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta";
		var mod2 = "_oculto";
		var coincide = inicio_ruta.concat(mod2);
		$(coincide).parents(".part-box").hide();
	});   

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_arquitectura_p5]'), function(index, campo) {	
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
		  pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_plano_de_arquitectura_p5";
		var fecha = "_fecha";
		var adjunto = "_plano_de_arquitectura";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_estructura_p5]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_plano_de_estructura_p5";
		var fecha = "_fecha";
		var adjunto = "_plano_de_estructura";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	}); 
 
	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_electricidad]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_plano_de_electricidad";
		var fecha = "_fecha";
		var adjunto = "_plano_de_electricidad";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});   
 
	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_plomeria]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_plano_de_plomeria";
		var fecha = "_fecha";
		var adjunto = "_plano_de_plomeria";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	}); 
                
	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_memoria_tecnica_por_especialidad_del_proyecto]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_memoria_tecnica_por_especialidad_del_proyecto";
		var fecha = "_fecha";
		var adjunto = "_memoria_tecnica_por_especialidad_del_proyecto";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	}); 

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_certificado_de_registro_publico]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_certificado_de_registro_publico";
		var fecha = "_fecha";
		var adjunto = "_certificado_de_registro_publico";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	}); 

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_aprobacion_del_miviot]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_aprobacion_del_miviot";
		var fecha = "_fecha";
		var adjunto = "_aprobacion_del_miviot";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_certificacion_del_ingeniero_disenador]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_certificacion_del_ingeniero_disenador";
		var fecha = "_fecha";
		var adjunto = "_certificacion_del_ingeniero_disenador";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_escritura_o_contrato_de_arrendamiento]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_escritura_o_contrato_de_arrendamiento";
		var fecha = "_fecha";
		var adjunto = "_escritura_o_contrato_de_arrendamiento";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_nota_de_autorizacion_del_profesional_original]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_nota_de_autorizacion_del_profesional_original";
		var fecha = "_fecha";
		var adjunto = "_nota_de_autorizacion_del_profesional_original";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});

	$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_anexos_adicionales_del_solicitante_p5]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var inicio_ruta = "#field_anexos_002_aprobacion_de_planos_2_anexos_adicionales_del_solicitante_p5";
		var fecha = "_fecha";
		var adjunto = "_anexos_adicionales_del_solicitante";
		var anexo_oculto = "_anexo_oculto";
		var adjunto_oculto = "_adjunto_oculto";
		var coincide = inicio_ruta.concat(pos);
		var adjunto_g = coincide.concat(adjunto)
		var get_fecha = coincide.concat(fecha);
		var anexo = coincide.concat(anexo_oculto);
		var adjuntos = coincide.concat(adjunto_oculto);
		$(anexo).parents(".field-box").hide();
		$(adjuntos).parents(".field-box").hide();
		tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(get_fecha);
		//alert(adjunto_g);
		if ($(get_fecha).html() == ''){
			$(get_fecha).parents(".field-box").hide();
		}
		if ($(adjunto_g).val() == ''){
			$(get_fecha).html('');
		} 
		// if ($(tat1).val() != 'llenar'){
		//     if ($(adjunto_g).val() != ''){ 
		// 		//$(adjunto_g).attr("disabled","disabled");
		// 		//$(adjunto_g).parent().find('a.upload-document-task').unbind('click');
		// 	}
		// }
	});
});
    STEPAJAXCODE
  end
            
