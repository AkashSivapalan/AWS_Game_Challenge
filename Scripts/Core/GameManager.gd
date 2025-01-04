
extends Node

signal level_beaten()
signal level_completed()
var current_checkpoint: Checkpoint
var coins: int

var player: Player
var pause = false
var pause_menu
var win_screen

var elapsed_time: float = 0.0
var timer_active: bool = false

func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.global_position = current_checkpoint.global_position

func _ready():
	pause_menu = $PauseMenu
	win_screen = $WinScreen

func _on_level_started():
	# Your method code here, for example:
	print("Level has started!")
	start_timer() # Call the function that starts the timer


func start_timer():
	elapsed_time = 0.0 # Reset timer to 0
	timer_active = true
	print("Timer started.")

func stop_timer():
	timer_active = false
	print("Timer stopped.")
	print(elapsed_time)
	print(format_time(elapsed_time))

func pause_Play():
	pause = !pause
	pause_menu.visible = pause

func resume():
	get_tree().paused = false
	pause_Play()

func restart():
	current_checkpoint = null
	elapsed_time = 0.0 # Reset the timer
	get_tree().paused = false
	get_tree().reload_current_scene()

func load_world():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")

func quit():
	get_tree().quit()

func win():
	#stop_timer()
	emit_signal("level_beaten")
	emit_signal("level_completed")
	win_screen.visible = true

func _on_level_beaten():
	print("Level completed in:", format_time(elapsed_time))

func format_time(time: float) -> String:
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return "%02d:%02d" % [minutes, seconds]
