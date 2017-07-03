
  class Paso2DatosDelSolicitanteYCoParticipantes < TemplateCode::Step

    on_becoming do
      (1..5).each do |_num|
    documen = form_data.get("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.tipo_de_co_participante")
    form_data.set("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.tipo_de_co_participante_string", documen)
end

    end

    on_transition do
      numeros = ["", "uno (1)", "dos (2)", "tres (3)", "cuatro (4)", "cinco (5)"]
(1..5).each do |i|
	#Tipo de co-participante
	tipo_cp = form_data.get("datos_del_co_participante_instance_#{i}.datos_del_co_participante.tipo_de_co_participante")
	#Número de Identificación
	numero_cp = form_data.get("datos_del_co_participante_instance_#{i}.datos_del_co_participante.tipo_de_co_participante")
	#Idoneidad
	idoneidad = form_data.get("datos_del_co_participante_instance_#{i}.datos_del_co_participante.idoneidad")
	if (tipo_cp == "Profesional responsable") && !numero_cp.blank? && idoneidad.blank?
		transition_errors << "Debe introducir el Número de Idoneidad del profesional número #{numeros[i]}. Por favor verifique"
	end
end

#::::::::::::::DV: Integración Obtener nro de documento Datos del CoParticipante::::::::::::::#
(1..5).each do |_num|
    nro_doc_d = form_data.get("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.numero_de_identificacion")
    form_data.set("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.doc_oculto",nro_doc_d)	
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //..::::::::::: DV: Validaciones varias PASO 2::::::::::..//

$(document).ready(function(){
    //:::::::::::::Habilitar Campos Cuando el Tipo de Documento sea Pasaporte en CO-PARTICIPANTE ::::::::::::::::://
    $.each( $('[id*=datos_del_co_participante_]'), function director(index, campo) {       
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   
        var InicioRuta  = "#field_datos_del_co_participante";
        var tipo_co     = "_datos_del_co_participante_tipo_de_co_participante_string";
        var tipo_doc    = "_datos_del_co_participante_tipo_de_identificacion";
        var idoneidad   = "_datos_del_co_participante_idoneidad";
        var esp_prof    = "_datos_del_co_participante_especialidad_profesional";
        var nro_telf    = "_datos_del_co_participante_numero_de_telefono";
        var correo      = "_datos_del_co_participante_correo_electronico";
        var nom1        = "_nombre_completo_primer_nombre";
        var ape1        = "_nombre_completo_primer_apellido";
        var nom2        = "_nombre_completo_segundo_nombre";
        var ape2        = "_nombre_completo_segundo_apellido";
        var ape3        = "_nombre_completo_apellido_de_casada";
        var identif1    = "_datos_del_co_participante_numero_de_identificacion";
        var doc_c       = "_datos_del_co_participante_doc_oculto";

        var coincide    = InicioRuta.concat(pos);
        var tipo_co2    = coincide.concat(tipo_co);
        var idoneidad2  = coincide.concat(idoneidad);
        var esp_prof2   = coincide.concat(esp_prof); 
        var nro_telf2   = coincide.concat(nro_telf);
        var correo2     = coincide.concat(correo);
        var nom1_1      = coincide.concat(nom1);
        var nom2_2      = coincide.concat(nom2);
        var ape1_1      = coincide.concat(ape1);
        var ape2_2      = coincide.concat(ape2);
        var ape3_3      = coincide.concat(ape3);
        var tipo_doc2    = coincide.concat(tipo_doc);
        var identif2    = coincide.concat(identif1);
        var docOculto 	= coincide.concat(doc_c);

        $(idoneidad2).parent().parent().hide();
        $(esp_prof2).parent().parent().hide();
        $(docOculto).parents(".field-box").hide();

        if ($(tipo_co2).html() == "Profesional responsable") {
            $(idoneidad2).parent().parent().show();
            $(esp_prof2).parent().parent().show();
        } else {
            $(idoneidad2).parent().parent().hide();
            $(esp_prof2).parent().parent().hide();
        }

        $(tipo_co2).parents(".section-box").next().hide();
        if ($(tipo_doc2).html() == ''){
            $(tipo_doc2).parents(".section-box").hide();
        }else{
            $(tipo_doc2).parents(".section-box").show();
        }

        if($(tipo_doc2).html() == "Pasaporte"){
            $(nom1_1).removeAttr("disabled");
            $(nom2_2).removeAttr("disabled");
            $(ape1_1).removeAttr("disabled");
            $(ape2_2).removeAttr("disabled");
        }
        if($(tipo_doc2).html() == 'Pasaporte' && $(identif2).html() != $(docOculto).val()){
            $(nom1_1).val('');
            $(nom2_2).val('');
            $(ape1_1).val('');
            $(ape2_2).val('');
            $(idoneidad2).val('');
            $(esp_prof2).val('');
        }
        if($(tipo_doc2).html() == 'Cédula' && $(identif2).html() != $(docOculto).val()){
            $(idoneidad2).val('');
            $(esp_prof2).val('');
        }
    });
});

//Habilitar o deshabilitar campos tlf y correo si están llenos o vacíos
tarea= $('#field_datos_del_co_participante_instance_1_nombre_completo_oculto').val();
if(tarea == "true"){
    $( function() {
        $(document).ready(function(){
            telefono = $('#field_datos_del_solicitante_natural_datos_del_solicitante_numero_de_telefono').val();
            correo = $('#field_datos_del_solicitante_natural_datos_del_solicitante_correo_electronico').val();
            if(telefono != ""){
                $("#field_datos_del_solicitante_natural_datos_del_solicitante_numero_de_telefono").attr("disabled","disabled");
            } else{
                $("#field_datos_del_solicitante_natural_datos_del_solicitante_numero_de_telefono").removeAttr("disabled","disabled");
            }
            if(correo != ""){
                $("#field_datos_del_solicitante_natural_datos_del_solicitante_correo_electronico").attr("disabled","disabled");
            } else{
                $("#field_datos_del_solicitante_natural_datos_del_solicitante_correo_electronico").removeAttr("disabled","disabled");
            }
        });
    });

    //Habilitar o deshabilitar campos tlf y correo si están llenos o vacíos
    $( function() {
        $(document).ready(function(){
            telefono = $('#field_datos_del_solicitante_juridico_datos_del_solicitante_numero_de_telefono').val();
            correo = $('#field_datos_del_solicitante_juridico_datos_del_solicitante_correo_electronico').val();
            if(telefono != ""){
                $("#field_datos_del_solicitante_juridico_datos_del_solicitante_numero_de_telefono").attr("disabled","disabled");
            } else{
             $("#field_datos_del_solicitante_juridico_datos_del_solicitante_numero_de_telefono").removeAttr("disabled","disabled");
            }
            if(correo != ""){
                $("#field_datos_del_solicitante_juridico_datos_del_solicitante_correo_electronico").attr("disabled","disabled");
            } else{
                $("#field_datos_del_solicitante_juridico_datos_del_solicitante_correo_electronico").removeAttr("disabled","disabled");
            }
        });
    });
}

//////////////////Habilitar o deshabilitar campos si están llenos o vacíos Co-participantes
tarea= $('#field_datos_del_co_participante_instance_1_datos_del_co_participante_oculto').val();
if(tarea == "true"){
    $(document).ready(function(){           
        $.each( $('[id*=datos_del_co_participante_]'), function(index, campo) {
            var pos = (this.id).match(/_instance_[\d][\d]/);
            if (pos == null){
                pos = (this.id).match(/_instance_[\d]/);
            }   
            var productor = "#field_datos_del_co_participante";
            var mod1 = productor.concat(pos)
            var docs = "_datos_del_co_participante_numero_de_telefono";
            var docs1 = "_datos_del_co_participante_correo_electronico";
            var docs2 = "_nombre_completo_primer_nombre";
            var docs3 = "_nombre_completo_primer_apellido";
            var docs4 = "_nombre_completo_segundo_nombre";
            var docs5 = "_nombre_completo_segundo_apellido";
            var docs6 = "_nombre_completo_apellido_de_casada";

            var documento_d = mod1.concat(docs);
            var correo = mod1.concat(docs1);
            var pnombre = mod1.concat(docs2);
            var papellido = mod1.concat(docs3);
            var snombre = mod1.concat(docs4);
            var sapellido = mod1.concat(docs5);
            var capellido = mod1.concat(docs5);

            if($(documento_d).val()== ''){
                $(documento_d).removeAttr("disabled","disabled");
            }else{ 
                $(documento_d).attr("disabled","disabled");
            }
            if($(correo).val()== ''){
                $(correo).removeAttr("disabled","disabled");
            }else{ 
                $(correo).attr("disabled","disabled");
            }
            if($(pnombre).val()== ''){
                $(pnombre).removeAttr("disabled","disabled");
            }else{ 
                $(pnombre).attr("disabled","disabled");
            }
            if($(papellido).val()== ''){
                $(papellido).removeAttr("disabled","disabled");
            }else{ 
                $(papellido).attr("disabled","disabled");
            }
            if($(snombre).val()== ''){
                $(snombre).removeAttr("disabled","disabled");
            }else{ 
                $(snombre).attr("disabled","disabled");
            }
            if($(sapellido).val()== ''){
                $(sapellido).removeAttr("disabled","disabled");
            }else{ 
                $(sapellido).attr("disabled","disabled");
            }
            if($(capellido).val()== ''){
                $(capellido).removeAttr("disabled","disabled");
            }else{ 
                $(capellido).attr("disabled","disabled");
            }
        });
    });
}
    STEPAJAXCODE
  end
            
