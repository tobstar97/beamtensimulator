extends Node2D

# === NODES ===
@onready var background       = $TextureRect
@onready var input_coffee     = $LineEdit
@onready var button_start     = $Button
@onready var label_instr      = $LabelInstruction
@onready var label_timer      = $LabelTimer
@onready var timer_session    = $TimerSession
@onready var audio_toilet     = $AudioStreamPlayer

# === KONSTANTEN ===
const TIME_PER_COFFEE = 5.0  # Sekunden pro Kaffee
const TIME_PER_COFFEE = 10.0  # Sekunden pro Kaffee
const OFFICE_SCENE    = "res://scenes/main_office.tscn"  # Pfad zur Büroszene

# === SPIELSTATUS ===
var total_time      = 0.0
var session_finished = false

func _ready():
	# Initial-UI
	label_instr.visible    = true
	label_timer.visible    = false
	label_instr.text       = "Wie viele Kaffees hast du getrunken?"
	button_start.disabled  = false
	input_coffee.editable  = true
	session_finished       = false

	# Signale verbinden
	button_start.pressed.connect(_on_Button_start)
	timer_session.timeout.connect(_on_Timer_timeout)

	# Toilet-Audio pausieren
	audio_toilet.stream_paused = true

func _on_Button_start() -> void:
	var coffees = int(input_coffee.text)
	if coffees < 1:
		label_instr.text = "Bitte eine positive Zahl eingeben!"
		return

	# Berechne gesamte Sitzdauer
	total_time = coffees * TIME_PER_COFFEE

	# UI umschalten
	label_instr.visible    = false
	input_coffee.visible   = false
	button_start.visible   = false
	label_timer.visible    = true
	session_finished       = false

	# Timer starten
	timer_session.wait_time = total_time
	timer_session.one_shot  = true
	timer_session.start()

	# Toilet-Audio starten
	audio_toilet.stream_paused = false
	audio_toilet.play()

	set_process(true)

func _process(delta: float) -> void:
	if timer_session.time_left > 0:
		var t = timer_session.time_left
		var display = round(t * 10) / 10.0
		label_timer.text = str(display) + "s verbleibend"
	elif not session_finished:
		# Übergang in Fertig-Zustand
		label_timer.text = "Fertig! 🚽\nDrücke ESC zum Büro"
		session_finished = true
		set_process(false)

func _on_Timer_timeout() -> void:
	# Toilet-Audio stoppen
	audio_toilet.stop()
	audio_toilet.stream_paused = true
	# _process() kümmert sich um das Fertig-Label

func _input(event):
	# Nur nach Ende der Sitzung auf ESC reagieren
	if session_finished and event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_office.tscn")
