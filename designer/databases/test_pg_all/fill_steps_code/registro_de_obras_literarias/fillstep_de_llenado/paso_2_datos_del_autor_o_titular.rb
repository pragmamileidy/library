
  class Paso2DatosDelAutorOTitular < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      #Usado para print design MT
(1..30).each do |_num|
                nombre2 = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_nombre")
                nombre3 = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_nombre")
                nombre4 = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_apellido")
                nombre5 = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_apellido")
                nombre6 = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.apellido_de_casada")
                
                nombre_completo = nombre2.to_s + " " + nombre3.to_s + " " + nombre4.to_s + " " + nombre5.to_s + " " + nombre6.to_s
                
                form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nombre_completo", nombre_completo)
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
	$.each( $('[id*=datos_del_autor_]'), function(index, campo) {
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		//alert(pos);
		var mod1 = "#field_datos_del_autor";
		var mod2 = "_tipo_de_identificacion_tipo_identificacion_texto";
		var mod_c = "_datos_de_la_persona_cedula_pasaporte";
		var mod_r = "_datos_de_la_empresa_ruc";
		var mod_s = "_seudonimo_indique_seudonimo"
		var mod3 = mod1.concat(pos);
		var dato = mod3.concat(mod2);
		var ced = mod3.concat(mod_c);
		var ruc =  mod3.concat(mod_r);
		var seu = mod3.concat(mod_s);

		/////////////////////////Datos a deshabilitar en persona natural ///////////////////////77

		var doc = "_datos_de_la_persona_cedula_pasaporte";
		var nom = "_datos_de_la_persona_primer_nombre";
		//    var nom2 = "_datos_de_la_persona_segundo_nombre";
		var nom3 = "_datos_de_la_persona_primer_apellido";
		//    var nom4 = "_datos_de_la_persona_segundo_apellido";
		var fec = "_datos_de_la_persona_fecha_de_nacimiento";
		var nac = "_datos_de_la_persona_nacionalidad";
		var edad = "_datos_de_la_persona_edad";

		var documento = mod3.concat(doc);
		var nombre1 =  mod3.concat(nom);
		//    var nombre2 =  mod3.concat(nom2);
		var nombre3 =  mod3.concat(nom3);
		//    var nombre4 = mod3.concat(nom4);
		var fecha = mod3.concat(fec);
		var nacionalidad = mod3.concat(nac);
		var age = mod3.concat(edad);

		if($(dato).val() == 'Cédula' || $(dato).val() == 'Pasaporte'){ 
			$(ruc).parents(".part-box").hide();
			$(ced).parents(".part-box").show();
		}else {
			$(ruc).parents(".part-box").show();
			$(ced).parents(".part-box").hide();
		}

		//alert(dato);
		if($(dato).val() == 'Pasaporte'){ 
// CV 29-Mar			$(documento).removeAttr("disabled");
			$(nombre1).removeAttr("disabled");
			//      $(nombre2).removeAttr("disabled");
			$(nombre3).removeAttr("disabled");
			//      $(nombre4).removeAttr("disabled");
			$(fecha).removeAttr("disabled");
			$(nacionalidad).removeAttr("disabled");
			$(age).removeAttr("disabled");
		}       

		if($(dato).val() == 'Cédula'){
			// if($(nombre2).val() == ''){
			// 	$(nombre2).removeAttr("disabled");
			// }else{
			// 	$(nombre2).attr("disabled","disabled");
			// }

			// if($(nombre4).val() == ''){
			// 	$(nombre4).removeAttr("disabled");
			// }else{
			// 	$(nombre4).attr("disabled","disabled");
			// }

			if ($(age).val() == ''){
				$(age).removeAttr("disabled");
			} else {
				$(age).attr("disabled","disabled");
			}
		}

		$(dato).parents(".section-box").next().hide();


		/////////////////////////VALIDACION SEUDONIMO//////////////////77

		var inicio = "input[name='[field][datos_del_autor";
		var fin = "_seudonimo_seudonimo][]']";
		var medio = inicio.concat(pos);
		var palabra = medio.concat(fin);
		// var detal = "_seudonimo_indique_seudonimo";
		// var detalle = mod3.concat(detal);


		if($(dato).val() == 'RUC'){
			$(seu).parents(".part-box").hide();
		} 

		if($(seu).val() == ""){
			$(seu).parents(".field-box").hide();
		}
		//alert(palabra);

		$(palabra).click(function(event){
			$(this).each(function(){
				if (this.checked) {
					var dato1 = $(this).val();

					if(dato1 == 'Seudónimo'){
						$(seu).parents(".field-box").show();
					}
				}
				if (!this.checked) {
					var dato1 = $(this).val();
					if(dato1 == 'Seudónimo'){
						$(seu).val('');
						$(seu).parents(".field-box").hide();
					}

				}
			});
		});  
	});
});
    STEPAJAXCODE
  end
            
