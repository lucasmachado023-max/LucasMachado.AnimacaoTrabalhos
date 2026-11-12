extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
#código acima comentado é o defaut de quando gera um novo script

#@onready var cubo: MeshInstance3D = $MeshIntance3D
#Referencia para o cubo que vou movimentar, porém só é utilizado se o script
#não estiver vinculado ao cubo. Precisei de algumas quebras de cabeça para
#descobrir isso.

#Quero que o cubo percorra um quadrado na tela
#então criei um vector com as posições a se percorrer
var pontos: Array[Vector3] = [
	Vector3(-2, 1, -2), #se o chão estiver em 0, tem que aumentar o Y
	Vector3(2 , 1, -2), #se não o cubo se enterra e não da para ver
	Vector3(2, 1, 2), #as linhas sendo desenhadas no chão
	Vector3(-2, 1, 2)	
]

var indice_origem: int = 0
#ponto da origem atual do array

var progresso: float = 0.0
#variavel de progresso na interpolação, vai de 0 a 1

@export var velocidade: float = 0.8
# Velocidade do cubo


var desenha_linha: ImmediateMesh
var material_linha: StandardMaterial3D
#variáveis para deenhar a linha na tela
#serve para acompanhar o movimento linear, para deixar bem visível

func _ready() -> void:
	desenha_linha = ImmediateMesh.new() 
	#inicia a malha para desenhar a linha
	
	#comandos abaixo são para criar o material e a cor da linha
	material_linha = StandardMaterial3D.new()
	material_linha.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_linha.albedo_color = Color(0, 0.5, 0)   
	
	#esse novo meshinstance é para poder desenhar na tela, sem esse trecho
	#não funciona
	var instancia_linha = MeshInstance3D.new()
	instancia_linha.mesh = desenha_linha
	instancia_linha.material_override = material_linha
	add_child(instancia_linha)
	
	#agora é posicionar o cubo no primeiro ponto 
	global_position = pontos[0]
	
	
func _process(delta: float) -> void:
	progresso += delta * velocidade 
	#processo muito parecido feito nos blueprints com os nodos
	
	#se o progresso atingir ou ultrapassar num1, vai pro seguimento seguinte
	if progresso >= 1.0:
		progresso = 0.0 #reseta a variável
		indice_origem = (indice_origem +1) % pontos.size() #avança o índice
	
	var indice_destino: int = (indice_origem + 1) % pontos.size()
	#calcula o índice do próximo destino
	
	var pos_inicio: Vector3 = pontos[indice_origem]
	var pos_fim: Vector3 = pontos[indice_destino]
	#obtem os pontos de origem e destino para o percurso
	
	global_position = pos_inicio.lerp(pos_fim, progresso)
	#aqui to aplicando a interpolaçao linear (tbm parecido com os nodos da unreal)
	#necessário para calcular a nova posição do cubo
	
	#atualiza o desenho das linhas do quadrado
	#sem problemas chamar antes uma funcao que será montada após
	desenhar_trajetoria()
	
func desenhar_trajetoria() -> void:
	desenha_linha.clear_surfaces()
	#limpar os vértices anteriores que estiverem na malha da linha
		
	desenha_linha.surface_begin(Mesh.PRIMITIVE_LINES)
	#iniciar uma nova estrutura de linhas
		
	for i in range(indice_origem):
		desenha_linha.surface_add_vertex(pontos[i]) #Ponto inicial
		desenha_linha.surface_add_vertex(pontos[i + 1]) #Ponto final
		
	desenha_linha.surface_add_vertex(pontos[indice_origem]) #Inicio do segumento
	desenha_linha.surface_add_vertex(global_position) #Acompanhar cubo
		
	desenha_linha.surface_end()
	

	
	
	
	
	
	
	
	
	
	
	
	
	
