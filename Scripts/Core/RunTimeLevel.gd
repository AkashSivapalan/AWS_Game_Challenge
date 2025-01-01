#extends Node
#class_name RunTimeLevel
#
#signal level_started()
#
#@onready var level_name = name
#var max_score = 0
#var max_coins = 0
#
#
#func _ready():
	#print("Level Started")
	#emit_signal("level_started")
	#GameManager.level_beaten.connect(beat_level)
#
	#
#func beat_level():
	#LevelData.level_dic[LevelData.level_dic[level_name]["unlocks"]]["unlocked"] = true
	#LevelData.level_dic[level_name]["beaten"] = true
	#emit_signal("level_unlocked", level_name)
extends Node
class_name RunTimeLevel

signal level_started()
signal level_unlocked(level_name)
signal level_beaten()
signal level_completed()
@onready var level_name = name
var max_score = 0
var max_coins = 0

var elapsed_time: float = 0.0
var timer_active: bool = false

func _ready():
	print("Level Started")
	start_timer()
	GameManager.level_completed.connect(stop_timer_and_print)
	

func _process(delta: float) -> void:
	if timer_active:
		elapsed_time += delta

# Method to start the timer
func start_timer():
	elapsed_time = 0.0  # Reset timer to 0
	timer_active = true
	print("Timer started.")

# Method to stop the timer and print the time
func stop_timer_and_print():
	timer_active = false
	print("Timer stopped.")
	print("Level completed in:", format_time(elapsed_time))
	beat_level()

# Format the time to MM:SS format
func format_time(time: float) -> String:
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return "%02d:%02d" % [minutes, seconds]

func beat_level():
	LevelData.level_dic[LevelData.level_dic[level_name]["unlocks"]]["unlocked"] = true
	LevelData.level_dic[level_name]["beaten"] = true
	emit_signal("level_unlocked", level_name)
