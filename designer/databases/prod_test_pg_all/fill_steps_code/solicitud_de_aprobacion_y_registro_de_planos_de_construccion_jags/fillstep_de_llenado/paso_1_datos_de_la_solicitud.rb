
  class Paso1DatosDeLaSolicitud < TemplateCode::Step

    on_becoming do
      #:::: Por defecto el tipo de solicitante OnBecoming - PASO 1 :::::#
form_data.set("datos_del_solicitante_natural.datos_del_solicitante.tipo_de_solicitante_tex", "Profesional responsable")

#:::: Nombres de entidades AV
_app_id = @application["id"].to_s
result = WebserviceConsumer.get("/preconfigured_services/get_application_config.json?id=#{_app_id}").parsed_response
entidades=[]
result["response"]["EntidadesEvaluadoras"].each do |key, entidad_data|
	next unless key =~ /entidades_instance/ 
	entidades << entidad_data["evaluacion_de_la_entidad"]  
end

#:::: Inicializacion de datos del agente - LG
_idagente = @task["agent_id"].to_s
result = WebserviceConsumer.get( "/preconfigured_services/get_user_info.xml?agent_id=#{_idagente}&include_all=true").parsed_response
_agente = result["hash"]["response"]
_siglas = @task.name.split(' ').last.upcase rescue ""
fecha_inicio = Date.today

entidades.each_index do |i|
	if entidades[i] && (entidades[i]["siglas"].to_s.upcase == _siglas)
		_nombre = _nombref = entidades[i]["entidad"]
		form_data.set("entidad_evaluadora_revisiones.entidad_evaluadora_#{i}.nombre_de_la_entidad", _nombre)
	end
end


#::::: Obtener numero consecutivo y crear consecutivo de tramite
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
if form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud").blank?
  result = WebserviceConsumer.get( '/consecutive/generador_planos/generate.json').parsed_response
  _consecutivo = result["response"]
  _consecutivo = "#{@application["id"]}-#{_consecutivo["value"]}"
  form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
end


#::::: Datos del Solicitante Natural
if @owner["kind_of_user_type"] == "NaturalPerson"
	if @owner["natural_person_type"]=="national_citizen"
		form_data.set("datos_del_solicitante_natural.datos_del_solicitante.numero_de_identificacion",@owner["national_id"])
		form_data.set("datos_del_solicitante_natural.datos_del_solicitante.tipo_de_identificacion", "Cédula")
	else
		form_data.set("datos_del_solicitante_natural.datos_del_solicitante.numero_de_identificacion",@owner["passport"])
		form_data.set("datos_del_solicitante_natural.datos_del_solicitante.tipo_de_identificacion", "Pasaporte")
	end	
	form_data.set("datos_del_solicitante_natural.nombre_completo.primer_nombre", @owner["first_name"])
	form_data.set("datos_del_solicitante_natural.nombre_completo.segundo_nombre", @owner["second_name"])
	form_data.set("datos_del_solicitante_natural.nombre_completo.primer_apellido", @owner["last_name"])
	form_data.set("datos_del_solicitante_natural.nombre_completo.segundo_apellido", @owner["second_last_name"])
	form_data.set("datos_del_solicitante_natural.nombre_completo.apellido_de_casada", @owner["married_name"])
	form_data.set("datos_del_solicitante_natural.datos_del_solicitante.numero_de_telefono", @owner["fixed_number"])
	form_data.set("datos_del_solicitante_natural.datos_del_solicitante.correo_electronico", @owner["email"])

	#::::: Usado para print design
	nombre_completo= "#{@owner["first_name"]} "+"#{@owner["second_name"]} "+"#{@owner["last_name"]} "+"#{@owner["second_last_name"]} "+"#{@owner["married_name"]}"
	form_data.set("datos_del_solicitante_natural.nombre_completo.nombre_completo",nombre_completo.squish)
else
	#:::: Datos del Solicitante Jurídico
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.tipo_de_solicitante_tex", "Profesional responsable")
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.tipo_de_identificacion", "RUC")
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.numero_de_identificacion", @owner["tax_id"])
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.nombre", @owner["name"])
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.numero_de_telefono", @owner["fixed_number"])
	form_data.set("datos_del_solicitante_juridico.datos_del_solicitante.correo_electronico", @owner["email"])
end

#:::: ANEXOS
tarea = (@task["name"].to_s).split(' ')
tarea1 = tarea.first.downcase
form_data.set("anexos_002_aprobacion_de_planos_2.parte_oculta.oculto",tarea1)

#:::: tomar nombre de la tarea
name_words = (@task["name"].to_s.downcase).split(' ')
nombre_tarea = name_words.first
#tarea="false"
if(nombre_tarea != "reparar")
	tarea ="true"
	#::::: Setearle el nombre de la tarea para hacer validación de habilitar o no campos vacíos
	form_data.set("datos_del_solicitante_natural.nombre_completo.oculto",tarea)
	form_data.set("datos_generales_del_proyecto.datos_generales_del_proyecto.oculto",tarea)
	form_data.set("datos_del_co_participante_instance_1.nombre_completo.oculto",tarea)
else
	tarea ="false"
	form_data.set("datos_del_solicitante_natural.nombre_completo.oculto",tarea)
	form_data.set("datos_generales_del_proyecto.datos_generales_del_proyecto.oculto",tarea)
	form_data.set("datos_del_co_participante_instance_1.nombre_completo.oculto",tarea)
end

#::::::::::::::DV: Integración Obtener nro de documento Datos del CoParticipante::::::::::::::#
(1..5).each do |_num|
	nro_documento_d = form_data.get("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.numero_de_identificacion")
	form_data.set("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.numero_de_identificacion", nro_documento_d)
    nro_doc_d = form_data.get("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.numero_de_identificacion")
	form_data.set("datos_del_co_participante_instance_#{_num}.datos_del_co_participante.doc_oculto",nro_doc_d)	
end
    end

    on_transition do
      #::: SETEANDO DATOS DEL SOLICITANTE: QUIEN INICIA EL TRÁMITE ES DIFUNTO ON TRANSITION PASO 1
if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
	numdoc = form_data.get("datos_del_solicitante_natural.datos_del_solicitante.numero_de_identificacion")
	result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
	datos = result["response"]
	if datos.blank? 
		transition_errors << "La Cédula del solicitante no fue encontrada. Por favor, verifique." 
	else			
		difunto = datos["cod_mensaje"]
		if (difunto == "534")
			transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{numdoc} del Solicitante, corresponde a un ciudadano Difunto."
		end
	end
end

#:::: Datos de los CO-PARTICIPANTES, Invocación al servicio de Tribunal Electoral ::::#
#:::: Validación para los datos de los CO-PARTICIPANTES ::::#
_hay_un_cp = false
(1..5).each do |x|
	instance_x = "_instance_#{x}"
	tipo_de_identificacion = form_data.get("datos_del_co_participante#{instance_x}.datos_del_co_participante.tipo_de_identificacion")
	nro_documento = form_data.get("datos_del_co_participante#{instance_x}.datos_del_co_participante.numero_de_identificacion")
	#form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.tipoc",tipo_de_identificacion)
	#::::: tomar nombre de la tarea :::::#
	name_words = (@task["name"].to_s.downcase).split(' ')
	nombre_tarea = name_words.first
	unless nro_documento.blank?
		_hay_un_cp = true #:::: Variable para saber que hay al menos un co-participante ::::#
		if tipo_de_identificacion == "Cédula"
			result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}")).parsed_response
			_cp = result["response"]
			if !_cp.blank?
				form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.numero_de_identificacion",nro_documento)
				#form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.idoneidad", _cp["data"])
				#form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.especialidad_profesional", _cp["data"])
				#transition_errors << "Campo = datos_del_co_participante"+_str+".nombre_completo.segundo_nombre y dato = "+_cp["primerNombre"]
				form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.primer_nombre", _cp["primerNombre"])
				segundoNombre = (_cp["segundoNombre"] == "ND") ? "" : _cp["segundoNombre"]
				form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.segundo_nombre",segundoNombre)
				form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.primer_apellido", _cp["primerApellido"])
				segundoApell = (_cp["segundoApellido"] == "ND") ? "" : _cp["segundoApellido"]
				form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.segundo_apellido",segundoApell)
				ApellCasada = (_cp["apellidoCasada"] == "ND") ? "" : _cp["apellidoCasada"]
				form_data.set("datos_del_co_participante#{instance_x}.nombre_completo.apellido_de_casada",ApellCasada)
				difunto = _cp["cod_mensaje"]
				if (difunto == "534")
					transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{nro_documento} del Co-Participante #{x} corresponde a un ciudadano Difunto. Por favor, verifique."
				end
			else
				transition_errors << "Los datos del co-participante número #{x} no fueron encontrados. Por favor, verifique."
			end
		else
			if(nombre_tarea != "reparar")
				form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.idoneidad","")
				form_data.set("datos_del_co_participante#{instance_x}.datos_del_co_participante.especialidad_profesional","")
			end
		end
	end
end
unless _hay_un_cp
	transition_errors << "Debe ingresar al menos un (1) co-participante de la obra, por favor verifique."
end

#::::: Datos de la FINCA Invocación al servicio de Registro Publico :::::#
(1..10).each do |x|
	nro_finca = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.numero_de_finca")
	cod_ubi = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.cod_ubicacion")
	tipo_p = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.tipo_propiedad")
	tipo_nro = form_data.get("datos_de_la_finca_instance_#{x}.datos_de_finca.numero_de_registro")
	#:::: tomar nombre de la tarea ::::#
	name_word = (@task["name"].to_s.downcase).split(' ')
	nombre_task = name_word.first
	if (nombre_task != "reparo" && nombre_task !="reparar")
		if (!nro_finca.blank? && !cod_ubi.blank? && !tipo_p.blank?)
			result=""
			#:::: Consultar servicio por nro de finca o cédula catastral :::::#
			if tipo_nro == "Número de Finca"
				result = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_tupea/where.json?finca=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}"), timeout: 460).parsed_response
			else
				result = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_tupea/where.json?cedula_catastral=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}"), timeout: 460).parsed_response
			end
			if (result["response"].nil? || result["response"].blank?)
				transition_errors << "Los datos de la finca #{x}, no fueron encontrados, por favor verifique."
				break
			else
				finca = result["response"][0]
				#:::: Información de la Finca :::::#
				#::: form_data.set("datos_de_la_finca.datos_de_finca.tipo_de_propiedad_tex",finca["tipoPropiedad"])
				form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.folio",finca["folio_libro_madre"])
				form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.tomo",finca["rollo-tomo"])
				#::: form_data.set("datos_de_la_finca.datos_de_finca.numero_de_plano",finca["nro_plano"])
				form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.valor_de_la_finca",finca["valor_finca"])
				#::: form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.superficie",finca["superficie"])
				#::: form_data.set("datos_de_la_finca.datos_de_finca.linderos_y_medidas",finca["linderos_medidas"])
				#::: form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.numero_de_plano_catastral", finca["nro_plano"])
			end
		end
		if (((!nro_finca.blank? && (cod_ubi.blank? || tipo_p.blank?)) || ((nro_finca.blank? || cod_ubi.blank?) && !tipo_p.blank?)) || (!cod_ubi.blank? && (nro_finca.blank? || tipo_p.blank?)))
			transition_errors << "Los datos de la finca #{x}, estan incompletos. Por favor llenar todos los datos solicitados."
		end
	else
		#:::: Si la tarea es de REPARO y se cambian los parametros de consultas de la finca se ejecuta este código - Consultar servicio por nro de finca o cédula catastral :::::#
		if tipo_nro == "Número de Finca"
			resulta = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_tupea/where.json?finca=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}"), timeout: 460).parsed_response
		else
			resulta = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_tupea/where.json?cedula_catastral=' + "#{nro_finca}" + '&codUbicacion=' + "#{cod_ubi}" + '&tipoPropiedad=' + "#{tipo_p}"), timeout: 460).parsed_response
		end
		if ((nombre_task == "reparo" || nombre_task =="reparar") && (result["response"].nil? || result["response"].blank?))
			transition_errors << "Los datos de la finca #{x}, no fueron encontrados, por favor verifique."
			break
		else
			finca = resulta["response"][0]
			#::::: Información de la Finca ::::#
			form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.folio",finca["folio_libro_madre"])
			form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.tomo",finca["rollo-tomo"])
			form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.valor_de_la_finca",finca["valor_finca"])
			#:::: form_data.set("datos_de_la_finca_instance_#{x}.datos_de_finca.superficie",finca["superficie"])
		end
	end
end

#:::: Validar que exista al menos UN propietario de la obra ::::#
propietarios = []
propietarios << form_data.get("datos_del_solicitante_natural.datos_del_solicitante.tipo_de_solicitante")
propietarios << form_data.get("datos_del_solicitante_juridico.datos_del_solicitante.tipo_de_solicitante")
(1..5).each do |i|
	propietarios << form_data.get("datos_del_co_participante_instance_#{i}.datos_del_co_participante.tipo_de_co_participante")
end
unless propietarios.any? {|p| p == "Propietario"} 
	transition_errors << "Debe existir al menos un (1) propietario de la obra, por favor verifique."
end

#:::: Validar que ingrese los datos generales de la solicitud si es necesario y esta vacio ::::#
tipo_de_solicitud_municipio = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.tipo_de_solicitud_municipio")
etapa_de_construccion = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.etapa_de_construccion")
tipo_de_plano = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.tipo_de_plano")
no_del_plano_original = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.no_del_plano_original")
no_de_anteproyecto = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.no_de_anteproyecto")
fecha_de_aprobacion_de_anteproyecto = form_data.get("datos_generales_de_la_solicitud.datos_generales_de_la_solicitud.fecha_de_aprobacion_de_anteproyecto")
if 	(tipo_de_solicitud_municipio == "Re-aprobación") || (etapa_de_construccion != "Plano completo") || (tipo_de_plano == "Plano Adicional de Edificación") 
	if no_del_plano_original.blank?
		transition_errors << "Debe introducir el número del plano original, por favor verifique."
	end
end
if (tipo_de_plano == "Plano Original de Edificación") 
	if no_de_anteproyecto.blank?
		transition_errors << "Debe introducir el número de anteproyecto."
	end
	if fecha_de_aprobacion_de_anteproyecto.blank?
		transition_errors << "Debe seleccionar la fecha de aprobación del anteproyecto, por favor verifique."
	end
end

#:::: Validacion para servicio del MUPA -  Municipio de Panama / Validar solvencia de Persona Natural ::::#
#::: Comentado por solicitud de la AIG para fase 2 :::# No integrar el nro. de contribuyente

if @owner["kind_of_user_type"] == "NaturalPerson"
  _num_contribuyente_municipal = form_data.get("datos_del_solicitante_natural.datos_del_solicitante.numero_contribuyente_municipal_del_solicitante")
  result = WebserviceConsumer.get('/service/bdin_municipio_panama_psp/where.json?num_contribuyente_municipal=' + "#{_num_contribuyente_municipal}").parsed_response

  if result["response"].nil?
    transition_errors << "Los datos del contribuyente no fueron encontrados, por favor verifique."
  else
    _solvente = result["response"]["solvente"]
    if (_solvente != "true")
      transition_errors << "El contribuyente seleccionado no se encuentra en Paz y Salvo con el Municipio, por favor verifique sus datos e intente nuevamente. #{_solvente}"
    end
  end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //:::::::::::::Validaciones varias PASO 1::::::::::://
// DV:: Se agrego limpiar los campos al cambiar selección y ocultar de los datos generales de la solicitud
$(document).ready(function(){
	tipo_de_solicitante = $("#field_datos_del_solicitante_natural_datos_del_solicitante_tipo_de_solicitante_tex");
	tipo_de_solicitante.attr( 'value' , "Profesional responsable");
	////campos ocultos
	campo_oculto = $("#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_campo_oculto");
	no_plano_original = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_no_del_plano_original');	
	no_de_anteproyecto = $('#field_datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_no_de_anteproyecto');
	fecha_de_aprobacion_de_anteproyecto = $('input[name="[field][datos_generales_de_la_solicitud_datos_generales_de_la_solicitud_fecha_de_aprobacion_de_anteproyecto]"]');
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
	////Función para mostrar u ocultar campo nro de plano original	
	function set_no_plano_original() {
		if((etapa_de_construccion.val()=="") && (tipo_de_solicitud_municipio.val()!="Re-aprobación")){
			ocultar(no_plano_original);
		} 
		else if ((tipo_de_plano.val()== "Plano Adicional de Edificación") || (tipo_de_solicitud_municipio.val()=="Re-aprobación") || 
			(etapa_de_construccion.val()!= "Plano completo")) {
			mostrar(no_plano_original);
		}
		else{
			ocultar(no_plano_original);
			no_plano_original.val('');
		};
	};
	////ocultar campos por defecto
	campo_oculto.hide();
	$(no_plano_original).parent().parent().hide();
	$(no_de_anteproyecto).parent().parent().hide();
	$(fecha_de_aprobacion_de_anteproyecto).parent().parent().hide();

	////Funciones para los evetos changes de los campos de selección
	etapa_de_construccion.change(function() {
		set_no_plano_original();    
	});

	tipo_de_solicitud_municipio.change(function() {
		set_no_plano_original();
	});

	tipo_de_plano.change(function() {
		set_no_plano_original();
		if (tipo_de_plano.val() == "Plano Original de Edificación") {
			mostrar(no_de_anteproyecto);
			mostrar(fecha_de_aprobacion_de_anteproyecto);
		} else {
			ocultar(no_de_anteproyecto);
			ocultar(fecha_de_aprobacion_de_anteproyecto);
			no_de_anteproyecto.val('');
			fecha_de_aprobacion_de_anteproyecto.val('');
		};
	});

	////para no perder cambios en reapro y entre pasos
	if (tipo_de_plano.val() == "Plano Original de Edificación") {
		mostrar(no_de_anteproyecto);
		mostrar(fecha_de_aprobacion_de_anteproyecto);
	} else {
		ocultar(no_de_anteproyecto);
		ocultar(fecha_de_aprobacion_de_anteproyecto);
		fecha_de_aprobacion_de_anteproyecto.val('');
	};

	if((etapa_de_construccion.val()=="") && (tipo_de_solicitud_municipio.val()!="Re-aprobación")){
		ocultar(no_plano_original);
	} 
	else if ((tipo_de_plano.val()== "Plano Adicional de Edificación") || (tipo_de_solicitud_municipio.val()=="Re-aprobación") || 
		(etapa_de_construccion.val()!= "Plano completo")) {
		mostrar(no_plano_original);
	}
	else{
		ocultar(no_plano_original);
		no_plano_original.val('');
	};
});


$( function() {
	$(document).ready(function(){
		$("#field_mensajes_pago_mensaje_pendiente_texto_1").hide();
		$("#field_mensajes_pago_mensaje_pendiente_texto_2").hide();
	});
});

//:::::::::::::Validaciones varias PASO 1 Change para limpiar campos change de datos de la finca ::::::::::://
$(document).ready(function(){
	$.each( $('[id*=_datos_de_la_finca_]'), function(index, campo) {    
		var pos = (this.id).match(/_instance_[\d][\d]/);
		if (pos == null){
			pos = (this.id).match(/_instance_[\d]/);
		}
		var inicRuta 	= "#field_datos_de_la_finca";
		var NroReg 		= "_datos_de_finca_numero_de_registro";
		var NumFin 		= "_datos_de_finca_numero_de_finca";
		var CodUbic 	= "_datos_de_finca_cod_ubicacion";
		var TipProp 	= "_datos_de_finca_tipo_propiedad";
		var coincide 	= inicRuta.concat(pos);
		var NroReg2 	= coincide.concat(NroReg);
		var NumFin2 	= coincide.concat(NumFin);
		var CodUbic2 	= coincide.concat(CodUbic);
		var TipProp2 	= coincide.concat(TipProp);
		
		//::::::::: Change para limpiar campos ::::::://
		$(NroReg2).change(function(){
			NroReg2 = $(this).val();
			if(NroReg2 == ""){
				$(NumFin2).val("");
				$(CodUbic2).val("");
				$(TipProp2).val("");
			}
			if(NroReg2 == "Número de Finca"){
				$(NumFin2).val("");
				$(CodUbic2).val("");
				$(TipProp2).val("");
			}
			if(NroReg2 == "Cédula Catastral"){
				$(NumFin2).val("");
				$(CodUbic2).val("");
				$(TipProp2).val("");
			}
		}); 
	});
});

//:::::::::::::Validaciones varias PASO 1 Change para limpiar campos change de datos de la finca ::::::::::://
$( function() {
	$(document).ready(function(){
		$('input[name="[field][datos_del_co_participante_instance_1_datos_del_co_participante_tipo_de_identificacion]"]').change(function() {
			if ($('input[name="[field][datos_del_co_participante_instance_1_datos_del_co_participante_tipo_de_identificacion]"]:checked').val() == "Cédula"){
				$("#field_datos_del_co_participante_instance_1_datos_del_co_participante_numero_de_identificacion").val('');
			}else{
				$("#field_datos_del_co_participante_instance_1_datos_del_co_participante_numero_de_identificacion").val('');
			}  
		});
		$('input[name="[field][datos_del_co_participante_instance_2_datos_del_co_participante_tipo_de_identificacion]"]').change(function() {
			if ($('input[name="[field][datos_del_co_participante_instance_2_datos_del_co_participante_tipo_de_identificacion]"]:checked').val() == "Cédula"){
				$("#field_datos_del_co_participante_instance_2_datos_del_co_participante_numero_de_identificacion").val('');
			}else{
				$("#field_datos_del_co_participante_instance_2_datos_del_co_participante_numero_de_identificacion").val('');
			}  
		});
		$('input[name="[field][datos_del_co_participante_instance_3_datos_del_co_participante_tipo_de_identificacion]"]').change(function() {
			if ($('input[name="[field][datos_del_co_participante_instance_3_datos_del_co_participante_tipo_de_identificacion]"]:checked').val() == "Cédula"){
				$("#field_datos_del_co_participante_instance_3_datos_del_co_participante_numero_de_identificacion").val('');
			}else{
				$("#field_datos_del_co_participante_instance_3_datos_del_co_participante_numero_de_identificacion").val('');
			}  
		});
		$('input[name="[field][datos_del_co_participante_instance_4_datos_del_co_participante_tipo_de_identificacion]"]').change(function() {
			if ($('input[name="[field][datos_del_co_participante_instance_4_datos_del_co_participante_tipo_de_identificacion]"]:checked').val() == "Cédula"){
				$("#field_datos_del_co_participante_instance_4_datos_del_co_participante_numero_de_identificacion").val('');
			}else{
				$("#field_datos_del_co_participante_instance_4_datos_del_co_participante_numero_de_identificacion").val('');
			}  
		});
		$('input[name="[field][datos_del_co_participante_instance_5_datos_del_co_participante_tipo_de_identificacion]"]').change(function() {
			if ($('input[name="[field][datos_del_co_participante_instance_5_datos_del_co_participante_tipo_de_identificacion]"]:checked').val() == "Cédula"){
				$("#field_datos_del_co_participante_instance_5_datos_del_co_participante_numero_de_identificacion").val('');
			}else{
				$("#field_datos_del_co_participante_instance_5_datos_del_co_participante_numero_de_identificacion").val('');
			}  
		});
	});
});
    STEPAJAXCODE
  end
            
