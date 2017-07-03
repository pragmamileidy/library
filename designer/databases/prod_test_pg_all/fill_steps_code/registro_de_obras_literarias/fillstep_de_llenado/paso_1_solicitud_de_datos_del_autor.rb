
  class Paso1SolicitudDeDatosDelAutor < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
numero_de_solicitud = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")
if !numero_de_solicitud.present?
	result = WebserviceConsumer.get( '/consecutive/generador_ObraLiteraria/generate.json').parsed_response
	_consecutivo = result["response"]
	if _consecutivo.present?
		_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
		form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
	end
end


##### DATOS DEL SOLICITANTE NATURAL O JURIDICO #####

if @owner["kind_of_user_type"] == "NaturalPerson"
    if @owner["natural_person_type"]=="national_citizen"
        form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte",@owner["national_id"])
    else
        form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte",@owner["passport"])
    end

    form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_nombre",@owner["first_name"])
    form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.primer_apellido",@owner["last_name"])
    form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_nombre",@owner["second_name"])
    form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.segundo_apellido",@owner["second_last_name"])
    form_data.set("datos_del_solicitante_persona_natural.datos_de_la_persona.apellido_de_casada",@owner["married_name"])
    pais = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.pais")
    form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.pais",@owner["country"]) if !pais.present?
    direccion = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.direccion")
    form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.direccion",@owner["full_address"]) if !direccion.present?
    telefono = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.numero_de_telefono")
    form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.numero_de_telefono",@owner["fixed_number"]) if !telefono.present?
    email = form_data.get("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.correo_electronico")
    form_data.set("datos_del_solicitante_persona_natural.informacion_de_residencia_localizacion.correo_electronico",@owner["email"]) if !email.present?
end

if @owner["kind_of_user_type"] == "JuridicalPerson"

    form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.ruc",@owner["tax_id"])
    form_data.set("datos_del_solicitante_persona_juridica.datos_de_la_empresa.nombre",@owner["name"])
    pais_j = form_data.get("datos_del_solicitante_persona_juridica.direccion.pais")
    form_data.set("datos_del_solicitante_persona_juridica.direccion.pais",@owner["country"]) if !pais_j.present?
    direccion_j = form_data.get("datos_del_solicitante_persona_juridica.direccion.direccion")
    form_data.set("datos_del_solicitante_persona_juridica.direccion.direccion",@owner["full_address"]) if !direccion_j.present?
    telefono = form_data.get("datos_del_solicitante_persona_juridica.direccion.numero_de_telefono")
    form_data.set("datos_del_solicitante_persona_juridica.direccion.numero_de_telefono",@owner["fixed_number"]) if !telefono.present?
    email_j = form_data.get("datos_del_solicitante_persona_juridica.direccion.correo_electronico")
    form_data.set("datos_del_solicitante_persona_juridica.direccion.correo_electronico",@owner["email"]) if !email_j.present?
end

##### FIN DATOS DEL SOLICITANTE #####

    end

    on_transition do
      #VERIFICACIÒN NUMERO DE CEDULA DEL SOLICITANTE NO PERTENEZCA A UN DIFUNTO

if ((@owner["kind_of_user_type"] == "NaturalPerson") && (@owner["natural_person_type"] == "national_citizen"))
    numdoc = form_data.get("datos_del_solicitante_persona_natural.datos_de_la_persona.cedula_pasaporte")
    result = WebserviceConsumer.get(URI.escape('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{numdoc}")).parsed_response
    datosSol = result["response"]
    if datosSol.blank? 
        transition_errors << "La Cédula del solicitante no fue encontrada. Por favor, verifique." 
    else            
        difunto = datosSol["cod_mensaje"]
##        if (difunto != "ND")
        if (difunto == "534")
            transition_errors << "No puede continuar con el trámite, ya que el nro. de documento #{numdoc} corresponde a un ciudadano Difunto."
        end
    end
end



##### MT - BUSQUEDA DE DATOS AUTORES
(1..30).each do |_num|
 tipo_doc = form_data.get("tipo_de_autor_instance_#{_num}.documento.tipo_de_documento")
 tipoAut = form_data.get("tipo_de_autor_instance_#{_num}.autor.tipo_de_autor")
 nro_documento = form_data.get("tipo_de_autor_instance_#{_num}.documento.numero_documento")
 form_data.set("datos_del_autor_instance_#{_num}.tipo_de_identificacion.tipo_identificacion_texto", tipo_doc)   
    if tipo_doc != "RUC"
            form_data.set("datos_del_autor_instance_#{_num}.autor.autor", tipoAut)
            form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.tipo_documento_string", tipo_doc)       
            if tipo_doc == "Cédula" 
                result = WebserviceConsumer.get('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
                _persona = result["response"]
                if !_persona.blank?

                    ### VALIDACION CEDULA DIFUNTO
                    difunto = _persona["cod_mensaje"]
                    if (difunto == "534")
                        transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{nro_documento} del Autor Titular #{_num}, corresponde a un ciudadano Difunto."
                    end
                    ### FIN VALIDACION
                    
                    ### BLANQUEAR CAMPOS AL CAMBIAR NRO DE CEDULA
                    cedPasAutor = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte")
                    
                    if cedPasAutor != nro_documento
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nacionalidad", "")
                        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.seudonimo", false)
                        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.indique_seudonimo", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.edad", "")
                    end
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.ruc","")
                	form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.nombre","") 
                	form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","") 
                	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","") 
                	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion","") 
                	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais","") 
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",_persona["cedula"])
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_nombre",_persona["primerNombre"])
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_nombre",_persona["segundoNombre"])
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_apellido",_persona["primerApellido"])
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_apellido",_persona["segundoApellido"])
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nacionalidad",_persona["lugarNacimiento"])
                                     

                    fecha = _persona["fechaNacimiento"]
                    fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", fecha_n)

                    edad = ((Date.today - fecha_n.to_date).to_f / 365).to_i
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.edad",edad)

                end
                if _persona.blank?
                    transition_errors << "La cédula suministrada no existe en el sistema, favor revise  el número especificado en el autor  " + "#{_num}"
                end
            end 

            if tipo_doc == "Pasaporte"  
                cedPasAutor = form_data.get("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte")

                ### BLANQUEAR CAMPOS AL CAMBIAR NRO DE PASAPORTE
                    if cedPasAutor != nro_documento
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nacionalidad", "")
                        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","") 
                        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.seudonimo", false)
                        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.indique_seudonimo", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.edad", "")
                    end
                form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.ruc","")
                form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.nombre","") 
                form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
                form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",nro_documento)
            end 
    
    end
    if tipo_doc == "RUC"
        tipoSoc = form_data.get("tipo_de_autor_instance_#{_num}.documento.tipo_sociedad")   
            if !nro_documento.blank?
            result = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_ruc/find.json?ruc=' + "#{nro_documento}" + '&tipo_sociedad=' + "#{tipoSoc}")).parsed_response
            data = result["response"]  
                if !data.blank?
                   form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nacionalidad", "")
                    form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                    form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                    form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","") 
                    form_data.set("datos_del_autor_instance_#{_num}.seudonimo.seudonimo", false)
                    form_data.set("datos_del_autor_instance_#{_num}.seudonimo.indique_seudonimo", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.edad", "")
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.nombre",data["nombre_empresa"]) 
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.ruc",nro_documento) 
                    form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.tipo_sociedad",tipoSoc) 
                else
                    transition_errors << "El ruc introducido no esta registrado en el sistema o tiene tipo de sociedad incorrecta, por favor verifique: #{nro_documento}"
                end
            end
        form_data.set("datos_del_autor_instance_#{_num}.autor.autor", tipoAut)
    end   

	if tipo_doc == ""
		form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.nacionalidad", "")
        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
        form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","") 
        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.seudonimo", false)
        form_data.set("datos_del_autor_instance_#{_num}.seudonimo.indique_seudonimo", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_persona.edad", "")
        form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.ruc","")
    	form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.nombre","") 
    	form_data.set("datos_del_autor_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","") 
    	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","") 
    	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.direccion","") 
    	form_data.set("datos_del_autor_instance_#{_num}.informacion_de_residencia_localizacion.pais","") 
	    form_data.set("datos_del_autor_instance_#{_num}.tipo_de_identificacion.tipo_identificacion_texto","") 
	end                               
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //:::::::::::::Validaciones varias PASO 1::::::::::://
$(document).ready(function(){
    //::::::::Ocultar Y limpiar Campo Tipo de Sociedad y limpiar campos de nro de documento, función CHANGE en Sección del Director::::::://
    $.each( $('[id*=tipo_de_autor_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }
        var inicRuta = "#field_tipo_de_autor";
        var tDoc = "_documento_tipo_de_documento";
        var NumDoc = "_documento_numero_documento";
        var TipoSoc = "_documento_tipo_sociedad";
        var coincide = inicRuta.concat(pos);
        var TiDoc = coincide.concat(tDoc);
        var NroDocu = coincide.concat(NumDoc);
        var tsoci = coincide.concat(TipoSoc);
         
        //::::::::: Mantener datos entre pasos :::::::// 
        if ($(TiDoc).find(':selected').val() =="") {
            $(tsoci).parent().parent().hide();
        }else if (($(TiDoc).find(':selected').val() == "Cédula") || ($(TiDoc).find(':selected').val() == "Pasaporte")) {
            $(tsoci).parent().parent().hide();
        } else {
            $(tsoci).parent().parent().show();
        }
        
        //::::::::: Change para limpiar campos y ocultar o mostra el campo tipo de sociedad ::::::://
        $(TiDoc).change(function(){
            TiDoc = $(this).val();
            if(TiDoc == ""){
                $(NroDocu).val("");
                $(tsoci).val("");
                $(tsoci).parent().parent().hide();
            }
            if(TiDoc == "Cédula"){
                $(NroDocu).val("");
                $(tsoci).val("");
                $(tsoci).parent().parent().hide();
            }
            if(TiDoc == "Pasaporte"){
                $(NroDocu).val("");
                $(tsoci).val("");
                $(tsoci).parent().parent().hide();
            }
            if(TiDoc == "RUC"){
                $(NroDocu).val("");
                $(tsoci).parent().parent().show();
            }
        }); 
    });
});  
    STEPAJAXCODE
  end
            
