
  class Paso1IngresarTipoDeSolicitanteYDeSolicitud < TemplateCode::Step

    on_becoming do
      #::::: Obtener numero consecutivo y crear consecutivo de tramite
form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
if form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud").blank?
  result = WebserviceConsumer.get( '/consecutive/generador_dij/generate.json').parsed_response
  consecutivo = result["response"]
  consecutivo = "#{@application["id"]}-"+"#{consecutivo["value"]}"
  form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",consecutivo)
end

### GENERAR CODIGO UNICO ###
#result_app = WebserviceConsumer.default_get( '/consecutive/codigo_unico_dij/generate.json').parsed_response
#_app = result_app["response"]
#_app = _app["value"]
#form_data.set("codigo_unico_dij.codigo_unico_dij.consecutivo",_app)

### SETEARLOS DATOS DEL DIRECTOR ### COMENTADO POR PRUEBAS 17/10/2014
#director = @config.route("Config P6.defaults100.rolname_id.nombre_director",".")
#form_data.set("director_dij.datos_del_funcionario_generico.usuario", director)

#_director= @config.route("Config P6.defaults100.rolname_id.nombre_director", ".")
#form_data.set("director_dij.datos_del_funcionario_generico.usuario2", _director)

#LG: SETEANDO DATOS DEL SOLICITANTE: QUIEN INICIA EL TRÁMITE
if @owner["kind_of_user_type"] == "NaturalPerson"
	#LG: AGREGADA VARIABLE numdoc
	numdoc = !@owner["national_id"].blank? ? @owner["national_id"] : @owner["passport"]

    form_data.set("tipo_de_persona_dij.es_titular_o_no.cedula", "#{numdoc}")
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.cedula_pasaporte", "#{numdoc}")
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.primer_nombre", @owner["first_name"])
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.segundo_nombre", @owner["second_name"])
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.primer_apellido", @owner["last_name"])
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.segundo_apellido", @owner["second_last_name"])
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.apellido_de_casada", @owner["married_name"])
	form_data.set("datos_del_propietario_tramite_natural.datos_de_ubicacion.direccion", @owner["full_address"])
	form_data.set("datos_del_propietario_tramite_natural.datos_de_ubicacion.numero_de_telefono", @owner["fixed_number"])
	form_data.set("datos_del_propietario_tramite_natural.datos_de_ubicacion.correo_electronico", @owner["email"])
	
	##LP: Setear motivo trabajo si en PN
	form_data.set("tipo_de_solicitud_dij.tipo_de_solicitud_dij.motivo_de_la_solicitud_dij","Trabajo")
	form_data.set("tipo_de_solicitud_dij.tipo_de_solicitud_dij.tipo_de_solicitud_dij","Laboral")

	## UTILIZADO PARA PRINT DESIGNS ###
	nombre = "#{@owner["first_name"]} "+"#{@owner["second_name"]} "+"#{@owner["last_name"]} "+"#{@owner["second_last_name"]} "+"#{@owner["married_name"]}"
	#LG: SE UTILIZA .squish PARA ELIMINAR LAS CADENAS EN BLANCO DEL LA VARIABLE nombre
	form_data.set("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.nombre_completo", nombre.squish)
else
	ruc = @owner["tax_id"]
	form_data.set("datos_del_propietario_tramite_juridico.datos_persona_juridica.ruc",ruc)
	form_data.set("datos_del_propietario_tramite_juridico.datos_persona_juridica.nombre",@owner["name"])
	form_data.set("datos_del_propietario_tramite_juridico.datos_de_ubicacion.numero_de_telefono",@owner["fixed_number"])
	form_data.set("datos_del_propietario_tramite_juridico.datos_de_ubicacion.correo_electronico",@owner["email"])
	form_data.set("datos_del_propietario_tramite_juridico.datos_de_ubicacion.direccion",@owner["full_address"])
end

#LG: SETEANDO DATOS DEL PROPIETARIO: DUEÑO DEL TRÁMITE - A NOMBRE DE QUIEN SE INICIA EL TRÁMITE
idpersona = @application["person_id"].to_s
result = WebserviceConsumer.get( '/preconfigured_services/get_user_info.xml?person_id=' + "#{idpersona}&include_all=true").parsed_response
hash = result["hash"]
persona = hash["response"]

	form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.cedula_pasaporte", persona["person_gov_id_number"])
	form_data.set("datos_del_solicitante.datos_basicos_de_persona_natural.nombre_completo", persona["name"])
	form_data.set("datos_del_solicitante.datos_de_ubicacion.direccion", persona["full_address"])
	form_data.set("datos_del_solicitante.datos_de_ubicacion.numero_de_telefono", persona["fixed_number"])
	form_data.set("datos_del_solicitante.datos_de_ubicacion.correo_electronico", persona["email"])

#::::::::::::::DV: Integración guardar nro de documento Datos de los Titulares::::::::::::::#
_titular = form_data.get("tipo_de_persona_dij.es_titular_o_no.si_no")
if _titular == "SÍ"
	nro_documento_t = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte")
	form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte", nro_documento_t)
	nro_doc_t = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte")
	form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.doc_oculto",nro_doc_t)	
else 
	(1..20).each do |_num|
		nro_documento_d = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte")
		form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte", nro_documento_d)
		nro_doc_d = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte")
		form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.doc_oculto",nro_doc_d)
	end	
end

    end

    on_transition do
      #::: DV: SETEANDO DATOS DEL SOLICITANTE: QUIEN INICIA EL TRÁMITE ES DIFUNTO ON TRANSITION PASO 1
if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
  numdoc = form_data.get("datos_del_propietario_tramite_natural.datos_basicos_de_persona_natural.cedula_pasaporte")
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

#::: DV: COMPROBAR LA CEDULA DEL REPRESENTANTE :::#
representante = form_data.get("datos_del_solicitante.datos_basicos_de_persona_natural.cedula_pasaporte")   
_person = @application["person_id"]
_owner = @application["owner_person_id"]
if _person != _owner
  result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{representante}")).parsed_response
  datosre = result["response"]
  if datosre.blank? 
    transition_errors << "La Cédula del representante no fue encontrada. Por favor, verifique." 
  else      
    difuntore = datosre["cod_mensaje"]
    if (difuntore == "534")
      transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{representante} del Representante, corresponde a un ciudadano Difunto."
    end
  end
end


#::::: UN SOLO TITULAR - OnTransition Paso 1:::::#
_titular = form_data.get("tipo_de_persona_dij.es_titular_o_no.si_no")
if _titular == "SÍ" 
  if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{@owner["national_id"]}")).parsed_response
    titular = result["response"]
    if titular.blank?     
      transition_errors << "Los datos del Titular no fueron encontrados, por favor verifique."
    else
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_documento","Cedula")
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte",@owner["national_id"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_nombre",titular["primerNombre"])
      segundoNombre = (titular["segundoNombre"] == "ND") ? "" : titular["segundoNombre"]
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_nombre",segundoNombre)
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_apellido",titular["primerApellido"])
      segundoApell = (titular["segundoApellido"] == "ND") ? "" : titular["segundoApellido"]
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_apellido",segundoApell)
      ApellCasada = (titular["apellidoCasada"] == "ND") ? "" : titular["apellidoCasada"]
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.apellido_de_casada",ApellCasada)
      sexo = ((titular["sexo"] == "F") || (titular["sexo"] == "female")) ? "Femenino" : "Masculino"
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.sexo",sexo)
      form_data.set("datos_del_titular_rp_instance_1.datos_de_ubicacion.direccion",titular["direccionNacimiento"])
      difunto = titular["cod_mensaje"]
      if (difunto == "534")
        transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{nro_documento} del Titular corresponde a un ciudadano Difunto. Por favor, verifique."
      end
      form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.documento_hijo",titular["cedula"])
      form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.primer_nombre",titular["primerNombrePadre"])
      form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.segundo_nombre",titular["segundoNombrePadre"])
      form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.primer_apellido",titular["apellidoPaternoPadre"])
      form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.documento_hijo",titular["cedula"])
      form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.primer_nombre",titular["primerNombreMadre"])
      form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.segundo_nombre",titular["segundoNombreMadre"])
      form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.primer_apellido",titular["apellidoPaternoMadre"])
      # CONVERSION FECHA DE NACIEMIENTO #
      fecha = titular["fechaNacimiento"]
      fecha_na = Time.parse(fecha).strftime("%d-%m-%Y")
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_na)
      # CALCULA EDAD #
      edadt = ((Date.today - fecha.to_date).to_f / 365).to_i
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.edad",edadt)

      tipo_ddocument = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_documento")
      nro_ddocument = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte")
    
    #LG: VALIDAR SI EL TITULAR EXISTE EN DIJ, SE SETEA RESULTADO EN campo_data PARA VALIDACIÓN EN RECEPCIÓN
    tipodDoc = (tipo_ddocument == "Cedula") ? "001" : "002"
    resultadoDijj = WebserviceConsumer.get( '/service/bdin_dij_record_policivo/call.json?method=get_record_policivo&tipoDocumento=' + "#{tipodDoc}&nroDocumento=#{nro_ddocument}").parsed_response
    personaDijj = resultadoDijj["response"]
    errorDeDijj = personaDijj["error"]
    existeEnDijj = "Dato no existe"
    if !errorDeDijj.blank?
        if tipo_ddocument == "Cedula"
          #existeEnDijj = "Titular no existe en DIJ, se guardará la información."
          transition_errors << "Usted no se encuentra registrado en la DIJ. Acuda a la sede más cercana a registrarse para poder continuar el trámite."
        else
          #existeEnDijj = "Pasaporte no existe en DIJ, deberá registrarse de manera manual."
          transition_errors << "Usted no se encuentra registrado en la DIJ. Acuda a la sede más cercana a registrarse para poder continuar el trámite."
        end
        
    else
        existeEnDijj = "Titular existe en DIJ"
    end
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.campo_data",existeEnDijj)
               
    #LG: VALIDAR SI EL TITULAR EXISTE EN PSP, SI NO EXISTE SE SOLICITA AUTORIZACIÓN PARA SOLICITUD DE RECORD POLICIVO
    # => Y SE SETEA EN campo_psp PARA VALIDACIÓN EN RECEPCIÓN
    tipodDocumentoPsp = (tipo_ddocument == "Cedula") ? "national_id" : "passport"
    resultadoPspp = WebserviceConsumer.get( '/service/ws_get_person_data_psp/titular.json?tipoDocumento=' + "#{tipodDocumentoPsp}&nroDocumento=#{nro_ddocument}").parsed_response
    personaPsp = resultadoPspp["response"]
    existeEnPspp = "Dato no existe en PEL"
    if personaPsp.blank?
      existeEnPspp = "Titular no existe en PEL, debe adjuntar Autorización."
    else
      existeEnPspp = "Titular existe en PEL"
    end
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.campo_psp",existeEnPspp)

    #:::: USADO PARA PRINT DESIGN
    primerNombret = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_nombre")
    segundoNombret = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_nombre")
    primerApellidot = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_apellido")
    segundoApellidot = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_apellido")
    apellidoCasadat = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.apellido_de_casada")
    nombreCompletot = "#{primerNombret} #{segundoNombret} #{primerApellidot} #{segundoApellidot} #{apellidoCasadat}"
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.nombre_completo",nombreCompletot.squish)

    #:::: CODIGO UNICO PARA TITULAR
      co_result = WebserviceConsumer.default_get( '/consecutive/codigo_unico_dij/generate.json').parsed_response
      cod_unico = co_result["response"]
      cod_unico = cod_unico["value"]
      form_data.set("datos_del_titular_rp_instance_1.codigo_unico_dij.codigo_unico",cod_unico)

      #:::: GENERA CONSECUTIVO INDIVIDUAL
        form_data.set("datos_del_titular_rp_instance_1.datos_de_solicitud.fecha_de_solicitud",@application["created_at"])
      result_cons = WebserviceConsumer.default_get( '/consecutive/generador_dij_f2/generate.json').parsed_response
    consecut = result_cons["response"]
    consecut = "#{@application["id"]}-"+"#{consecut["value"]}"
    form_data.set("datos_del_titular_rp_instance_1.datos_de_solicitud.numero_de_solicitud",consecut)
    end
  else
    if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "foreign_citizen"))
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_documento","Pasaporte")
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte",@owner["passport"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_nombre",@owner["first_name"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_nombre",@owner["second_name"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_apellido",@owner["last_name"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_apellido",@owner["second_last_name"])
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.apellido_de_casada",@owner["married_name"])
      sexo = ((@owner["gender"] == "female")) ? "Femenino" : "Masculino"
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.sexo",sexo)
      form_data.set("datos_del_titular_rp_instance_1.datos_de_ubicacion.direccion",@owner["full_address"])
      form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.documento_hijo",@owner["passport"])
      #form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.primer_nombre","")
      #form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.segundo_nombre","")
      #form_data.set("datos_del_titular_rp_instance_1.datos_del_padre.primer_apellido","")
      form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.documento_hijo",@owner["passport"])
      #form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.primer_nombre","")
      #form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.segundo_nombre","")
      #form_data.set("datos_del_titular_rp_instance_1.datos_de_la_madre.primer_apellido","")
             # CONVERSION FECHA DE NACIEMIENTO #
      fecha = @owner["birthday"]
      fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_n)
      # CALCULA EDAD #
      edad = ((Date.today - fecha.to_date).to_f / 365).to_i
      form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.edad",edad)
    end
  end
    tipo_ddocument = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.tipo_de_documento")
    nro_ddocument = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.cedula_pasaporte")
    
    #LG: VALIDAR SI EL TITULAR EXISTE EN DIJ, SE SETEA RESULTADO EN campo_data PARA VALIDACIÓN EN RECEPCIÓN
    tipodDoc = (tipo_ddocument == "Cedula") ? "001" : "002"
    resultadoDijj = WebserviceConsumer.get( '/service/bdin_dij_record_policivo/call.json?method=get_record_policivo&tipoDocumento=' + "#{tipodDoc}&nroDocumento=#{nro_ddocument}").parsed_response
    personaDijj = resultadoDijj["response"]
    errorDeDijj = personaDijj["error"]
    existeEnDijj = "Dato no existe"
    if !errorDeDijj.blank?
        if tipo_ddocument == "Cedula"
          existeEnDijj = "Titular no existe en DIJ, se guardará la información."
         #transition_errors << "Usted no se encuentra registrado en la DIJ. Acuda a la sede más cercana a registrarse para poder continuar el trámite."
        else
          existeEnDijj = "Pasaporte no existe en DIJ, deberá registrarse de manera manual."
         #transition_errors << "Usted no se encuentra registrado en la DIJ. Acuda a la sede más cercana a registrarse para poder continuar el trámite."
        end
    else
        existeEnDijj = "Titular existe en DIJ"
    end
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.campo_data",existeEnDijj)
      

    #LG: VALIDAR SI EL TITULAR EXISTE EN PSP, SI NO EXISTE SE SOLICITA AUTORIZACIÓN PARA SOLICITUD DE RECORD POLICIVO
    # => Y SE SETEA EN campo_psp PARA VALIDACIÓN EN RECEPCIÓN
    tipodDocumentoPsp = (tipo_ddocument == "Cedula") ? "national_id" : "passport"
    resultadoPspp = WebserviceConsumer.get( '/service/ws_get_person_data_psp/titular.json?tipoDocumento=' + "#{tipodDocumentoPsp}&nroDocumento=#{nro_ddocument}").parsed_response
    personaPsp = resultadoPspp["response"]
    existeEnPspp = "Dato no existe en PEL"
    if personaPsp.blank?
      existeEnPspp = "Titular no existe en PEL, debe adjuntar Autorización."
    else
      existeEnPspp = "Titular existe en PEL"
    end
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.campo_psp",existeEnPspp)

    #::::: USADO PARA PRINT DESIGN
    primerNombret = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_nombre")
    segundoNombret = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_nombre")
    primerApellidot = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.primer_apellido")
    segundoApellidot = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.segundo_apellido")
    apellidoCasadat = form_data.get("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.apellido_de_casada")
    nombreCompletot = "#{primerNombret} #{segundoNombret} #{primerApellidot} #{segundoApellidot} #{apellidoCasadat}"
    form_data.set("datos_del_titular_rp_instance_1.datos_basicos_de_persona_natural.nombre_completo",nombreCompletot)

    #:::: CODIGO UNICO PARA TITULAR
      co_result = WebserviceConsumer.default_get( '/consecutive/codigo_unico_dij/generate.json').parsed_response
      cod_unico = co_result["response"]
      cod_unico = cod_unico["value"]
      form_data.set("datos_del_titular_rp_instance_1.codigo_unico_dij.codigo_unico",cod_unico)

      #:::: GENERA CONSECUTIVO INDIVIDUAL
        form_data.set("datos_del_titular_rp_instance_1.datos_de_solicitud.fecha_de_solicitud",@application["created_at"])
      result_cons = WebserviceConsumer.default_get( '/consecutive/generador_dij_f2/generate.json').parsed_response
    consecut = result_cons["response"]
    consecut = "#{@application["id"]}-"+"#{consecut["value"]}"
    form_data.set("datos_del_titular_rp_instance_1.datos_de_solicitud.numero_de_solicitud",consecut)
else

  (1..20).each do |_num|
    tipo_documento = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.tipo_de_documento")
    nro_documento = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte")
    nro_documento = URI.escape("#{nro_documento}")
  
    #LG: SALE DEL CICLO CUANDO CONSIGUE LA PRIMERA INSTANCIA VACIA
    break if nro_documento.blank?

    #LG: VALIDAR SI EL TITULAR EXISTE EN DIJ, SE SETEA RESULTADO EN campo_data PARA VALIDACIÓN EN RECEPCIÓN
    tipoDoc = (tipo_documento == "Cedula") ? "001" : "002"
    resultDij = WebserviceConsumer.get( '/service/bdin_dij_record_policivo/call.json?method=get_record_policivo&tipoDocumento=' + "#{tipoDoc}&nroDocumento=#{nro_documento}").parsed_response
    personaDij = resultDij["response"]
    errorDij = personaDij["error"]
    existeDij = "Dato no existe"
    if !errorDij.blank?
        if tipo_documento == "Cedula"
          #existeDij = "Titular no existe en DIJ, se guardará la información."
          transition_errors << "El Titular del documento Nro. #{nro_documento} no se encuentra registrado en la DIJ, el mismo debe acudir a la sede más cercana para registrarse. Para poder continuar el trámite, excluya a este titular."
        else
          #existeDij = "Pasaporte no existe en DIJ, deberá registrarse de manera manual."
          transition_errors << "El Titular del documento Nro. #{nro_documento} no se encuentra registrado en la DIJ, el mismo debe acudir a la sede más cercana para registrarse. Para poder continuar el trámite, excluya a este titular."
      end
    else
        existeDij = "Titular existe en DIJ"
    end
    form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.campo_data",existeDij)

    #LG: VALIDAR SI EL TITULAR EXISTE EN PSP, SI NO EXISTE SE SOLICITA AUTORIZACIÓN PARA SOLICITUD DE RECORD POLICIVO
    # => Y SE SETEA EN campo_psp PARA VALIDACIÓN EN RECEPCIÓN
    tipoDocPsp = (tipo_documento == "Cedula") ? "national_id" : "passport"
    resultPsp = WebserviceConsumer.get( '/service/ws_get_person_data_psp/titular.json?tipoDocumento=' + "#{tipoDocPsp}&nroDocumento=#{nro_documento}").parsed_response
    personaEnPsp = resultPsp["response"]
    existePSP = "Dato no existe en PEL"
    if personaEnPsp.blank?
      existePSP = "Titular no existe en PEL, debe adjuntar Autorización."
    else
      existePSP = "Titular existe en PEL"
    end
    form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.campo_psp",existePSP)

    #LG: INTEGRACIÓN PARA TRAER DATOS DE LA BDIN DE TRIBUNAL ELECTORAL
    if tipo_documento == "Cedula"
      resultTE = WebserviceConsumer.get('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
      data = resultTE["response"]
      if data.blank?
        #form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.cedula_pasaporte","")        
        transition_errors << "Los datos del Titular #{_num} no fueron encontrados, por favor verifique."
      else
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre",data["primerNombre"])
        segundoNombre = (data["segundoNombre"] == "ND") ? "" : data["segundoNombre"]
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre",segundoNombre)
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido",data["primerApellido"])
        segundoApell = (data["segundoApellido"]== "ND") ? "" : data["segundoApellido"]
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido",segundoApell)
        ApellCasada = (data["apellidoCasada"] == "ND") ? "" : data["apellidoCasada"]
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada",ApellCasada)
        sexo = ((data["sexo"] == "F") || (data["sexo"] == "female")) ? "Femenino" : "Masculino"
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.sexo",sexo)
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_ubicacion.direccion",data["direccionNacimiento"])
        difunto = data["cod_mensaje"]
        if (difunto == "534")
        transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{nro_documento} del Titular #{_num} corresponde a un ciudadano Difunto. Por favor, verifique."
        end
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_del_padre.documento_hijo",data["cedula"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_del_padre.primer_nombre",data["primerNombrePadre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_del_padre.segundo_nombre",data["segundoNombrePadre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_del_padre.primer_apellido",data["apellidoPaternoPadre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.documento_hijo",data["cedula"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.primer_nombre",data["primerNombreMadre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.segundo_nombre",data["segundoNombreMadre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.primer_apellido",data["apellidoPaternoMadre"])
        # CONVERSION FECHA DE NACIEMIENTO #
        fecha = data["fechaNacimiento"]
        fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.fecha_de_nacimiento",fecha_n)
        # CALCULA EDAD #
        edad = ((Date.today - fecha.to_date).to_f / 365).to_i
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.edad",edad)
      end      
    else
      form_data.set("datos_del_titular_rp_instance_#{_num}.datos_del_padre.documento_hijo",nro_documento)
      form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_la_madre.documento_hijo",nro_documento)
      #LG: SI LA PERSONA EXISTE EN DIJ SE SETEAN LOS CAMPOS OBTENIDOS DE LA CONSULTA
      if errorDij.blank?
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre",personaDij["primerNombre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre",personaDij["segundoNombre"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido",personaDij["apellidoPaterno"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido",personaDij["apellidoMaterno"])
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada",personaDij["apellidoCasada"])
      end   
    end

    #:::: USADO PARA PRINT DESIGN
    primerNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_nombre")
    segundoNombre = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_nombre")
    primerApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.primer_apellido")
    segundoApellido = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.segundo_apellido")
    apellidoCasada = form_data.get("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.apellido_de_casada")
    nombreCompleto = "#{primerNombre} #{segundoNombre} #{primerApellido} #{segundoApellido} #{apellidoCasada}"
    form_data.set("datos_del_titular_rp_instance_#{_num}.datos_basicos_de_persona_natural.nombre_completo",nombreCompleto.squish)

    #:::: GENERA CODIGO UNICO POR CADA TITULAR
    result_co = WebserviceConsumer.default_get( '/consecutive/codigo_unico_dij/generate.json').parsed_response
    codigo_unico = result_co["response"]
        codigo_unico = codigo_unico["value"]
        form_data.set("datos_del_titular_rp_instance_#{_num}.codigo_unico_dij.codigo_unico",codigo_unico)

        #:::: GENERA CONSECUTIVO INDIVIDUAL
        form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_solicitud.fecha_de_solicitud",@application["created_at"])
      result_consec = WebserviceConsumer.default_get( '/consecutive/generador_dij_f2/generate.json').parsed_response
    consecutiv = result_consec["response"]
    consecutiv = "#{@application["id"]}-"+"#{consecutiv["value"]}"
    form_data.set("datos_del_titular_rp_instance_#{_num}.datos_de_solicitud.numero_de_solicitud",consecutiv)
  end
end

#::::: Validación para setear provincia Panamá si es minrex
if @owner["kind_of_user_type"] == "JuridicalPerson"
  tipo_de_solicitante = form_data.get("tipo_de_persona_dij.tipo_de_solicitante_juridico.tipo_de_solicitante_juridico")
  if tipo_de_solicitante == "MINREX"
    form_data.set("datos_del_solicitante.datos_de_ubicacion.provincia_lista","Panamá")
  end
end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //::: DV: Validación para ocultar seccion de confirmación si y motivo de solicitud
$(document).ready(function(){
	function ocultar(){
		var valor  = $("#field_datos_del_propietario_tramite_juridico_datos_persona_juridica_ruc").val();
		var valor1 = $('input[name="[field][tipo_de_persona_dij_es_titular_o_no_si_no]"]:checked').val();
		if(valor != undefined){
			$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto').parents(".section-box").show();
			$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().show();
			$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto').parents(".section-box").next().show();
		}else if(valor1 != "NO" || valor1 == undefined){
			$("#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto").parents(".section-box").hide()
			$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().hide();
			$("#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto").parents(".section-box").next().hide()
		}
	}
  	ocultar();
});

//::: DV: Función para ocultar seccion de confirmación si y motivo de solicitud
$(document).ready(function(){
	$(function() {
		$('input[name="[field][tipo_de_persona_dij_es_titular_o_no_si_no]"]').change(function() {
			if ($('input[name="[field][tipo_de_persona_dij_es_titular_o_no_si_no]"]:checked').val() == "NO"){
				$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto').parents(".section-box").show();
				$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().show();
				$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_tipo_de_documento').val('');
				$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_cedula_pasaporte').val('');
				$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_tipo_de_nacionalidad').parent().parent().hide();
				$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_nacionalidad').parent().parent().hide();
        		$('#field_datos_del_titular_rp_instance_1_datos_basicos_de_persona_natural_radio_oculto').parents(".section-box").next().show();
			}else{
				$.each( $('[id*=datos_del_titular_rp_]'), function(index, campo) {    
					var pos = (this.id).match(/_instance_[\d][\d]/);
					if (pos == null){
						pos = (this.id).match(/_instance_[\d]/);
					}
					var InicioRuta  = "#field_datos_del_titular_rp";
					var doc  		= "_datos_basicos_de_persona_natural_radio_oculto";
					var coincide 	= InicioRuta.concat(pos);
					var doc2 		= coincide.concat(doc);
					$(doc2).parents(".section-box").hide();
					$(doc2).parents(".section-box").next().hide();
				});
			 $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().hide();
			}
		});
	});
});

/// change para el tipo de nacionalidad 

$(document).ready(function(){   
	$.each( $('[id*=datos_del_titular_rp_]'), function(index, camp) {
		var posi = (this.id).match(/_instance_[\d][\d]/);
		if (posi == null){
			posi = (this.id).match(/_instance_[\d]/);
		} 
		var nod1 	= "#field_datos_del_titular_rp";
		var nod2 	= "_datos_basicos_de_persona_natural_tipo_de_documento";
		var tipo 	= "_datos_basicos_de_persona_natural_tipo_de_nacionalidad";
		var cedu 	= "_datos_basicos_de_persona_natural_nacionalidad";
		var pas 	= "_datos_basicos_de_persona_natural_cedula_pasaporte";

		var nod3 	= nod1.concat(posi);
		var dat 	= nod3.concat(nod2); // tipodoc select
		var tiponac = nod3.concat(tipo); // tiponac select
		var nacionalidad = nod3.concat(cedu); // nac tex
		var pasaporte = nod3.concat(pas); // cedu tex

		$(tiponac).parent().parent().hide();
		$(nacionalidad).parent().parent().hide();
		//$(function() {
		$(dat).change(function(){
			var dat = $(this).val();
			if (dat == '') {
				$(tiponac).parent().parent().hide();
				$(tiponac).val("");
				$(nacionalidad).parent().parent().hide();
				$(nacionalidad).val("");
			} else if (dat== 'Cedula') {
				$(nacionalidad).parent().parent().hide();
				$(tiponac).val("Nacional");
				$(tiponac).parent().parent().show();
				$(tiponac).attr("disabled","disabled");

			} else if (dat== 'Pasaporte' && dat != '' ) {
				$(tiponac).parent().parent().hide();
				// $(nacionalidad).val('');
				$(nacionalidad).html("Extranjero");
				$(nacionalidad).parent().parent().show();
			}                
		});
		var dato = $(dat).val();
		//alert(dato);
		if (dato == 'Cedula') {
			$(nacionalidad).parent().parent().hide();
			$(tiponac).val("Nacional");
			$(tiponac).parent().parent().show();
			$(tiponac).attr("disabled","disabled");
		}else if (dato== 'Pasaporte' && dato != '') {
			$(tiponac).parent().parent().hide();
			// $(nacionalidad).val('');
			$(nacionalidad).html("Extranjero");
			$(nacionalidad).parent().parent().show();
		} 
	});     
});


//::: DV: HABILITAR CAMPOS CUANDO VENGAN VACIO DESDE LA BD ::://
$(document).ready(function(){
	function ocultar(){
		var valora = $('#field_datos_del_solicitante_datos_de_ubicacion_direccion').val();
		var valorb = $('#field_datos_del_solicitante_datos_de_ubicacion_numero_de_telefono').val();
		var valorc = $('#field_datos_del_solicitante_datos_de_ubicacion_correo_electronico').val();
		var valord = $('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_direccion').val();
		var valore = $('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_numero_de_telefono').val();
		var valorf = $('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_correo_electronico').val();
		if (valora == ""){
			$('#field_datos_del_solicitante_datos_de_ubicacion_direccion').removeAttr("disabled");
		}
		if (valorb == "") {
			$('#field_datos_del_solicitante_datos_de_ubicacion_numero_de_telefono').removeAttr("disabled");	
		}
		if (valorc == ""){
			$('#field_datos_del_solicitante_datos_de_ubicacion_correo_electronico').removeAttr("disabled");
		}
		if (valord == ""){
			$('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_direccion').removeAttr("disabled");
		}
		if (valore == "") {
			$('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_numero_de_telefono').removeAttr("disabled");	
		}
		if (valorf == ""){
			$('#field_datos_del_propietario_tramite_natural_datos_de_ubicacion_correo_electronico').removeAttr("disabled");
		}
	}
	ocultar();
});


//:::agregado 
$(document).ready(function(){
    $.each( $('[id*=_datos_del_titular_rp_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
          pos = (this.id).match(/_instance_[\d]/);
        }
        var inicRuta = "#field_datos_del_titular_rp";
        var tDoc = "_datos_basicos_de_persona_natural_tipo_de_documento";
        var NumDoc = "_datos_basicos_de_persona_natural_cedula_pasaporte";
        var coincide = inicRuta.concat(pos);
        var TiDoc = coincide.concat(tDoc);
        var NroDocu = coincide.concat(NumDoc);
        $(TiDoc).change(function(){
            TiDoc = $(this).val();
            if(TiDoc == "Cedula"){
                    $(NroDocu).val("");
            }
            if(TiDoc == "Pasaporte"){
                    $(NroDocu).val("");
            }
        });     
    });
});

////LP: Para setear provincia Panamá si solicitante es minrex

$(document).ready(function(){
	tipo_de_solicitante = $("#field_tipo_de_persona_dij_tipo_de_solicitante_juridico_tipo_de_solicitante_juridico");
	provincia = $("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista");
	motivo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad");
	tipo_auto = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad");
	empresas = $("#field_tipo_de_persona_dij_tipo_de_solicitante_juridico_tipo_de_solicitante_juridico_empresas");
	// var valor8 = $('input[name="[field][tipo_de_persona_dij_es_titular_o_no_si_no]"]:checked').val();
	// // if(valor8 == undefined){
	// // 	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").show();
    // //      	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij").parent().parent().show();
	// // 	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().hide();
	// // }
	// if (tipo_de_solicitante == undefined){
	// 	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").show();
	// 	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").parent().parent().show();
	// 	$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij").parent().parent().show();
	// }
	if ($(empresas).find(':selected').val() == "") {
		$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").show();
	}
	if ($(tipo_de_solicitante).find(':selected').val() == "") {
		$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").hide();
		$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().hide();
	}

});
$(document).ready(function(){
	$( function() {
		tipo_de_solicitante.change(function() {
			if ($(tipo_de_solicitante).find(':selected').val() == "MINREX") {
				$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("Panamá");
				provincia.attr("disabled","disabled");
				$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').val('');
			} else if ($(tipo_de_solicitante).find(':selected').val() == "Autoridades") {
				$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("");
				provincia.removeAttr("disabled","disabled");
				$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').parent().parent().show();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
			} else if ($(tipo_de_solicitante).find(':selected').val() == "") {
				$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_campo_oculto").parents(".section-box").hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_solicitud_autoridad').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_autoridad').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val('');
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val('');
			}
		});
		motivo_auto.change(function() {
			if ($(motivo_auto).find(':selected').val() == "Otros") {
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().show();
			} else{
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').val("");
			}
		});
		tipo_auto.change(function() {
			if ($(tipo_auto).find(':selected').val() == "Otros") {
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().show();
			} else{
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
				$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').val("");
			}
		});
		//mantener cambios entre pasos
		if ($(tipo_de_solicitante).find(':selected').val() == "MINREX") {
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
		} else if ($(tipo_de_solicitante).find(':selected').val() == "Autoridades") {
			//$("#field_datos_del_solicitante_datos_de_ubicacion_provincia_lista").val("");
			provincia.removeAttr("disabled","disabled");
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
		if ($(motivo_auto).find(':selected').val() == "Otros") {
			$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().show();
		}else{
			$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_motivo').parent().parent().hide();
		}
		if ($(tipo_auto).find(':selected').val() == "Otros") {
			$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().show();
		} else{
			$('#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_otro_tipo').parent().parent().hide();
		}
	});
});

//Setear trabajo y deshabilitar campo motivo si es Persona natural
$(document).ready(function(){
	tipo_persona = $("#field_datos_del_propietario_tramite_natural_datos_basicos_de_persona_natural_cedula_pasaporte").val();
	motivo = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij");
	tipo_solicitud = $("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij");
	if (tipo_persona != undefined) {
		$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_motivo_de_la_solicitud_dij").val("Trabajo");
		$("#field_tipo_de_solicitud_dij_tipo_de_solicitud_dij_tipo_de_solicitud_dij").val("Laboral");
		tipo_solicitud.attr("disabled","disabled");
		motivo.attr("disabled","disabled");
	} else{
		motivo.removeAttr("disabled","disabled");
		tipo_solicitud.removeAttr("disabled","disabled");
	}
});
    STEPAJAXCODE
  end
            
