extends Control

var email_field: LineEdit
var password_field: LineEdit

func _ready():
	# Get the LineEdit nodes by their paths
	email_field = $NinePatchRect/VBoxContainer/EmailField
	password_field = $NinePatchRect/VBoxContainer/PasswordField


func _on_login_pressed() -> void:
	var email = email_field.text
	var password = password_field.text
	print(email)
	print(password)


func _on_world_map_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")
