extends Node2D

@export var return_scene = "res://scenes/main_office.tscn"
var progress := 0.0
var help_visible := false

@onready var progress_bar := $ProgressBar
@onready var label_hint := $HintLabel

func _ready():
	progress = 0
	progress_bar.value = progress
	label_hint.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		progress += 5
		progress_bar.value = progress
		if progress >= 100:
			progress = 100
			progress_bar.value = progress
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(return_scene)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file(return_scene)

	if Input.is_action_just_pressed("h"):
		help_visible = not help_visible
		label_hint.visible = help_visible
