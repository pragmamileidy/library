
  class Paso4AdjuntarArchivos < TemplateCode::Step

    on_becoming do
      # USADO PARA PRINT DESIGN HORARIO DE REGENCIA
#lunes a viernes
horario_semana = ""
semana_inicio = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_apertura")
semana_fin = form_data.get("horario_de_regencia.lunes_a_viernes.hora_de_cierre")
if (semana_inicio.present? && semana_fin.present?)
    horario_semana += "#{semana_inicio} a #{semana_fin}"
elsif ( !semana_inicio.present? && semana_fin.present?)
    horario_semana += "N/A a #{semana_fin}"
elsif (semana_inicio.present? && !semana_fin.present?)
    horario_semana += "#{semana_inicio} a N/A"
end
form_data.set("horario_de_regencia.lunes_a_viernes.campo_oculto",horario_semana)

#sabados
horario_sabado = ""
sabado_inicio = form_data.get("horario_de_regencia.sabados.hora_de_apertura")
sabado_fin = form_data.get("horario_de_regencia.sabados.hora_de_cierre")
if (sabado_inicio.present? && sabado_fin.present?)
    horario_sabado += "#{sabado_inicio} a #{sabado_fin}"
elsif ( !sabado_inicio.present? && sabado_fin.present?)
    horario_sabado += "N/A a #{sabado_fin}"
elsif (sabado_inicio.present? && !sabado_fin.present?)
    horario_sabado += "#{sabado_inicio} a N/A"
end
form_data.set("horario_de_regencia.sabados.campo_oculto",horario_sabado)

#domingos
horario_domingo = ""
domingo_inicio = form_data.get("horario_de_regencia.domingos.hora_de_apertura")
domingo_fin = form_data.get("horario_de_regencia.domingos.hora_de_cierre")
if (domingo_inicio.present? && domingo_fin.present?)
    horario_domingo += "#{domingo_inicio} a #{domingo_fin}"
elsif ( !domingo_inicio.present? && domingo_fin.present?)
    horario_domingo += "N/A a #{domingo_fin}"
elsif (domingo_inicio.present? && !domingo_fin.present?)
    horario_domingo += "#{domingo_inicio} a N/A"
end
form_data.set("horario_de_regencia.domingos.campo_oculto",horario_domingo)

#feriados
horario_feriado = ""
feriado_inicio = form_data.get("horario_de_regencia.feriados.hora_de_apertura")
feriado_fin = form_data.get("horario_de_regencia.feriados.hora_de_cierre")
if (feriado_inicio.present? && feriado_fin.present?)
    horario_feriado += "#{feriado_inicio} a #{feriado_fin}"
elsif ( !feriado_inicio.present? && feriado_fin.present?)
    horario_feriado += "N/A a #{feriado_fin}"
elsif (feriado_inicio.present? && !feriado_fin.present?)
    horario_feriado += "#{feriado_inicio} a N/A"
end
form_data.set("horario_de_regencia.feriados.campo_oculto",horario_feriado)


# USADO PARA PRINT DESIGN horario_de_supervision_farmaceutica
#lunes a viernes
horario_semana = ""
semana_inicio = form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_apertura")
semana_fin = form_data.get("horario_de_supervision_farmaceutica.lunes_a_viernes.hora_de_cierre")
if (semana_inicio.present? && semana_fin.present?)
    horario_semana += "#{semana_inicio} a #{semana_fin}"
elsif ( !semana_inicio.present? && semana_fin.present?)
    horario_semana += "N/A a #{semana_fin}"
elsif (semana_inicio.present? && !semana_fin.present?)
    horario_semana += "#{semana_inicio} a N/A"
end
form_data.set("horario_de_supervision_farmaceutica.lunes_a_viernes.campo_oculto",horario_semana)

#sabados
horario_sabado = ""
sabado_inicio = form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_apertura")
sabado_fin = form_data.get("horario_de_supervision_farmaceutica.sabados.hora_de_cierre")
if (sabado_inicio.present? && sabado_fin.present?)
    horario_sabado += "#{sabado_inicio} a #{sabado_fin}"
elsif ( !sabado_inicio.present? && sabado_fin.present?)
    horario_sabado += "N/A a #{sabado_fin}"
elsif (sabado_inicio.present? && !sabado_fin.present?)
    horario_sabado += "#{sabado_inicio} a N/A"
end
form_data.set("horario_de_supervision_farmaceutica.sabados.campo_oculto",horario_sabado)

#domingos
horario_domingo = ""
domingo_inicio = form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_apertura")
domingo_fin = form_data.get("horario_de_supervision_farmaceutica.domingos.hora_de_cierre")
if (domingo_inicio.present? && domingo_fin.present?)
    horario_domingo += "#{domingo_inicio} a #{domingo_fin}"
elsif ( !domingo_inicio.present? && domingo_fin.present?)
    horario_domingo += "N/A a #{domingo_fin}"
elsif (domingo_inicio.present? && !domingo_fin.present?)
    horario_domingo += "#{domingo_inicio} a N/A"
end
form_data.set("horario_de_supervision_farmaceutica.domingos.campo_oculto",horario_domingo)

#feriados
horario_feriado = ""
feriado_inicio = form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_apertura")
feriado_fin = form_data.get("horario_de_supervision_farmaceutica.feriados.hora_de_cierre")
if (feriado_inicio.present? && feriado_fin.present?)
    horario_feriado += "#{feriado_inicio} a #{feriado_fin}"
elsif ( !feriado_inicio.present? && feriado_fin.present?)
    horario_feriado += "N/A a #{feriado_fin}"
elsif (feriado_inicio.present? && !feriado_fin.present?)
    horario_feriado += "#{feriado_inicio} a N/A"
end
form_data.set("horario_de_supervision_farmaceutica.feriados.campo_oculto",horario_feriado)
    end

    on_transition do
      
    end

    AJAX_CALLS <<-STEPAJAXCODE 
      
    STEPAJAXCODE
  end
            
