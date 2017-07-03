
  class Paso5ArchivosAdjuntos < TemplateCode::Step

    on_becoming do
      _numeroPlano = form_data.get("datos_generales_del_proyecto.categoria_del_proyecto.numero_de_plano")
form_data.set("asignacion_de_entidades.datos_especificados_por_el_analista.no_de_plano_asignado", _numeroPlano)

_categoria = form_data.get("datos_generales_del_proyecto.categoria_del_proyecto.categoria_del_proyecto")
form_data.set("asignacion_de_entidades.datos_especificados_por_el_analista.categoria_del_proyecto", _categoria)

    end

    on_transition do
      fecha = Date.today

(1..15).each do |x|
   fecha_1 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.plano_de_arquitectura")
	if (anexo != "") && (fecha_1 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_arquitectura_p5_instance_#{x}.fecha",fecha)
	end     
#######################################################################################################################
   fecha_2 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.plano_de_estructura")
	if (anexo != "") && (fecha_2 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_estructura_p5_instance_#{x}.fecha",fecha)
	end  	
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.plano_de_electricidad")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_electricidad_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.plano_de_plomeria")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.plano_de_plomeria_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.memoria_tecnica_por_especialidad_del_proyecto")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.memoria_tecnica_por_especialidad_del_proyecto_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.certificado_de_registro_publico")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.certificado_de_registro_publico_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.aprobacion_del_miviot")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.aprobacion_del_miviot_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.certificacion_del_ingeniero_disenador")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.certificacion_del_ingeniero_disenador_instance_#{x}.fecha",fecha)
	end  													
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.escritura_o_contrato_de_arrendamiento")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.escritura_o_contrato_de_arrendamiento_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.nota_de_autorizacion_del_profesional_original")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.nota_de_autorizacion_del_profesional_original_instance_#{x}.fecha",fecha)
	end  
#######################################################################################################################
   fecha_3 = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.fecha")
   anexo = form_data.get("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.anexos_adicionales_del_solicitante")
	if (anexo != "") && (fecha_3 == "")
	  form_data.set("anexos_002_aprobacion_de_planos_2.anexos_adicionales_del_solicitante_p5_instance_#{x}.fecha",fecha)
	end 
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){

  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_parte_oculta]'), function(index, campo) {
	
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta";
	var mod2 = "_oculto";
 	var mod3 = mod1.concat(mod2);
		$(mod3).parents(".part-box").hide();

  });   

$.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_arquitectura_p5]'), function(index, campo) {
		
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_plano_de_arquitectura_p5";
	var mod2 = "_fecha";
	var mod4 = "_plano_de_arquitectura";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parents(".field-box").hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}
  });
  
  
 $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_estructura_p5]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_plano_de_estructura_p5";
	var mod2 = "_fecha";
	var mod4 = "_plano_de_estructura";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parents(".field-box").hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  }); 
 
  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_electricidad]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_plano_de_electricidad";
	var mod2 = "_fecha";
	var mod4 = "_plano_de_electricidad";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parents(".field-box").hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });   
 
  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_plano_de_plomeria]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_plano_de_plomeria";
	var mod2 = "_fecha";
	var mod4 = "_plano_de_plomeria";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  }); 
                
 $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_memoria_tecnica_por_especialidad_del_proyecto]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_memoria_tecnica_por_especialidad_del_proyecto";
	var mod2 = "_fecha";
	var mod4 = "_memoria_tecnica_por_especialidad_del_proyecto";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  }); 

  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_certificado_de_registro_publico]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_certificado_de_registro_publico";
	var mod2 = "_fecha";
	var mod4 = "_certificado_de_registro_publico";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  }); 
  
 $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_aprobacion_del_miviot]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_aprobacion_del_miviot";
	var mod2 = "_fecha";
	var mod4 = "_aprobacion_del_miviot";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });
                                          
  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_certificacion_del_ingeniero_disenador]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_certificacion_del_ingeniero_disenador";
	var mod2 = "_fecha";
	var mod4 = "_certificacion_del_ingeniero_disenador";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });
						
  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_escritura_o_contrato_de_arrendamiento]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_escritura_o_contrato_de_arrendamiento";
	var mod2 = "_fecha";
	var mod4 = "_escritura_o_contrato_de_arrendamiento";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });
																	
 $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_nota_de_autorizacion_del_profesional_original]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_nota_de_autorizacion_del_profesional_original";
	var mod2 = "_fecha";
	var mod4 = "_nota_de_autorizacion_del_profesional_original";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });
																
  $.each( $('[id*=field_anexos_002_aprobacion_de_planos_2_anexos_adicionales_del_solicitante_p5]'), function(index, campo) {
	
	var pos = (this.id).match(/_instance_[\d][\d]/);
	if (pos == null){
	  pos = (this.id).match(/_instance_[\d]/);
	}
	//alert(pos);
	var mod1 = "#field_anexos_002_aprobacion_de_planos_2_anexos_adicionales_del_solicitante_p5";
	var mod2 = "_fecha";
	var mod4 = "_anexos_adicionales_del_solicitante";
 	var mod3 = mod1.concat(pos);
	var ced = mod3.concat(mod4)
	var lista_modelo = mod3.concat(mod2);
	tat1 = "#field_anexos_002_aprobacion_de_planos_2_parte_oculta_oculto"
		//alert(lista_modelo);
		//alert(ced);
        if ($(lista_modelo).val() == ''){
			$(lista_modelo).parent().parent().hide();
		}  
	if ($(tat1).val() != 'llenar'){
        if ($(ced).val() != ''){ 
			$(ced).attr("disabled","disabled");
			$(ced).parent().find('a.upload-document-task').unbind('click');
		}
	}

  });
  
}); 
    STEPAJAXCODE
  end
            
