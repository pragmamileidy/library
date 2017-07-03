
  class IngresarPagoDeLaSolicitud < TemplateCode::Step

    on_becoming do
      		# Limpiar el contenido de los campos
(1..15).each do |_num|	
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.numero_de_recibo_deposito", "")
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.fecha_del_pago", "")
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.monto_del_pago", "")
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.banco", "")
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.observaciones", "")
		form_data.set("datos_de_pago_p5_instance_#{_num}.datos_de_pago.comprobante_de_pago", "")
 end


form_data.routes.select{|r| r =~ /entidad_evaluadora_revisiones.entidad_evaluadora_(\d+)\.pagada/}.each{ |pagada|
  next unless form_data.get(pagada) == 'Iniciada'
  form_data.set(pagada, 'Si')
}

form_data.set("entidades_fijas.entidad.pagada","Si") if form_data.get("entidades_fijas.entidad.pagada")=="Iniciada"

    end

    on_transition do
        error = false #Variable booleana
 _applicationId = @application["id"] #obteniendo el id
 _taskId = @task["id"] #id de la tarea
 ## Declaracion de arreglos para pagos y fechas
 arreglo_de_pagos = [] 
 arreglo_de_fechas = []
  #inicializacion de variables suma en cero y pago1 con el valor contenido dentro del campo monto total
  _suma = 0 
   pago1 = form_data.get("entidad_evaluadora_revisiones.monto_total.monto_total").to_f
   mensaje = ""
   
   #Inicio del ciclo each para obtener informacion de los datos del pago
	(1..15).each do |x|
		instance_x = "_instance_#{x}"
		monto = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.monto_del_pago")
		_suma = _suma.to_f + monto.to_f
		recibo = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.numero_de_recibo_deposito")
		fecha = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.fecha_del_pago")
		#monto = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.monto_del_pago")
		banco = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.banco")
		comprobante = form_data.get("datos_de_pago_p5#{instance_x}.datos_de_pago.comprobante_de_pago")	
	
			#verificacion para que todos los campos necesarios sean llenado
		if ((monto != "" && (recibo == "" || fecha == "" || banco == "" || comprobante == "")) ||
                   (recibo != ""  && (monto == "" || fecha == "" || banco == ""  || comprobante == "")) ||
                   (fecha != "" && (monto == "" || recibo == "" || banco == "" || comprobante == "")) ||
                   (banco != ""  && (monto == "" || recibo == "" || fecha == "" || comprobante == "")) ||
                  (comprobante != "" && (monto == "" || recibo == "" || fecha == "" || banco == "")))
			
				mensaje << "Los siguientes datos son requeridos en la instancia #{x}: Número de Recibo, Fecha de Pago, Monto del Pago, Banco y Comprobante del Pago. "
		else	
				#llenando l arreglo de pagos segun sean los datos introducidos en las instancias
				if (!monto.blank? && !recibo.blank? && !fecha.blank? && !banco.blank? && !comprobante.nil?)
						
					pagos = {"reference_number"=> "#{recibo}",
								"payment_date"=> "#{fecha}",
								"bank"=>"#{banco}",
								"amount"=>"#{monto}",
								"attachment_id"=>"#{comprobante}"
					}
					arreglo_de_pagos << pagos
						arreglo_de_fechas[x] = fecha
				end
		end
	 end
   

   if !mensaje.blank?
        error = true
		transition_errors << "#{mensaje}"
	end
			####### Validacion de fechas
			
	if (!error) #si no hubo error en la validacion anterior, se procede a evaular las fechas de los pagos
		(1..5).each do |j|
			
			fecha1 = arreglo_de_fechas[j].to_s	
				if  !fecha1.blank?
					if (fecha1.to_date > Date.today)
						error = true
						transition_errors << " La fecha del recibo del pago #{j} no debe ser mayor a la fecha actual. "
					end
				end
			
		end
	end

#################Validación monto del pago
	#si suma es mayor o menor al pago total, se incluira el mensaje de error	
	if (!error) #si no hubo error n la validacion de fechas se procede a verificar el monto total del pago
			if (_suma > pago1)
				error = true
				transition_errors << "El monto final de todos sus pagos #{_suma} es mayor al monto total a pagar  requerido #{pago1}. " 
					
			end
			if (_suma < pago1)
				error = true
				transition_errors << "El monto final de todos sus pagos #{_suma} es menor al monto total a pagar requerido #{pago1}. "
			end	
	end
		###### Validacion de Pago valido	
	if (!error) #si no hubo error en lo anterior se procede a registrar el pago
		result =  PaymentProxy.register_manual_payments(_applicationId,arreglo_de_pagos, _taskId)
		
		if (!result[:create]) 
                        error = true
			transition_errors << "Su pago no puede ser procesado dado que un Número de Deposito Introducido ya ha sido registrado. Por Favor Verifique. "
		end 
	end

if (!error)
  id_pago = form_data.get("variables_usadas_codigos_p5.variables_p5.payment")
  respuesta_del_agente = "OK"
  PaymentProxy.payment_reception(id_pago, respuesta_del_agente)
end

    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
