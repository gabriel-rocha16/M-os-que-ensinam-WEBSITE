user = Usuario.joins(:candidato).first
candidato = user.candidato

params = {
  candidato: {
    beneficios_lista: ["Auxílio Brasil", "Outros..."],
    outro_beneficio: "Vale Gás",
    deficiencias_lista: ["Deficiência Física", "Outros..."],
    tipo_deficiencia: "Amputação de membro"
  }
}

puts "Antes do Update:"
puts "Benefícios: #{candidato.beneficios.pluck(:nome)}"
puts "Deficiências: #{candidato.deficiencias.pluck(:tipo)}"

candidato.assign_attributes(params[:candidato])
candidato.save!(validate: false)

puts "Após Update:"
puts "Benefícios: #{candidato.beneficios.pluck(:nome)}"
puts "Deficiências: #{candidato.deficiencias.pluck(:tipo)}"
puts "Tipo deficiencia em texto: #{candidato.tipo_deficiencia}"
