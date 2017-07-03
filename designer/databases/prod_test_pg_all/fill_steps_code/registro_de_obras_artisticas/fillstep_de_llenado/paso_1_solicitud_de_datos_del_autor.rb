
  class Paso1SolicitudDeDatosDelAutor < TemplateCode::Step

    on_becoming do
      form_data.set("informacion_de_solicitud.datos_de_la_solicitud.fecha_de_solicitud",@application["created_at"])
numero_de_solicitud = form_data.get("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud")
if !numero_de_solicitud.present?
	result = WebserviceConsumer.get( '/consecutive/generador_obrasartisticas/generate.json').parsed_response
	_consecutivo = result["response"]
	if _consecutivo.present?
		_consecutivo = "#{@application["id"]}-"+"#{_consecutivo["value"]}"
		form_data.set("informacion_de_solicitud.datos_de_la_solicitud.numero_de_solicitud",_consecutivo)
	end
end

    end

    on_transition do
      (1..10).each do |_num|

        _tipo = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.tipo_de_documento")
        if _tipo == "Cédula"
                nro_documento = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.no_documento")
                if !nro_documento.blank?
                        result = WebserviceConsumer.get( '/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
                        datos = result["response"]
                        if datos.nil? 
                                form_data.set("tipo_de_documento_instance_#{_num}.tipo_documento_mici.no_documento","")
                                transition_errors << "Los datos del Autor #{_num} no se encuentran en el sistema"
                        else
                                ### VALIDACION CEDULA DIFUNTO
                                difunto = datos["cod_mensaje"]
                                if (difunto == "534")
                                        transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{nro_documento} del Autor Titular #{_num}, corresponde a un ciudadano Difunto."
                                end
                                ### FIN VALIDACION

                                ### PARA BLANQUEAR CAMPOS EN CASO DE QUE SE CAMBIE EL NRO DE PASAPORTE
                                nro_doc_paso2 = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte")
                                if nro_documento != nro_doc_paso2
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.seudonimo", false)
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.indique_seudonimo", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nacionalidad","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.edad","")
                                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo","")
                                end
                                ### FIN BLANQUEO

                                _tipo = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.tipo_de_documento")
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string",_tipo)
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",nro_documento)
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre",datos["primerNombre"])
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido",datos["primerApellido"])
                                if datos["segundoNombre"].present?
                                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre",datos["segundoNombre"])
                                end
                                if datos["segundoApellido"].present?
                                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido",datos["segundoApellido"])
                                end

                                #### BALANQUEAR DATOS JURIDICO MISMA INSTANCIA
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_documento","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.ruc","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.nombre","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.pais","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.direccion","")
                                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.ciudad","")
                                
                                #form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada",datos["apellidoCasada"])
                                #form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.direccion",datos["direccion"])
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nacionalidad",datos["pais"])
                                
                                fecha = datos["fechaNacimiento"]
                                if fecha.present?
                                    fecha_n = Time.parse(fecha).strftime("%d-%m-%Y")
                                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento",fecha_n)
                                    edad = ((Date.today - fecha_n.to_date).to_f / 365).to_i
                                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.edad",edad)
                                end
                                primerNombre = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre")
                                primerapellido = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido")
                                segundoNombre = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre")
                                segundoapellido = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido")
                                apellidoCasada = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada")
         
                                _nombre =  "#{primerNombre} "+"#{segundoNombre} "+"#{primerapellido} "+"#{segundoapellido} "+"#{apellidoCasada}"
                                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo",_nombre)
                                
                                datos = nil 

                        end
                end
        end

        if _tipo == "Pasaporte"
                nro_documento = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.no_documento")
                nro_doc_paso2 = form_data.get("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte")
                ### PARA BLANQUEAR CAMPOS EN CASO DE QUE SE CAMBIE EL NRO DE PASAPORTE
                if nro_documento != nro_doc_paso2
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.seudonimo", false)
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.indique_seudonimo", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nacionalidad","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.edad","")
                        form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo","")
                end
                ### BLANQUEAR DATOS TITULARES RUC
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_documento","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.ruc","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.nombre","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.pais","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.direccion","")
                form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.ciudad","")
                ### FIN BLANQUEO

                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",nro_documento)
                
                _tipo = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.tipo_de_documento")
                form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string",_tipo)
        end
        if _tipo == "RUC"
            tipoSoc=form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.tipo_sociedad")
            nro_documento = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.no_documento")
            if !nro_documento.blank?
                result = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_ruc/find.json?ruc=' + "#{nro_documento}" + '&tipo_sociedad=' + "#{tipoSoc}")).parsed_response
                data = result["response"]
                if data.nil?
                    form_data.set("tipo_de_documento_instance_#{_num}.tipo_documento_mici.no_documento","")
                    transition_errors << "El ruc del titular #{_num} introducido no esta registrado en el sistema, por favor verifique"
                else
                    ## BLANQUEAR DATOS AUTORES NATURALES MISMA INSTANCIA
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.seudonimo", false)
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.indique_seudonimo", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nacionalidad","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo","")
                    form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.edad","")

                    #set new values juridical
                    _tipo = form_data.get("tipo_de_documento_instance_#{_num}.tipo_documento_mici.tipo_de_documento")
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_documento",_tipo)
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_sociedad",tipoSoc)
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.ruc",nro_documento)
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.nombre",data["nombre_empresa"])
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.pais",data["pais"])
                    form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.direccion",data["direccion"])
                    datos = nil
                end
            end
        end

        if _tipo == ""
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string","") 
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_documento","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.seudonimo", false)
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.seudonimo.indique_seudonimo", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.tipo_documento_string","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.cedula_pasaporte","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_nombre","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.primer_apellido","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_nombre","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.segundo_apellido","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.apellido_de_casada", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_defuncion", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.fecha_de_nacimiento", "")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nacionalidad","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.nombre_completo","")
            form_data.set("datos_del_autor_es_persona_natural_instance_#{_num}.datos_de_la_persona.edad","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_documento","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.ruc","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.datos_de_la_empresa.nombre","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.pais","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.direccion","")
            form_data.set("datos_del_titular_es_persona_juridica_instance_#{_num}.direccion.ciudad","")
        end 
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      $(document).ready(function(){
    $.each( $('[id*=_tipo_de_documento_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }
        var inicRuta = "#field_tipo_de_documento";
        var tDoc = "_tipo_documento_mici_tipo_de_documento";
        var NumDoc = "_tipo_documento_mici_no_documento";
        var TipoSoc = "_tipo_documento_mici_tipo_sociedad";
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
            
