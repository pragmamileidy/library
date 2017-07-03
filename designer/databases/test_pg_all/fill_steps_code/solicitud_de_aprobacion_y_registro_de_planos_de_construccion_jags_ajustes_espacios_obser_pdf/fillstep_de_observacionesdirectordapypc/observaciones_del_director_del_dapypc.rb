
  class ObservacionesDelDirectorDelDapypc < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente - LG

_idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]


form_data.set("seccion_de_funcionario_jefe5.datos_del_funcionario_generico.usuario", _agente["name"])


##Nombre de entdades Evaluadoras de FUNCIONARIOS
_app_id = @application["id"].to_s
result = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
entidades=[]
result["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
	next unless key =~ /entidades_instance/ 
	entidades << entidad_data["evaluacion_de_la_entidad"]  
end



entidades.each_index do |i|
 if entidades[i]
  _nombre = entidades[i]["entidad"]
  _nombref = entidades[i]["entidad"]


  form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_de_la_entidad", _nombre)
  form_data.set("entidad_evaluadora.funcionario_de_entidad_evaluadora_#{i}_de_2do_nivel.nombre_de_la_institucion", _nombref)
 end
end


evaluacion = form_data.get("seccion_de_funcionario_jefe4.datos_del_funcionario_generico.evaluacion")		  
if (evaluacion == "OK") 
			monto_final = form_data.get("entidad_evaluadora_revisiones.monto_total.total") 
			form_data.set("entidad_evaluadora_revisiones.monto_total.final", monto_final)
			 form_data.set("entidad_evaluadora_revisiones.monto_total.monto_pagado", " ") 
                         form_data.set("entidad_evaluadora_revisiones.monto_total.costo", " ") 
                          form_data.set("entidad_evaluadora_revisiones.monto_total.acumulado", " ") 
end
    end

    on_transition do
      if (form_data.get("seccion_de_funcionario_jefe5.datos_del_funcionario_generico.evaluacion")=="REPARO")
	##Nombre de entdades Evaluadoras de FUNCIONARIOS
	_app_id = @application["id"].to_s
	result = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
	entidades=[]
	result["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
		next unless key =~ /entidades_instance/ 
                entidades << entidad_data["evaluacion_de_la_entidad"] 
	end

	_unaObservacion = false
	(1..entidades.size).each do |i|
                x = i - 1
		if entidades[x]
		  _unaObservacion = !form_data.get("entidad_evaluadora.funcionario_de_entidad_evaluadora_#{i}_de_2do_nivel.observaciones3").blank?
		 end
	end

	if _unaObservacion == false
		transition_errors << "Debe Agregar una Observación a la Enidad que desea enviar a Reparo"
	end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //function ocultar1(){
//          $('input[name="[field][asignacion_de_entidades_exoneracion_p5_entidades][]"]').parent().parent().parent().parent().parent().hide();
//  } 
//$( function() {
  //  $( "input:radio" ).click(function() {
  //    check3(this);
  //  });
//});                                                
//function check3(obj) {
//    if (obj.value == "SÍ" && obj.name=="[field][asignacion_de_entidades_confirma_exoneracion_exonerar]"){
//          $('input[name="[field][asignacion_de_entidades_exoneracion_p5_entidades][]"]').parent().parent().parent().parent().parent().show();                                                          
//  } 
  
//  if (obj.value == "NO" && obj.name=="[field][asignacion_de_entidades_confirma_exoneracion_exonerar]"){ 
//          $('input[name="[field][asignacion_de_entidades_exoneracion_p5_entidades][]"]').parent().parent().parent().parent().parent().hide();
//    }
//  }
//ocultar1();

////////////////LP Ocultar Secciones vacías
  $(document).ready(function(){     
      $.each( $('[id*=datos_del_co_participante_]'), function(index, campo) {
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
          pos = (this.id).match(/_instance_[\d]/);
        } 
        var productor = "#field_datos_del_co_participante";
        var mod1 = productor.concat(pos)
        var docs = "_datos_del_co_participante_tipo_de_co_participante_string";
        var documento_d = mod1.concat(docs);
            if($(documento_d).html()!= ''){
              $(documento_d).parents(".section-box").show()
            }
      });
  });

//:::LP mostrar campo Otro si fue seleccionado en el uso de la obra 29-02-2016
$(document).ready(function(){
    dato1= $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_uso_de_la_obra");
    if($(dato1).html() == 'Otros'){
        $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().show();
    }
    else{
        $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().hide();
    }
});

    
//::: DV: Solicitado el Jueves 05/02/2016, ralizado por JA ::://
$(document).ready(function(){
    dato1= $("#field_uso_del_suelo_uso_del_suelo_tipo_de_suelo");
    if($(dato1).html() == ' Otro'){
        $("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().show();
    }
    else{
        $("#field_uso_del_suelo_uso_del_suelo_otro").val('');
        $("#field_uso_del_suelo_uso_del_suelo_otro").parent().parent().hide();
    }
});

//:::: DV: Ocultar sección de Finca cuando su número sea blanco
$(document).ready(function(){
    $.each( $('[id*=datos_de_la_finca_]'), function director(index, campo) {       
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   
        var InicioRuta  = "#field_datos_de_la_finca";
        var nrofinca    = "_datos_de_finca_numero_de_finca";
        //:::::::::::::Variable instancias seccion más instancia parte:::::::::::::::://
    var colind_10     = "_datos_catastrales_del_colindante_instance_1_colidante";
    var colind_20     = "_datos_catastrales_del_colindante_instance_2_colidante";
    var colind_30     = "_datos_catastrales_del_colindante_instance_3_colidante";
    var colind_40     = "_datos_catastrales_del_colindante_instance_4_colidante";
    var colind_50     = "_datos_catastrales_del_colindante_instance_5_colidante";
    var colind_60     = "_datos_catastrales_del_colindante_instance_6_colidante";
    var colind_70     = "_datos_catastrales_del_colindante_instance_7_colidante";
    var colind_80     = "_datos_catastrales_del_colindante_instance_8_colidante";
    var colind_90     = "_datos_catastrales_del_colindante_instance_9_colidante";
    var colind_100    = "_datos_catastrales_del_colindante_instance_10_colidante";
    var coincide      = InicioRuta.concat(pos);
    var nrofinca2     = coincide.concat(nrofinca);
    var colind_1    = coincide.concat(colind_10);
    var colind_2    = coincide.concat(colind_20);
    var colind_3    = coincide.concat(colind_30);
    var colind_4    = coincide.concat(colind_40);
    var colind_5    = coincide.concat(colind_50);
    var colind_6    = coincide.concat(colind_60);
    var colind_7    = coincide.concat(colind_70);
    var colind_8    = coincide.concat(colind_80);
    var colind_9    = coincide.concat(colind_90);
    var colind_10     = coincide.concat(colind_100);

      //var parte2      = coincide.concat(parte);
      if($(nrofinca2).html() != ""){
          $(nrofinca2).parents(".section-box").show();
      }
      
      //:::::::::::::Mostrar parte de datos_catastrales_del_colindante que no tengan instancias vacías:::::::::::::::://
      if ($(colind_1).html() != ""){
          $(colind_1).parents(".part-box").show();
      }
      if ($(colind_2).html() != ""){
          $(colind_2).parents(".part-box").show();
      }
      if ($(colind_3).html() != ""){
          $(colind_3).parents(".part-box").show();
      }
      if ($(colind_4).html() != ""){
          $(colind_4).parents(".part-box").show();
      }
      if ($(colind_5).html() != ""){
          $(colind_5).parents(".part-box").show();
      }
      if ($(colind_6).html() != ""){
          $(colind_6).parents(".part-box").show();
      }
      if ($(colind_7).html() != ""){
          $(colind_7).parents(".part-box").show();
      }
      if ($(colind_8).html() != ""){
          $(colind_8).parents(".part-box").show();
      }
      if ($(colind_9).html() != ""){
          $(colind_9).parents(".part-box").show();
      }
      if ($(colind_10).html() != ""){
          $(colind_10).parents(".part-box").show();
      }
      $(nrofinca2).parents(".section-box").next().hide();
    });
});

////LP.....Función para mostrar u ocultar Campos....////
$(document).ready(function(){
  ////campos ocultos
  no_plano_original = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_no_del_plano_original');  
  no_de_anteproyecto = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_no_de_anteproyecto');
  fecha_de_aprobacion_de_anteproyecto = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_fecha_de_aprobacion_de_anteproyecto');
  ////campos de selección
  tipo_de_solicitud_municipio = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_tipo_de_solicitud_municipio');    
  tipo_de_plano = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_tipo_de_plano');    
  etapa_de_construccion = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_etapa_de_construccion');
  
  ////Funciones genericas para mostrar u ocultar campos
    function mostrar(obj) {
      obj.parent().parent().show();
    }
      function ocultar(obj) {
    obj.parent().parent().hide();
    }
  ////para no perder cambios en reapro y entre pasos

    $( function() {
      if ($(tipo_de_plano).html()== "Plano Original de Edificación") {
            mostrar(no_de_anteproyecto);
            mostrar(fecha_de_aprobacion_de_anteproyecto);
          } else {
            ocultar(no_de_anteproyecto);
            ocultar(fecha_de_aprobacion_de_anteproyecto);
          };

          if(($(etapa_de_construccion).html()=="") && ($(tipo_de_solicitud_municipio).html()!="Re-aprobación")){
        ocultar(no_plano_original);
      } 
      else if (($(tipo_de_plano).html()== "Plano Adicional de Edificación") || ($(tipo_de_solicitud_municipio).html()=="Re-aprobación") || 
        ($(etapa_de_construccion).html()!= "Plano completo")) {
         mostrar(no_plano_original);
        }
       else{
        ocultar(no_plano_original);
      };
    });
});


////LP...Función para ocultar o mostrar campos del coparticipante profesional
$(document).ready(function(){
  $.each( $('[id*=datos_del_co_participante_]'), function(index, campo) {
  //variable para la posición de las instancias
     var pos = (this.id).match(/_instance_[\d][\d]/);
     if (pos == null){
       pos = (this.id).match(/_instance_[\d]/);
     }
  //concatenando rutas
   var mod1 = "#field_datos_del_co_participante";
   var tipo_co = "_datos_del_co_participante_tipo_de_co_participante_string";
   var idone = "_datos_del_co_participante_idoneidad";
   var esp= "_datos_del_co_participante_especialidad_profesional";
   var mod3 = mod1.concat(pos);
   var tipo_coparticipante = mod3.concat(tipo_co);
   var idoneidad = mod3.concat(idone);
   var especialidad = mod3.concat(esp);

        //para no perder cambios entre pasos y reparo
        if ($(tipo_coparticipante).html() == "Profesional responsable") {
            $(idoneidad).parent().parent().show();
            $(especialidad).parent().parent().show();
        } else {
          $(idoneidad).parent().parent().hide();
          $(especialidad).parent().parent().hide();
        };

  });
});




//////////////////////////////////////////////////////////////////////////////////////////////////////////////

$(document).ready(function(){
  entidad_evaluadora_0 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_0_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_1 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_1_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_2 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_2_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_3 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_3_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_4 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_4_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_5 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_5_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_6 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_6_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_7 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_7_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_8 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_8_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_9 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_9_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_10 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_10_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_11 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_11_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_12 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_12_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_13 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_13_de_2do_nivel_nombre_de_la_institucion");
    entidad_evaluadora_14 = $("#field_entidad_evaluadora_funcionario_de_entidad_evaluadora_14_de_2do_nivel_nombre_de_la_institucion");

    entidad_funcionario_0 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_0_usuario");
    entidad_funcionario_1 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_1_usuario");
    entidad_funcionario_2 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_2_usuario");
    entidad_funcionario_3 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_3_usuario");
    entidad_funcionario_4 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_4_usuario");
    entidad_funcionario_5 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_5_usuario");
    entidad_funcionario_6 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_6_usuario");
    entidad_funcionario_7 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_7_usuario");
    entidad_funcionario_8 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_8_usuario");
    entidad_funcionario_9 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_9_usuario");
    entidad_funcionario_10 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_10_usuario");
    entidad_funcionario_11 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_11_usuario");
    entidad_funcionario_12 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_12_usuario");
    entidad_funcionario_13 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_13_usuario");
    entidad_funcionario_14 = $("#field_entidad_evaluadora_revisiones_entidad_evaluadora_14_usuario");


    //:::::::: Mnatener campos entre pasos y reparo :::::://
    if($(entidad_funcionario_0).html() == ""){
        $(entidad_evaluadora_0).parents(".part-box").hide(); 
        $(entidad_funcionario_0).parents(".part-box").hide();   
    }else{
    $(entidad_evaluadora_0).parents(".part-box").show(); 
    $(entidad_funcionario_0).parents(".part-box").show();  
    }
    if($(entidad_funcionario_1).html() == ""){
        $(entidad_evaluadora_1).parents(".part-box").hide();  
        $(entidad_funcionario_1).parents(".part-box").hide();  
    }else{
    $(entidad_evaluadora_1).parents(".part-box").show();  
    $(entidad_funcionario_1).parents(".part-box").show();
    }
    if($(entidad_funcionario_2).html() == ""){
        $(entidad_evaluadora_2).parents(".part-box").hide(); 
        $(entidad_funcionario_2).parents(".part-box").hide();   
    }else{
         $(entidad_evaluadora_2).parents(".part-box").show();  
         $(entidad_funcionario_2).parents(".part-box").show();
    }  
    if($(entidad_funcionario_3).html() == ""){
        $(entidad_evaluadora_3).parents(".part-box").hide();
        $(entidad_funcionario_3).parents(".part-box").hide();     
    }else{
         $(entidad_evaluadora_3).parents(".part-box").show();
         $(entidad_funcionario_3).parents(".part-box").show();  
    }
    if($(entidad_funcionario_4).html() == ""){
        $(entidad_funcionario_4).parents(".part-box").hide();  
        $(entidad_evaluadora_4).parents(".part-box").hide();    
    }else{
         $(entidad_funcionario_4).parents(".part-box").show(); 
         $(entidad_evaluadora_4).parents(".part-box").show();  
    }
    if($(entidad_funcionario_5).html() == ""){
        $(entidad_funcionario_5).parents(".part-box").hide();   
        $(entidad_evaluadora_5).parents(".part-box").hide();   
    }else{
         $(entidad_evaluadora_5).parents(".part-box").show();
         $(entidad_funcionario_5).parents(".part-box").show();  
    }
    if($(entidad_funcionario_6).html() == ""){
        $(entidad_funcionario_6).parents(".part-box").hide();
        $(entidad_evaluadora_6).parents(".part-box").hide();     
    }else{
         $(entidad_funcionario_6).parents(".part-box").show();
         $(entidad_evaluadora_6).parents(".part-box").show();   
    }
    if($(entidad_funcionario_7).html() == ""){
        $(entidad_evaluadora_7).parents(".part-box").hide();  
        $(entidad_funcionario_7).parents(".part-box").hide();  
    }else{
         $(entidad_funcionario_7).parents(".part-box").show();  
         $(entidad_evaluadora_7).parents(".part-box").show(); 
    }
    if($(entidad_funcionario_8).html() == ""){
        $(entidad_evaluadora_8).parents(".part-box").hide();   
        $(entidad_funcionario_8).parents(".part-box").hide();  
    }else{
         $(entidad_funcionario_8).parents(".part-box").show(); 
         $(entidad_evaluadora_8).parents(".part-box").show();  
    }
    if($(entidad_funcionario_9).html() == ""){
        $(entidad_evaluadora_9).parents(".part-box").hide(); 
        $(entidad_funcionario_9).parents(".part-box").hide();     
    }else{
         $(entidad_funcionario_9).parents(".part-box").show(); 
         $(entidad_evaluadora_9).parents(".part-box").show(); 
    }
    if($(entidad_funcionario_10).html() == ""){
        $(entidad_evaluadora_10).parents(".part-box").hide();
        $(entidad_funcionario_10).parents(".part-box").hide();     
    }else{
         $(entidad_funcionario_10).parents(".part-box").show(); 
         $(entidad_evaluadora_10).parents(".part-box").show(); 
    }
    if($(entidad_funcionario_11).html() == ""){
        $(entidad_evaluadora_11).parents(".part-box").hide(); 
        $(entidad_funcionario_11).parents(".part-box").hide();    
    }else{
         $(entidad_funcionario_11).parents(".part-box").show();
         $(entidad_evaluadora_11).parents(".part-box").show();   
    }
    if($(entidad_funcionario_12).html() == ""){
        $(entidad_evaluadora_12).parents(".part-box").hide();
        $(entidad_funcionario_12).parents(".part-box").hide();    
    }else{
         $(entidad_funcionario_12).parents(".part-box").show();  
         $(entidad_evaluadora_12).parents(".part-box").show(); 
    }
    if($(entidad_funcionario_13).html() == ""){
        $(entidad_evaluadora_13).parents(".part-box").hide();
        $(entidad_funcionario_13).parents(".part-box").hide();    
    }else{
         $(entidad_funcionario_13).parents(".part-box").show();  
         $(entidad_evaluadora_13).parents(".part-box").show(); 
    }
    if($(entidad_funcionario_14).html() == ""){
        $(entidad_evaluadora_14).parents(".part-box").hide();
        $(entidad_funcionario_14).parents(".part-box").hide();    
    }else{
         $(entidad_funcionario_14).parents(".part-box").show();  
         $(entidad_evaluadora_14).parents(".part-box").show(); 
    }
});
    STEPAJAXCODE
  end
            
