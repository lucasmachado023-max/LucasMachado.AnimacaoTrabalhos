extends MeshInstance3D

#Montando os pontos da curva de BEZIER
var p0: Vector3 = Vector3(-8, 1.0, -4) # o ponto que vai iniciar a curva
var p1: Vector3 = Vector3(0, 1.0, -10) # Ponto que puxa a curva
var p2: Vector3 = Vector3(8, 1.0, -4) # Ponto final da curva

var progresso: float = 0.0 
#variavel para controle

@export var velocidade: float = 0.5

#criar variáveis para desenhar a trejatória na tela
var desenha_linha: ImmediateMesh
var material_linha: StandardMaterial3D

#Num de segumentos para mandar a curva suave, usei 30 igual o exemplo que 
#encontrei no youtube, gostei bastante da suavidade
var suavidade_desenho: int = 30

func _ready() -> void:
	#mesmo esquema do código linear para criacao da linha
	desenha_linha = ImmediateMesh.new()
	material_linha = StandardMaterial3D.new()
	material_linha.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_linha.albedo_color = Color(0, 0.8, 1) #usar Azul para diferenciar
	
	#criação da malha para o desenho da linha
	var instancia_linha = MeshInstance3D.new()
	instancia_linha.mesh = desenha_linha
	instancia_linha.material_override = material_linha
	
	#deixar a linha independente do cubo
	instancia_linha.top_level = true
	add_child(instancia_linha)
	
	#cubo agora vai para o ponto inicial da curva
	global_position = p0
	
func _process(delta: float) -> void:
	#progresso é incrementado de 0 a 1, igual no código da linha linear
	progresso += delta * velocidade
	
	#reiniciar o ciclo quando chega n o fim da curva
	if progresso >= 1.0:
		progresso = 0.0 #não esquecer dos espaços corretos 
	
	#CALCULO DA BEZIER - - - - - - - - - - - - - - - - - - - - - -!!!!!
	global_position = p0.bezier_interpolate(p1, p1, p2, progresso) #utilizando a própria funcao bezier da godot
	desenhar_trajetoria_bezier() 
	#desenha o trajeto 
	
func desenhar_trajetoria_bezier() -> void:
	desenha_linha.clear_surfaces() 
	desenha_linha.surface_begin(Mesh.PRIMITIVE_LINES)
	
	#calculo dos passos da curva que já foram dados
	var passos_atuais: int = int(progresso * suavidade_desenho)
	var ponto_anterior: Vector3 = p0
	
	#for do desenho da curva
	for i in range(1, passos_atuais +1):
		var t: float = float(i) / float(suavidade_desenho)
		var ponto_atual: Vector3 = p0.bezier_interpolate(p1, p2, p2, t) #calculo Bezier
		
		desenha_linha.surface_add_vertex(ponto_anterior)
		desenha_linha.surface_add_vertex(ponto_atual)
		
		ponto_anterior = ponto_atual
		#código para "surfar" de um ponto para o próximo
		
	
	#passa os pontos para o desenha linha
	desenha_linha.surface_add_vertex(ponto_anterior)
	desenha_linha.surface_add_vertex(global_position)
	
	desenha_linha.surface_end()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
