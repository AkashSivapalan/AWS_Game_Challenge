extends Node2D

@onready var level_holder = $LevelHolder
@onready var button_holder = $ButtonHolder
@onready var player = $Player
var levels = []
@onready var curr_level = $LevelHolder/Level1

@onready var http_request = $HTTPRequest

var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1
var pause_menu


func _ready() -> void:

	pause_menu = $UIManager/PauseMenu
	pause_menu.visible = false
	var loginBtn = $ButtonHolder/Login
	var RegBtn = $ButtonHolder/Register
	var LgtBtn = $ButtonHolder/Logout
	
	http_request.request_completed.connect(_on_http_request_request_completed)
	
	if UserData.PlayerLogin:
		loginBtn.visible = false
		RegBtn.visible = false
	else:
		LgtBtn.visible = false
	
	player.get_node("AnimationPlayer").play("IDLE")
	levels = level_holder.get_children()
	update_levels()
	
	var label_l1 = $LevelHolder/Level1/LabelL1
	var label_l2 = $LevelHolder/Level2/LabelL2
	var label_l3 = $LevelHolder/Level3/LabelL3
	
	print(LevelData.level_dic)
	if LevelData.level_dic["Level1"]["time"] != null:
		label_l1.text = format_time(LevelData.level_dic["Level1"]["time"])
	if LevelData.level_dic["Level2"]["time"] != null:
		print("here", format_time(LevelData.level_dic["Level2"]["time"]))
		label_l2.text = format_time(LevelData.level_dic["Level2"]["time"])
	if LevelData.level_dic["Level3"]["time"] != null:
		label_l3.text = format_time(LevelData.level_dic["Level3"]["time"])

func format_time(time: float) -> String:
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return "%02d:%02d" % [minutes, seconds]

func update_levels():
	for level_name in LevelData.level_dic.keys():
		# Access level data
		var level_data = LevelData.level_dic[level_name]

		# Update level sprite in LevelHolder
		var level_sprite = level_holder.get_node_or_null(level_name)
		if level_sprite:
			var sprite = level_sprite.get_node("Sprite2D")
			if level_data["unlocked"]:
				sprite.texture = load("res://Imports/WorldMap/key.png")
				if level_data["beaten"]:
					sprite.texture = load("res://Imports/WorldMap/flag.png")
			else:
				sprite.texture = load("res://Imports/WorldMap/cross.png")

		# Update button in ButtonHolder
		var button = button_holder.get_node_or_null(level_name) # Ensure this resolves to a valid node path
		if button:
			button.disabled = not level_data["unlocked"]

# Called when a level is unlocked
func _on_level_unlocked(level_name):
	print("Level unlocked:", level_name)
	update_levels()


func _on_level_1_pressed() -> void:
	change_Level("Level1")


func _on_level_2_pressed() -> void:
	change_Level("Level2")


func _on_level_3_pressed() -> void:
	change_Level("Level3")
	

func change_Level(level_name: String):
	if LevelData.level_dic[level_name]["unlocked"]:
		get_tree().change_scene_to_file("res://Scenes/WorldScenes/" + level_name + ".tscn")
	else:
		print("Level is locked:", level_name)


func _on_login_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/login_screen.tscn")


func _on_register_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/register.tscn")


func _on_logout_pressed() -> void:
	if UserData.PlayerLogin:
		UserData.PlayerId = null
		UserData.PlayerLogin = false
		LevelData.level_dic = {
	"Level1": {
		"unlocked": true,
		"score": 0,
		"unlocks": "Level2",
		"time": null,
		"beaten": false
	},
		"Level2": {
		"unlocked": false,
		"score": 0,
		"unlocks": "Level3",
		"time": null,
		"beaten": false
	},
		"Level3": {
		"unlocked": false,
		"score": 0,
		"unlocks": "Level1",
		"time": null,
		"beaten": false
	}
}
	get_tree().change_scene_to_file("res://Scenes/login_screen.tscn")
	
	
func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Successful Request")

		var response_body = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse_string(response_body)
		
		var records = parse_result.topTimes
		var cnt = 0
		for entry in records:
			cnt += 1
			var player_name = entry["playerId"]
			var level_time = format_time(entry["time"])
			
			var namePath = "UIManager/PauseMenu/VBoxContainer/HBoxContainer" + str(cnt) + "/name"
			var nameLbl = get_node(namePath)
			nameLbl.text = player_name
			
			var timePath = "UIManager/PauseMenu/VBoxContainer2/HBoxContainer" + str(cnt) + "/time"
			var timeLbl = get_node(timePath)
			timeLbl.text = level_time

		if cnt == 0:
			var namePath = "UIManager/PauseMenu/VBoxContainer/HBoxContainer1/name"
			var nameLbl = get_node(namePath)
			nameLbl.text = "No Records"
		pause_menu.visible = true


func _on_leaderboard_1_pressed() -> void:
	getLeaderboard("Level1")

func getLeaderboard(levelName):
	var api_url = "https://7dkfknysrd.execute-api.us-east-1.amazonaws.com/topTimes/" + levelName
	print(api_url)
	var headers = ["Content-Type: application/json"]
	http_request.request(api_url, headers, HTTPClient.METHOD_GET)


func _on_leaderboard_2_pressed() -> void:
	getLeaderboard("Level2")


func _on_leaderboard_3_pressed() -> void:
	getLeaderboard("Level3")


func _on_quit_pressed() -> void:
	pause_menu.visible = false
