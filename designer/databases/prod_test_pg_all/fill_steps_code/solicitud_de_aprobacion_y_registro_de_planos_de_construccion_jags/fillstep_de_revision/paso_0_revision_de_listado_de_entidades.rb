
  class Paso0RevisionDeListadoDeEntidades < TemplateCode::Step

    on_becoming do
      # Inicializacion de datos del agente - LG
_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]

form_data.set("seccion_de_funcionario_jefe3.datos_del_funcionario_generico.usuario", _agente["name"])


#Nombres de entidades AV
_app_id = @application["id"].to_s
result_entidades = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
entidades=[]
result_entidades["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
	next unless key =~ /entidades_instance/ 
	entidades << entidad_data["evaluacion_de_la_entidad"]  
end

_siglas = @task.name.split(' ').last.upcase rescue ""
fecha_inicio = Date.today

entidades.each_index do |i|
	##### SE ASIGNAN LOS NOMBRES DE TODAS LAS ENTIDADES EVALUADORAS #####
		_nombre = entidades[i]["entidad"]
		form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_de_la_entidad", _nombre)
		form_data.set("entidad_evaluadora.funcionario_de_entidad_evaluadora_#{i}_de_2do_nivel.nombre_de_la_institucion", _nombre)
end

    end

    on_transition do
      _obs = form_data.get("seccion_de_funcionario_jefe3.datos_del_funcionario_generico.observaciones")
_eval = form_data.get("seccion_de_funcionario_jefe3.datos_del_funcionario_generico.evaluacion_ok_reparo")

if (_eval =="REPARO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del reparo en el campo (Observación). "
end

entidades = form_data.get("asignacion_de_entidades.entidad_evaluadora.entidad_evaluadora_check")
entidades = JSON.parse(entidades)

form_data.set("asignacion_de_entidades.dato.valor",entidades)


#:::: REQUERIMIENTO LUNES 10 DE AGOSTO DE 2015 - MEJORA #6 SOLVENTADO POR LP ::::#

##..LP- Validación para Enviar a reparo si se selecciona entidad de CBP y no se exonera su pago

#***** ENTIDADES SELECCIONADAS EN TAREA ACTUAL - OBTENIDAS COMO ARREGLO *****
#entidades = form_data.decode_get("asignacion_de_entidades.entidad_evaluadora.entidad_evaluadora_check") #Nueva
#***** ENTIDADES SELECCIONADAS EN TAREA DE ASIGNACION - OBTENIDAS COMO ARREGLO  *****
#datos1 = form_data.decode_get("asignacion_de_entidades.dato.valor") #Vieja
#Entidades exoneradas de pago Actuales
#entPago = form_data.decode_get("asignacion_de_entidades.exoneracion_p5.entidades") 
 
#decision = form_data.get("seccion_de_funcionario_jefe3.datos_del_funcionario_generico.evaluacion_ok_reparo")

#if ( !entidades.blank?)
	#if (datos1 != entidades) 
		# if ((((!datos1.include?("CBP-OS. Sección de Arquitectura")) && (entidades.include?("CBP-OS. Sección de Arquitectura")) && (!entPago.include?("CBP-OS. Sección de Arquitectura"))) ||
		  #((!datos1.include?("CBP-OS. Sección de Electricidad")) && (entidades.include?("CBP-OS. Sección de Electricidad")) && (!entPago.include?("CBP-OS. Sección de Electricidad"))) ||
		  #((!datos1.include?("CBP-OS. Sección de Plomería")) && (entidades.include?("CBP-OS. Sección de Plomería")) && (!entPago.include?("CBP-OS. Sección de Plomería")))) &&
		 # decision != "REPARO")
		  #transition_errors << "Usted a seleccionado una nueva entidad de Bomberos. Debe seleccionar la opción REPARO para que el analista seleccione a esta entidad dentro de las entidades a evaluar"
		 #end
	#end
#end
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
///ocultar o mostrar campo otro dependiendo de la selección
  $(document).ready(function(){
  dato= $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_uso_de_la_obra").find(':selected').val();
    if(dato != 'Otros'){
        $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").val('');
        $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().hide();
      }
      else{
        $("#field_datos_generales_del_proyecto_datos_generales_del_proyecto_otros").parent().parent().show();
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

// REQUERIMIENTO 16/07/2015 Colocar opción de ayuda en la sección de “Entidad Evaluadora” en la sección de “Asignación de Entidades”.

//Alertas en checkboxes
//$(document).ready(function(){
  //$("input[name='[field][asignacion_de_entidades_entidad_evaluadora_entidad_evaluadora_check][]']").change(function() {       
    //$(this).each(function(){  
      //if (this.checked) {
        //var dato = $(this).val();
        //if(dato == "CBP-OS. Sección de Electricidad"){
          //alert("Usted ha seleccionado la entidad de Sección de Electricidad del Cuerpo de Bomberos, para realizar la verificación del pago correspondiente en la Entidad, deberá solicitar Reparo al Analista de Ingreso.");
        //}else if (dato == "CBP-OS. Sección de Plomería"){
          //alert("Usted ha seleccionado la entidad de Sección de Plomería del Cuerpo de Bomberos, para realizar la verificación del pago correspondiente en la Entidad, deberá solicitar Reparo al Analista de Ingreso.");
        //}else if (dato == "CBP-OS. Sección de Arquitectura"){
          //alert("Usted ha seleccionado la entidad de Sección de Arquitectura del Cuerpo de Bomberos, para realizar la verificación del pago correspondiente en la Entidad, deberá solicitar Reparo al Analista de Ingreso.");
        //}
      //} 
    //}); 
  //}); 
//});
    STEPAJAXCODE
  end
            
