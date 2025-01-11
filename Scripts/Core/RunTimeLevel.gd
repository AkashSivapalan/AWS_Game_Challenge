
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

@onready var http_request= $HTTPRequest

func _ready():
	print("Level Started")
	http_request.request_completed.connect(_on_http_request_request_completed)
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
	
	var current_time = LevelData.level_dic[level_name]["time"]
	if current_time == null || elapsed_time < current_time:
		LevelData.level_dic[level_name]["time"] = elapsed_time
		
	emit_signal("level_unlocked", level_name)
	
	if UserData.PlayerLogin:
		var api_url = "https://7dkfknysrd.execute-api.us-east-1.amazonaws.com/updateLevels" 
		var headers = ["Content-Type: application/json"]
		
		var updatedLevels = [level_name,LevelData.level_dic[LevelData.level_dic[level_name]["unlocks"]]]
		var levels = []
		for level_Selected in LevelData.level_dic.keys():
			var level_info = LevelData.level_dic[level_Selected]
			levels.append({
				"name": level_Selected,
				"unlocked": level_info["unlocked"],
				"beaten": level_info["beaten"],
				"time":level_info["time"],
			})
		var body = {
			"playerId": UserData.PlayerId,
			"levels": levels
		}
		
		print(body)
		http_request.request(api_url, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))
	
func _on_http_request_request_completed(result, response_code, headers, body):
	print(response_code)
	if response_code == 200:
		print("Successful Update")

#func checkResponse(result, response_code, headers, body):
	#if response_code == 200:
		#print("Successful Update")
#
#func _on_http_request_1_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	#checkResponse(result, response_code, headers, body)
