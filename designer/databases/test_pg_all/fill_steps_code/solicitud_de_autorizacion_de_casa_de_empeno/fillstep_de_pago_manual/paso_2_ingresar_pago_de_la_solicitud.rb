
  class Paso2IngresarPagoDeLaSolicitud < TemplateCode::Step

    on_becoming do
      # Limpiar el contenido de los campos
#form_data.set("datos_de_pago.datos_de_pago.numero_de_recibo_deposito", "")
#form_data.set("datos_de_pago.datos_de_pago.fecha_del_pago", "")
#form_data.set("datos_de_pago.datos_de_pago.monto_del_pago", "")
#form_data.set("datos_de_pago.datos_de_pago.banco", "")
#form_data.set("datos_de_pago.datos_de_pago.observaciones", "")
#form_data.set("datos_de_pago.datos_de_pago.comprobante_de_pago", "")

form_data.routes.select{|r| r =~ /(\d+)\.pagada/}.each{ |pagada|
  next unless form_data.get(pagada) == 'Iniciada'
  form_data.set(pagada, 'Si')
}

_montoTotal = form_data.get("datos_del_evaluador_generico.monto_total.monto_total")
form_data.set("datos_de_pago.datos_de_pago.monto_del_pago",_montoTotal)
    end

    on_transition do
      ##### PAGO MANUAL #####
_applicationId = @application["id"]
_taskId = @task["id"]

recibo = form_data.get("datos_de_pago.datos_de_pago.numero_de_recibo_deposito")
fecha = form_data.get("datos_de_pago.datos_de_pago.fecha_del_pago")
monto = form_data.get("datos_de_pago.datos_de_pago.monto_del_pago")
banco = form_data.get("datos_de_pago.datos_de_pago.banco")
comprobante = form_data.get("datos_de_pago.datos_de_pago.comprobante_de_pago")

pago = {
	"reference_number"=> "#{recibo}",
	"payment_date"=> "#{fecha}",
	"bank"=>"#{banco}",
	"amount"=>"#{monto}",
	"attachment_id"=>"#{comprobante}"
}


### Validación de Fecha#######

fecha_pago = form_data.get("datos_de_pago.datos_de_pago.fecha_del_pago") 
_error = false
if (fecha_pago.to_date > Date.today)
	_error = true 
	transition_errors << " La fecha del recibo del pago no debe ser mayor a la fecha actual"
end

if !_error 
	result =  PaymentProxy.register_manual_payments(_applicationId,pago, _taskId)

	if (!result[:create]) 
  		transition_errors << "El Número de Depósito Introducido ya ha sido registrado. Su pago no puede ser procesado. Por Favor Verifique"
	end
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
