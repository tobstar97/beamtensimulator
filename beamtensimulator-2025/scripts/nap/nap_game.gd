extends Node2D

@onready var bg_normal = $BackgroundNormal
@onready var bg_boss = $BackgroundWithBoss
@onready var label_status = $StatusLabel
@onready var timer_boss = $TimerBoss
@onready var audio_steps = $AudioBossSteps

var sleeping = false
var caught = false
var sleep_time = 0.0

func _ready():
	randomize()
	bg_normal.visible = true
	bg_boss.visible = false
	label_status.text = ""
	timer_boss.timeout.connect(_on_TimerBoss_timeout)
	timer_boss.wait_time = randf_range(3.0, 15.0)
	timer_boss.start()


func _process(delta):
	if sleeping and not caught:
		sleep_time += delta
		label_status.text = "Zzz... " + str(round(sleep_time * 10) / 10.0) + "s"
	elif not caught:
		label_status.text = "Wachsam!"

func _input(event):
	if event.is_action_pressed("ui_accept"):
		sleeping = true
	elif event.is_action_released("ui_accept"):
		sleeping = false

func _on_TimerBoss_timeout():
	audio_steps.play()
	bg_normal.visible = false
	bg_boss.visible = true

	if sleeping:
		caught = true
		label_status.text = "Erwischt!"
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
	else:
		label_status.text = "Beinahe erwischt!"
		await get_tree().create_timer(1.5).timeout

		# Zurück zum normalen Hintergrund
		bg_boss.visible = false
		bg_normal.visible = true
		label_status.text = "Wachsam!"
		
		timer_boss.wait_time = randf_range(3.0, 8.0)
		timer_boss.start()
