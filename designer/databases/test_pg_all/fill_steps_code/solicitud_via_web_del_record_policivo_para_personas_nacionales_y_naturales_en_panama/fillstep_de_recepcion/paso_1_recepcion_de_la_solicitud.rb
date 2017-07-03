
  class Paso1RecepcionDeLaSolicitud < TemplateCode::Step

    on_becoming do
      _idagente = @task["agent_id"].to_s

result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?agent_id=' + "#{_idagente}" + '&include_all=true').parsed_response
_hash = result["hash"]
_agente = _hash["response"]

form_data.set("recibido_por.datos_del_funcionario_generico.usuario", _agente["name"])
form_data.set("recibido_vu.datos_del_funcionario_generico.usuario", _agente["name"])
    end

    on_transition do
      (1..20).each do |_num|

	tipo_docu_titular = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.tipo_de_documento")
	nro_docu_titular = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte")
	#LG: SALE DEL CICLO CUANDO CONSIGUE LA PRIMERA INSTANCIA VACIA
	break if nro_docu_titular.blank?

	_existe = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.campo_data")
	if (_existe != "Titular existe en DIJ") && (tipo_docu_titular == "Cedula")
	    fechaNacimiento = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.fecha_de_nacimiento"),
	    sexo = ""
	    nacionalidad = ""
	    apellidoDeCasada = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada")
	    primerNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre")
	    segundoNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre")
	    apellidoPaterno = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido")
	    apellidoMaterno = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido")
	    primerNombrePadre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_del_padre.primer_nombre")
	    segundoNombrePadre = ""
	    apellidoPaternoPadre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_del_padre.primer_apellido")
	    apellidoMaternoPadre = ""
	    primerNombreMadre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.primer_nombre")
	    segundoNombreMadre = ""
	    apellidoPaternoMadre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.primer_apellido")
	    apellidoMaternoMadre = ""
	    direccion = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.direccion")
		#result = WebserviceConsumer.get( '/service/bdin_dij_record_policivo/call.json?method=set_datos_ciudadano&cedula=' + "#{nro_docu_titular}&pasaporte=#{nro_docu_titular}&fechaNacimiento=#{fechaNacimiento}&sexo=#{sexo}&nacionalidad=#{nacionalidad}&apellidoDeCasada=#{apellidoDeCasada}&primerNombre=#{primerNombre}&segundoNombre=#{segundoNombre}&apellidoPaterno=#{apellidoPaterno}&apellidoMaterno=#{apellidoMaterno}&primerNombrePadre=#{primerNombrePadre}&segundoNombrePadre=#{segundoNombrePadre}&apellidoPaternoPadre=#{apellidoPaternoPadre}&apellidoMaternoPadre=#{apellidoMaternoPadre}&primerNombreMadre=#{primerNombreMadre}&segundoNombreMadre=#{segundoNombreMadre}&apellidoPaternoMadre=#{apellidoPaternoMadre}&apellidoMaternoMadre=#{apellidoMaternoMadre}&direccion=#{direccion}").parsed_response
	end
end


_obs = form_data.get("recibido_gaip.datos_del_funcionario_generico.observaciones")
if _obs.blank?
	_obs = form_data.get("recibido_vu.datos_del_funcionario_generico.observaciones")
end

_eval = form_data.get("recibido_gaip.datos_del_funcionario_generico.evaluacion")
if _eval.blank?
	_eval = form_data.get("recibido_vu.datos_del_funcionario_generico.evaluacion_ok_reparo")
end


if (_eval =="REPARO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del reparo en el campo (Observación). "
end

if (_eval =="RECHAZO" and _obs.blank?) 
	transition_errors << "Debe indicar el motivo del rechazo en el campo (Observación). "
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      ////Validación para ocultar seccion de confirmación si y motivo de solicitud
$(document).ready(function(){
  function ocultar(){
    var valor3 = $('input[name="[field][tipo_de_persona_dij_es_titular_o_no_si_no]"]:checked').val();
  
    if($(valor3).html() == "SÍ"){
       $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().hide();
    
    }
  }
  ocultar();
});


///////////////////////////////////////////////// tipo pasaporte = extranjero

$.each( $('[id*=field_datos_del_titular_rp_]'), function(index, campo) {

  ocultarcampos(this.value,this.id);

  if ($(campo).attr('id').match(/datos_basicos_de_persona_natural_tipo_de_documento/)) {
    $(campo).attr('onchange', 'ocultarcampos(this.value,this.id);')
  }
});

function ocultarcampos(valorcampo, idcampo) {
  var coincide   = idcampo.match(/[\d]_datos_basicos_de_persona_natural_tipo_de_documento/);
  var pos      = "";
  if (coincide != undefined) {
    pos = coincide[0].split('_');

    var inicioRuta   = "#field_datos_del_titular_rp_instance_";
    var campoTipoDoc = "_datos_basicos_de_persona_natural_tipo_de_documento";
    var campoTipoNac = "_datos_basicos_de_persona_natural_tipo_de_nacionalidad";
    var campoNac   = "_datos_basicos_de_persona_natural_nacionalidad";

    var nacionalidad = inicioRuta + pos[0] + campoNac;//#field_datos_del_titular_rp_instance_x_datos_basicos_de_persona_natural_nacionalidad
    var tipoNac    = inicioRuta + pos[0] + campoTipoNac;//#field_datos_del_titular_rp_instance_x_datos_basicos_de_persona_natural_tipo_de_nacionalidad
    var tidco = inicioRuta + pos[0] + campoTipoDoc;
    
    if ($(tidco).html() == "Cedula"){
        $(nacionalidad).parent().parent().hide();
        $(tipoNac).parent().parent().show();
        $(tipoNac).html("Nacional");
    } else if ($(tidco).html() == "Pasaporte") {
      $(tipoNac).parent().parent().hide();
      $(nacionalidad).html("Extranjero");
      $(nacionalidad).parent().parent().show();
    }
  }
}

////////////////////// Al seleccionar que no se tiene version en fisico deshabilitar firma del director
$(document).ready(function(){
   valor = $("#field_retiro_record_policivo_retiro_record_policivo_version_fisico");
    if ($(valor).html() == "NO") {
       $("#field_retiro_record_policivo_retiro_record_policivo_retiro_rp").parent().parent().hide();
       $("#field_retiro_record_policivo_retiro_record_policivo_retiro_record_policivo").parent().parent().hide();
       $("#field_retiro_record_policivo_firma_director_si_no").parents(".part-box").hide();
    }
});


///////////////////// Ocultar botones agregar eliminar

$(document).ready(function(){
$.each( $('[id*=datos_del_titular_rp_]'), function(index, campo) {
  
 var pos = (this.id).match(/_instance_[\d][\d]/);
 if (pos == null){
   pos = (this.id).match(/_instance_[\d]/);
 }
 //alert(pos);
 var mod1 = "#field_datos_del_titular_rp";
 var mod2 = "_datos_basicos_de_persona_natural_cedula_pasaporte";
 var mod3 = mod1.concat(pos);
 var dato = mod3.concat(mod2);
 $(dato).parents(".section-box").next().hide();
  });
});

///////////////////// Ocultar secciones vacias
$(document).ready(function(){
  $.each( $('[id*=datos_del_titular_rp_]'), function(index, campo) {  
    var pos = (this.id).match(/_instance_[\d][\d]/);
    if (pos == null){
      pos = (this.id).match(/_instance_[\d]/);
    }
    var InicioRuta = "#field_datos_del_titular_rp";
    var NroDoc = "_datos_basicos_de_persona_natural_cedula_pasaporte";
    var coincide = InicioRuta.concat(pos);
    var doc = coincide.concat(NroDoc);
  
    if($(doc).html() != ''){
     $(doc).parents(".section-box").show();
    }
  });
});

$(document).ready(function(){
  tipo_de_solicitante = $("#field_tipo_de_persona_dij_tipo_de_solicitante_juridico_tipo_de_solicitante_juridico");
  provincia = $("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista");
  motivo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad");
  tipo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad");
$( function() {
if ($(tipo_de_solicitante).html() == "MINREX") {
        $("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("Panamá");
        provincia.attr("disabled","disabled");
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().show();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().show();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().hide();
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').val('');
      } else if ($(tipo_de_solicitante).html() == "Autoridades") {
        //$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("");
        //provincia.removeAttr("disabled","disabled");
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().show();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().show();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
        // $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
      }
      if ($(motivo_auto).html() == "Otros") {
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().show();
      }else{
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
      }
      if ($(tipo_auto).html() == "Otros") {
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().show();
      } else{
        $('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
      }
  });
});
    STEPAJAXCODE
  end
            
