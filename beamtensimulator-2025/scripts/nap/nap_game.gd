extends Node2D

# === NODES ===
@onready var bg_normal      = $BackgroundNormal
@onready var bg_boss        = $BackgroundWithBoss
@onready var label_status   = $StatusLabel
@onready var timer_boss     = $TimerBoss
@onready var timer_footstep = $TimerFootstep
@onready var audio_steps    = $AudioBossSteps

# === SPIELSTATUS ===
var sleep_time = 0.0
var caught     = false

func _ready():
	randomize()
	bg_normal.visible = true
	bg_boss.visible   = false
	label_status.text = ""
	caught = false
	sleep_time = 0.0

	# Signale verbinden
	timer_boss.timeout.connect(_on_TimerBoss_timeout)
	timer_footstep.timeout.connect(_on_TimerFootstep_timeout)

	# Zufällige Zeit bis Boss-Auftritt (3–15 s)
	var wait_time = randf_range(3.0, 10.0)
	timer_boss.wait_time     = wait_time
	timer_footstep.wait_time = max(wait_time - 2.0, 0.1)

	timer_boss.start()
	timer_footstep.start()
	set_process(true)

func _process(delta):
	var sleeping = Input.is_action_pressed("ui_accept")
	if sleeping and not caught:
		sleep_time += delta
		label_status.text = "Zzz... " + str(round(sleep_time * 10) / 10.0) + "s"
	elif not caught:
		label_status.text = "Wachsam!"

func _on_TimerFootstep_timeout():
	# Schritte exakt 2 s vor dem Boss
	audio_steps.play()
	await get_tree().create_timer(2.0).timeout
	audio_steps.stop()

func _on_TimerBoss_timeout():
	# Abfragen, ob aktuell geschlafen wird
	var sleeping = Input.is_action_pressed("ui_accept")

	# Boss erscheint
	bg_normal.visible = false
	bg_boss.visible   = true

	if sleeping:
		caught = true
		label_status.text = "Erwischt!"
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
		return
	else:
		label_status.text = "Beinahe erwischt!"

		# Boss bleibt 2–4 Sekunden, dann verschwindet er
		var vanish_time = randf_range(2.0, 4.0)
		await get_tree().create_timer(vanish_time).timeout

		# Zurück zum normalen Zustand
		bg_boss.visible   = false
		bg_normal.visible = true
		label_status.text = "Wachsam!"
		# sleep_time bleibt erhalten!

		# Nächsten Zufallstimer setzen und starten
		var next_wait = randf_range(3.0, 15.0)
		timer_boss.wait_time     = next_wait
		timer_footstep.wait_time = max(next_wait - 2.0, 0.1)
		timer_boss.start()
		timer_footstep.start()


func _input(event):
	# Nur nach Ende der Sitzung auf ESC reagieren
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_office.tscn")
