extends Control
var playerID_field: LineEdit
var password_field: LineEdit
var http_request: HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerID_field = $NinePatchRect/VBoxContainer/PlayerID_Field
	password_field = $NinePatchRect/VBoxContainer/PasswordField
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_world_map_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")


func _on_register_pressed() -> void:
	var playerID = playerID_field.text
	var password = password_field.text

	if playerID == "" or password == "":
		print("Player ID and password cannot be empty.")
		return

	var api_url = "https://7dkfknysrd.execute-api.us-east-1.amazonaws.com/register" # Replace with your API Gateway URL
	var headers = ["Content-Type: application/json"]
	var body = {
		"playerId": playerID,
		"password": password,
	}

	http_request.request(api_url, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("Registration Successful")
	else:
		print("Error with code:", response_code, "Response:", body.get_string_from_utf8())
