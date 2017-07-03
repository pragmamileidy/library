
  class Paso7DatosDelImpresorEs < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      tipo_obra = form_data.get("informacion_de_la_obra_literaria.datos_de_la_obra.estatus_de_la_obra")

if (tipo_obra == "Publicada")
    #Usado para print design MT
    (1..5).each do |_num|
                    nombre2 = form_data.get("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.primer_nombre")
                    nombre3 = form_data.get("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.segundo_nombre")
                    nombre4 = form_data.get("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.primer_apellido")
                    nombre5 = form_data.get("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.segundo_apellido")
                    nombre6 = form_data.get("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.apellido_de_casada")
                    
                    nombre_completo = nombre2.to_s + " " + nombre3.to_s + " " + nombre4.to_s + " " + nombre5.to_s + " " + nombre6.to_s
                    
                    form_data.set("datos_de_los_impresores_instance_#{_num}.datos_de_la_persona.nombre_completo", nombre_completo)
    end
end

# Obtener valor del config
valor = @config.route("Rates-payment-payment-payment")

if valor == "Electrónico"
    form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Electrónico")
end
if valor == "Manual"
    form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      /////////////////////////////MT - HABILITAR CAMPOS, ESCONDER CAMPOS

$( function() {
    
    $(document).ready(function(){
        $.each( $('[id*=datos_de_los_impresores_]'), function(index, campo) {
    
            var pos = (this.id).match(/_instance_[\d][\d]/);
            if (pos == null){
                pos = (this.id).match(/_instance_[\d]/);
            }   

        var mod1 = "#field_datos_de_los_impresores";
        var mod2 = "_tipo_de_identificacion_tipo_identificacion_texto";
        var mod_c = "_datos_de_la_persona_cedula_pasaporte";
        var mod_r = "_datos_de_la_empresa_ruc";
        var mod3 = mod1.concat(pos);
        var dato = mod3.concat(mod2);
        var ced = mod3.concat(mod_c);
        var ruc =  mod3.concat(mod_r);
        if ($(dato).val() != ''){
    	$(ced).parents(".section-box").show();
        
		        if($(dato).val() == 'Cédula' || $(dato).val() == 'Pasaporte'){ 
		            $(ruc).parents(".part-box").hide();
		            $(ced).parents(".part-box").show();
		        }else {
		            $(ruc).parents(".part-box").show();
		            $(ced).parents(".part-box").hide();
		        }

					//////////////////////////////MT - DESBLOQUEAR CAMPOS SI ES PASAPRTE/////////////////////////////////   
		            var productor = "#field_datos_de_los_impresores";
		            var mod1 = productor.concat(pos);

		            var doc1 = "_datos_de_la_persona_cedula_pasaporte"
		            var nom1 = "_datos_de_la_persona_primer_nombre";
		            var nom2 = "_datos_de_la_persona_segundo_nombre";
		            var ape1 = "_datos_de_la_persona_primer_apellido";
		            var ape2 = "_datos_de_la_persona_segundo_apellido";
		            var naci = "_datos_de_la_persona_nacionalidad";
		            var identificacion = mod1.concat(doc1)
		            var nombre1_p = mod1.concat(nom1);
		            var nombre2_p = mod1.concat(nom2);
		            var apellido1_p = mod1.concat(ape1);
		            var apellido2_p = mod1.concat(ape2);
		            var nacionalidad = mod1.concat(naci)
		                
		            if($(dato).val() == 'Pasaporte'){
		                //$(identificacion).removeAttr("disabled");
		                $(nombre1_p).removeAttr("disabled");
		                $(nombre2_p).removeAttr("disabled");
		                $(apellido1_p).removeAttr("disabled");
		                $(apellido2_p).removeAttr("disabled");  
		                $(nacionalidad).removeAttr("disabled");
		            }


		            if($(dato).val() == 'Cédula'){
// CV		                if($(nombre2_p).val() == ''){
		                    $(nombre2_p).removeAttr("disabled");
//		                }else{
//		                    $(nombre2_p).attr("disabled","disabled");
//		                }
//
//		                if($(apellido2_p).val() == ''){
		                    $(apellido2_p).removeAttr("disabled");
//		                }else{
//		                    $(apellido2_p).attr("disabled","disabled");
//		                }
		            }
		} else {
    		$(ruc).parents(".section-box").hide();
    	}
            $(dato).parents(".section-box").next().hide()
        }); 
    });

});
    STEPAJAXCODE
  end
            
