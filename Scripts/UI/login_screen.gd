extends Control

var playerID_field: LineEdit
var password_field: LineEdit
var http_request: HTTPRequest

func _ready():
	# Get the LineEdit nodes by their paths
	playerID_field = $NinePatchRect/VBoxContainer/PlayerID_Field
	password_field = $NinePatchRect/VBoxContainer/PasswordField
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))



func _on_login_pressed() -> void:
	var playerID = playerID_field.text
	var password = password_field.text
	
	if playerID == "" or password == "":
		print("Player ID and password cannot be empty.")
		return

	var api_url = "https://7dkfknysrd.execute-api.us-east-1.amazonaws.com/login" 
	var headers = ["Content-Type: application/json"]
	var body = {
		"playerId": playerID,
		"password": password,
	}

	http_request.request(api_url, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))



func _on_world_map_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")


func _on_register_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/register.tscn")


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("Login Successful")
		
		var response_body = body.get_string_from_utf8()

		var json = JSON.new()
		var parse_result = json.parse_string(response_body)
		
		var levels = parse_result.levels
				
				# Update the dictionary with the response
		for level in levels:
			var level_name = level["name"]  # Access by key as it's a dictionary
			if level_name in LevelData.level_dic:
				LevelData.level_dic[level_name]["unlocked"] = level["unlocked"]
				LevelData.level_dic[level_name]["beaten"] = level["beaten"]
				LevelData.level_dic[level_name]["time"] = level["time"]
		UserData.PlayerLogin=true
		UserData.PlayerId=playerID_field.text
		get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")
	else:
		print("Error with code:", response_code, "Response:", body.get_string_from_utf8())
