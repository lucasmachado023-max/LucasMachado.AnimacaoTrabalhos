extends Node3D

# Interação com a tecla 1
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1 or event.keycode == KEY_KP_1:
			mudar_degrade_aleatorio()

# Função para aleatorizar as cores
func mudar_degrade_aleatorio() -> void:
	
	var cor_inicial = Color(randf(), randf(), randf())
	var cor_final = Color(randf(), randf(), randf())
	
	# Criar recurso de Gradiente na Godot
	var gradiente = Gradient.new()
	gradiente.set_color(0, cor_inicial)
	gradiente.set_color(1, cor_final)
	
	# Transformar o gradiente numa textura 2D - Gemini me ajudou nesse função, pois a primeira que eu fiz trocava a cor de apenas 1 triangulo.
	var textura_degrade = GradientTexture2D.new()
	textura_degrade.gradient = gradiente
	
	textura_degrade.fill_from = Vector2(randf(), randf())
	textura_degrade.fill_to = Vector2(randf(), randf())
	
	# Aplicar textura no objeto 
	aplicar_textura_recursivo(self, textura_degrade)

#funcao para as validacoes e aplicacoes das texturas, recebe a textura e o nó da cena para fazer as mudanças
func aplicar_textura_recursivo(no: Node, textura: Texture2D) -> void:
	if no is MeshInstance3D and no.mesh: #validação se é um objeto 3D, afim de evitar erros
		for surface_idx in range(no.mesh.get_surface_count()): #percorrer a superfície do obj 
			var mat = no.get_surface_override_material(surface_idx)
			#validação se possui material, não vai funciona se não criar um material do zero nos modelos que importei 
			if mat == null:
				var mat_ativo = no.get_active_material(surface_idx)
				if mat_ativo:
					mat = mat_ativo.duplicate()
				else:
					mat = StandardMaterial3D.new()
				no.set_surface_override_material(surface_idx, mat)
			
			if mat is StandardMaterial3D or mat is ORMMaterial3D:
				# Reseta a cor para branco puro, sem esse passo o degradê fica estranho 
				mat.albedo_color = Color.WHITE
				# Aplica a textura do degradê 
				mat.albedo_texture = textura
 	
		#caso tenha nós filhos, vai ser aplicado também. acabei não usando, mas ta pronto para uma possível reutilização do código
	for filho in no.get_children():
		aplicar_textura_recursivo(filho, textura)
