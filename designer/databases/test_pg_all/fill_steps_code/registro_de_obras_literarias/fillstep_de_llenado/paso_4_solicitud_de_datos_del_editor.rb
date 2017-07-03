
  class Paso4SolicitudDeDatosDelEditor < TemplateCode::Step

    on_becoming do
      
    end

    on_transition do
      tipo_obra = form_data.get("informacion_de_la_obra_literaria.datos_de_la_obra.estatus_de_la_obra")

if (tipo_obra == "Publicada")
    ##########MT - BUSQUEDA DE DATOS
    (1..5).each do |_num|
     tipo_doc = form_data.get("tipo_de_editor_instance_#{_num}.documento.tipo_de_documento")
     nro_documento = form_data.get("tipo_de_editor_instance_#{_num}.documento.numero_documento")
     form_data.set("datos_de_los_editores_instance_#{_num}.tipo_de_identificacion.tipo_identificacion_texto", tipo_doc) 
        if tipo_doc != "RUC"
            _malas = []

            if tipo_doc == "Cédula"
                if !nro_documento.blank?
                    result = WebserviceConsumer.get('/service/bdin_tribunal_electoral/find.json?cedula=' + "#{nro_documento}").parsed_response
                    datos = result["response"]
                    if datos.blank? 
                        transition_errors << "La Cédula introducida ubicada en la posición #{_num} no se encuentran en el sistema. Por Favor Verifique"
                    else
                        ### VALIDACION CEDULA DIFUNTO
                        difunto = datos["cod_mensaje"]
                            if (difunto == "534")
                                transition_errors << "No puede continuar con el trámite, ya que la cédula nro. #{nro_documento} del Editor #{_num}, corresponde a un ciudadano Difunto."
                            end
                        ### FIN VALIDACION
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.ruc","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.nombre","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion","")
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",datos["cedula"])
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_nombre",datos["primerNombre"])
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_apellido",datos["primerApellido"])
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_nombre",datos["segundoNombre"])
                        form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_apellido",datos["segundoApellido"])
                        form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais",datos["pais"])
                        datos = nil
                    end
                end
            end
            if tipo_doc == "Pasaporte"

                cedPasEditores = form_data.get("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte")

                ### BLANQUEAR CAMPOS AL CAMBIAR NRO DE PASAPORTE
                if cedPasEditores != nro_documento
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.nombre_completo", "")
                end
                form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.ruc","")
                form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.nombre","")
                form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
                form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais","")
                form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad","")
                form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion","")
                form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte",nro_documento)
            end

        else        
        
            tipoSoc=form_data.get("tipo_de_editor_instance_#{_num}.documento.tipo_sociedad")
            if !nro_documento.blank?
                result = WebserviceConsumer.get(URI.escape('/service/bdin_registro_publico_ruc/find.json?ruc=' + "#{nro_documento}" + '&tipo_sociedad=' + "#{tipoSoc}")).parsed_response
                datos = result["response"]
                if datos.blank? 
                    transition_errors << "El RUC introducido ubicado en la posición #{_num} no se encuentran en el sistema. Por Favor Verifique"
                else
                	form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.nombre_completo", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.ruc",nro_documento)
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.nombre",datos["nombre_empresa"])
                    form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.tipo_sociedad",tipoSoc)
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais",datos["pais"])
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad",datos["ciudad"])
                    form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion",datos["direccion"])
                    datos = nil
                end
            end
        
        end

        if tipo_doc.blank?
			form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.cedula_pasaporte", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_nombre", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.primer_apellido", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_nombre", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.segundo_apellido", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.pais", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.ciudad", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.informacion_de_residencia_localizacion.direccion", "")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.ruc","")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.nombre","")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_empresa.tipo_sociedad","")
            form_data.set("datos_de_los_editores_instance_#{_num}.tipo_de_identificacion.tipo_identificacion_texto","")
            form_data.set("datos_de_los_editores_instance_#{_num}.datos_de_la_persona.nombre_completo", "")
        end
    end 

end
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      //:::::::::::::Validaciones varias PASO 4::::::::::://
$(document).ready(function(){
    //::::::::Ocultar Y limpiar Campo Tipo de Sociedad y limpiar campos de nro de documento, función CHANGE en Sección del Director::::::://
    $.each( $('[id*=tipo_de_editor_]'), function(index, campo) {    
        var pos = (this.id).match(/_instance_[\d][\d]/);
        if (pos == null){
            pos = (this.id).match(/_instance_[\d]/);
        }
        var inicRuta = "#field_tipo_de_editor";
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
            
