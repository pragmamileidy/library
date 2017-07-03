
  class Paso2DatosDelAutorEsOTitularEs < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      ##Usado para print
(1..10).each do |_num|

    primerNombre = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre")
	primerapellido = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido")
	segundoNombre = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre")
	segundoapellido = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido")
	apellidoCasada = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada")

	_nombre =  "#{primerNombre} "+"#{segundoNombre} "+"#{primerapellido} "+"#{segundoapellido} "+"#{apellidoCasada}"
	form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo",_nombre)

end



###LP Validación de fechas
(1..10).each do |_num|
	_defuncion = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion")
    naci = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento")

	if (_defuncion.to_date > Date.today)
		transition_errors << "La fecha de defunción #{_num}, no debe ser mayor a la fecha actual."
	end if _defuncion.present?

	if (naci.to_date > Date.today)
		transition_errors << "La fecha de nacimiento #{_num}, no debe ser mayor a la fecha actual."
    end if naci.present?

    if (naci.to_date > _defuncion.to_date)
	   transition_errors << "La fecha de nacimiento #{_num}, no debe ser mayor a la fecha de defunción #{_num}."
    end if _defuncion.present? && naci.present?

end


    end

    AJAX_CALLS <<-STEPAJAXCODE 
      /////////////Habilitar campos si tipo documento es pasaporte
$(document).ready(function(){

    $.each( $('[id*=datos_del_autor_es_persona_natural_]'), function(index, campo) {

        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   

        var autor = "#field_datos_del_autor_es_persona_natural";
        //  var parte = "_datos_de_la_persona";
        var mod1 = autor.concat(pos);
        //var mod2 = mod1.concat(parte);

        var docs = "_datos_de_la_persona_tipo_documento_string";
        var identificacion = "_datos_de_la_persona_cedula_pasaporte";
        var nom1 = "_datos_de_la_persona_primer_nombre";
        var nom2 = "_datos_de_la_persona_segundo_nombre";
        var ape1 = "_datos_de_la_persona_primer_apellido";
        var ape2 = "_datos_de_la_persona_segundo_apellido";
        var apec = "_datos_de_la_persona_apellido_de_casada";
        var nac  = "_datos_de_la_persona_nacionalidad";
        var fec  = "_datos_de_la_persona_fecha_de_nacimiento";
      var edad  = "_datos_de_la_persona_edad";
    
        var documento_d = mod1.concat(docs);
        var ced = mod1.concat(identificacion);
        var nombre1_d = mod1.concat(nom1);
        var nombre2_d = mod1.concat(nom2);
        var apellido1_d = mod1.concat(ape1);
        var apellido2_d = mod1.concat(ape2);
        var apellidocasada = mod1.concat(apec);
        var nacimiento = mod1.concat(nac);
        var fecha_naci = mod1.concat(fec);
var edad2 = mod1.concat(edad);

        if($(documento_d).val() == 'Cédula' || $(documento_d).val() == 'Pasaporte'){ 
            $(ced).parents(".part-box").show();
        }else {
            $(ced).parents(".part-box").hide();
        }


        if ($(documento_d).val() == ''){
            $(documento_d).parents(".section-box").hide();
        }else{
            $(documento_d).parents(".section-box").show();
        }
            
        if($(documento_d).val() == 'Pasaporte'){
            $(nombre1_d).removeAttr("disabled");
            $(nombre2_d).removeAttr("disabled");
            $(apellido1_d).removeAttr("disabled");
            $(apellido2_d).removeAttr("disabled");
            $(apellidocasada).removeAttr("disabled");
            $(nacimiento).removeAttr("disabled");
            $(fecha_naci).removeAttr("disabled");
 $(edad2).removeAttr("disabled");

        }

//        if($(documento_d).val() == 'Cédula'){
//            if($(nombre2_d).val() == ''){
//                $(nombre2_d).removeAttr("disabled");
//            }else{
//                $(nombre2_d).attr("disabled","disabled");
//            }
//
//            if($(apellido2_d).val() == ''){
//                $(apellido2_d).removeAttr("disabled");
//            }else{
//                $(apellido2_d).attr("disabled","disabled");
//            }
//        }
//
       $(documento_d).parents(".section-box").next().hide();

    });
});




$(document).ready(function(){
$.each( $('[id*=datos_del_titular_es_persona_juridica_]'), function(index, campo) {
        
    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
      pos = (this.id).match(/_instance_[\d]/);
    }
    //alert(pos);
    var mod1 = "#field_datos_del_titular_es_persona_juridica";
    var mod2 = "_datos_de_la_empresa_ruc";
    var tipoDocRuc = "_datos_de_la_empresa_tipo_documento";
    var direccion = "_direccion_pais";

    var mod3 = mod1.concat(pos);
    var dato = mod3.concat(mod2);
    var tipoDocuRuc = mod3.concat(tipoDocRuc);
    var dire = mod3.concat(direccion);

        //alert(dato);
    if($(tipoDocuRuc).val() == 'RUC'){ 
        $(dato).parents(".part-box").show();
        $(dire).parents(".part-box").show();
    }else {
        $(dato).parents(".part-box").hide();
        $(dire).parents(".part-box").hide();
    }


    if ($(tipoDocuRuc).val() == ''){
            $(tipoDocuRuc).parents(".section-box").hide();
        }else{
            $(tipoDocuRuc).parents(".section-box").show();
    }
 
    $(tipoDocuRuc).parents(".section-box").next().hide()

  });
 
}); 


$(document).ready(function(){
    $.each( $('[id*=datos_del_autor_es_persona_natural_]'), function(index, campo) {
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }   

        var autor = "#field_datos_del_autor_es_persona_natural";
        //  var parte = "_datos_de_la_persona";
        var mod1 = autor.concat(pos);
        //var mod2 = mod1.concat(parte);

        var seu = "_seudonimo_indique_seudonimo";
        var seudonimo = mod1.concat(seu);

        if ($(seudonimo).val() == ''){
            $(seudonimo).parents(".field-box").hide();
        }
    });
});

/////Validación seudonimo

$( function() {
 $(document).ready(function(){ 
      $( ":checkbox" ).click(function(event){
            if ((this.name).match(/datos_del_autor_es_persona_natural_instance_/)){
                var pos = (this.name).match(/_instance_[\d][\d]/);
                if (pos == null){
                  pos = (this.name).match(/_instance_[\d]/);
                }
                name1 = "#field_datos_del_autor_es_persona_natural";
                name2 = name1.concat(pos);
                name3 = "_seudonimo_indique_seudonimo";
                name4 = name2.concat(name3);

                $(this).each(function(){
                    if (this.checked) {
                         var dato = $(this).val();
                         
                         if(dato == 'Seudónimo'){
                             //$(name4).removeAttr("disabled");
                             $(name4).parents(".field-box").show();
                         }
                     
                     }
                    if (!this.checked) {
                         var dato = $(this).val();
                         
                         if(dato == 'Seudónimo'){
                          $(name4).val('');
                          //$(name4).attr("disabled","disabled");
                          $(name4).parents(".field-box").hide();
                         }
                    }  
                 });
            }
      });   
  });
});
    STEPAJAXCODE
  end
            
