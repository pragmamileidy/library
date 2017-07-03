
  class Paso4AdjuntarArchivos < TemplateCode::Step

    on_becoming do
      ####Validaciòn para print LP 01-03-17

## Comentado por Chantal Valverde 7-Mar-2017
##dato = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")

##if dato == "Lunes a domingo y días feriados 24 horas"
##    form_data.set("horario_de_operacion.horario.campo_oculto","Sí")
##else
##    form_data.set("horario_de_operacion.horario.campo_oculto","No")
##end

## Modificación Chantal Valverde 07-Mar-2017
dato = form_data.get("horario_de_operacion.horario.lunes_a_domingo_y_dias_feriados_24_horas")

horario_corrido = dato.match("Lunes a domingo y días feriados 24 horas")

if horario_corrido.present?
   form_data.set("horario_de_operacion.horario.campo_oculto","Sí")
else
   form_data.set("horario_de_operacion.horario.campo_oculto","No")
end
    end

    on_transition do
      # El anexo CÉDULA DEL APODERADO sólo se requiere si el trámite lo realiza un tercero.
# El anexo CERTIFICADO DE OPERACIÓN SANITARIO sólo se requiere en caso de que en el TIPO DE  
# SOLICITUD se seleccione RENOVACIÓN.
# Si el usuario es apoderado y no se anexa la cédula del mismo, o si es renovación y no se anexa el
# Certificado de operación sanitario, desplegar un mensaje de error y no permitir SUBMIT.
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
