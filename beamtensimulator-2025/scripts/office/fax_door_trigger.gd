extends Area2D

@export var target_scene_path: String
var player_inside = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(target_scene_path)
