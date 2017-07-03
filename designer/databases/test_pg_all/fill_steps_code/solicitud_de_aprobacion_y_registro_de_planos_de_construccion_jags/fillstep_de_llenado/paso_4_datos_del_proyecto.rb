
  class Paso4DatosDelProyecto < TemplateCode::Step

    on_becoming do
      #ON BECOMING PASO 4

#Secuencia numérica:
nombre_tarea = (@task["name"].to_s.downcase).split(' ')
if nombre_tarea.first != 'reparar'
 if form_data.get("datos_generales_del_proyecto.datos_generales_del_proyecto.nro_oculto").blank?
  result = WebserviceConsumer.get('/consecutive/generador_numero_de_plano/generate.json').parsed_response
  nplano = result["response"]["value"]
  form_data.set("datos_generales_del_proyecto.datos_generales_del_proyecto.nro_oculto",nplano)
 end
end

#_numero_de_plano = form_data.get( "datos_generales_del_proyecto.datos_generales_del_proyecto.numero_de_plano")
#if  numero_de_plano.blank? || !numero_de_plano.blank?

 result = WebserviceConsumer.get('/service/ws_tipo_de_plano/records.json').parsed_response

 _secuencia=""
 _tipoPlano=""
 planos = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.tipo_de_plano")
 plano = WebserviceConsumer.get(URI.escape('/service/ws_tipo_de_plano/find.json?nombre=' + planos)).parsed_response
 _siglas = plano["response"]["siglas"]

 if _siglas==(result["response"][0]["siglas"])
  _tipoPlano= result["response"][0]["siglas"]
 end

 if _siglas==(result["response"][1]["siglas"])
  _tipoPlano= result["response"][1]["siglas"]
 end

 if _siglas==(result["response"][2]["siglas"])
  _tipoPlano= result["response"][2]["siglas"]
 end

 ####Categoria de Proyecto
 result = WebserviceConsumer.get('/service/ws_categoria_de_proyecto/records.json').parsed_response
 _cat=""
 categorias = form_data.get("datos_generales_del_proyecto.datos_generales_del_proyecto.categoria_del_proyecto")
 categoria = WebserviceConsumer.get(URI.escape('/service/ws_categoria_de_proyecto/find.json?nombre=' + categorias)).parsed_response
 _siglasc = categoria["response"]["siglas"]

 if _siglasc==(result["response"][0]["siglas"])
  _cat= result["response"][0]["siglas"]
 end

 if _siglasc==(result["response"][1]["siglas"])
  _cat= result["response"][1]["siglas"]
 end

 if _siglasc==(result["response"][2]["siglas"])
  _cat= result["response"][2]["siglas"]
 end

 if _siglasc==(result["response"][3]["siglas"])
  _cat= result["response"][3]["siglas"]
 end

 if _siglasc==(result["response"][4]["siglas"])
  _cat= result["response"][4]["siglas"]
 end

 _nro = form_data.get("datos_generales_del_proyecto.datos_generales_del_proyecto.nro_oculto")
 #Dos últimos dígitos del año en curso
 _time = Time.new
 _ano = _time.year.to_s[-2,2]
 _numero = "#{_tipoPlano}"+'-'+"#{_cat}"+'-'+"#{_nro}"+'-'+"#{_ano}"
 form_data.set("datos_generales_del_proyecto.datos_generales_del_proyecto.numero_de_plano",_numero)
#end



####Validación para colocar pago manual por defecto
#form_data.set("forma_de_pago.forma_de_pago.indique_la_forma_de_pago", "Pago Manual")

    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      		
	///ocultar o mostrar campo otro dependiendo de la selección	
		$(document).ready(function(){
$("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_nro_oculto").parent().parent().hide();


			$("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().hide();
			$("#field_uso_del_suelo_uso_del_suelo_tipo_de_suelo").change(function(){
			dato= $("#field_uso_del_suelo_uso_del_suelo_tipo_de_suelo").find(':selected').val();
				if(dato == ' Otro'){
					$("#field_uso_del_suelo_uso_del_suelo_otro").val('');
					$("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().show();
				}
				else{
					$("#field_uso_del_suelo_uso_del_suelo_otro").val('');
					$("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().hide();
				}
			});
			dato= $("#field_uso_del_suelo_uso_del_suelo_tipo_de_suelo").find(':selected').val();
			if(dato == ' Otro'){
					$("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().show();
				}
				else{
				$("#field_uso_del_suelo_uso_del_suelo_otro").val('');
				$("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().hide();
				}
	  });
    STEPAJAXCODE
  end
            
