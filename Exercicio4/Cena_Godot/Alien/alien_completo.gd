extends Node3D

@onready var animation_tree = $AnimationTree

func _ready() -> void:
	# Garante que a árvore está ativa
	animation_tree.active = true
	
	# Obtém o playback e força a iniciar a animação
	var playback = animation_tree.get("parameters/playback")
	if playback:
		playback.start("Old Man Idle")

func _unhandled_input(event: InputEvent) -> void:
	var playback = animation_tree.get("parameters/playback")
	if not playback:
		return
		
	if event.is_action_pressed("ui_accept"):
		var current_state = playback.get_current_node()
		
		if current_state == "Old Man Idle":
			playback.travel("Happy_Idle")
		elif current_state == "Happy_Idle":
			playback.travel("Sad Idle")
		else:
			playback.travel("Old Man Idle")
