extends Node2D

@onready var level_holder = $LevelHolder
@onready var button_holder = $ButtonHolder
@onready var player = $Player
var levels = []
@onready var curr_level = $LevelHolder/Level1

var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1

func _ready() -> void:
	player.get_node("AnimationPlayer").play("IDLE")
	levels = level_holder.get_children()
	update_levels()

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

func _process(delta: float) -> void:
	var target_level: Node2D
	if Input.is_action_just_pressed("ui_left"):
		print("left")
		if curr_level.left:
			target_level = curr_level.left
			print(curr_level.global_position)

	if Input.is_action_just_pressed("ui_right"):
		print("right")
		if curr_level.right:
			target_level = curr_level.right
			print(curr_level.right.global_positon)
	if Input.is_action_just_pressed("ui_accept"):
		player.get_node("AnimationPlayer").play("SELECT")
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://Scenes/WorldScenes/" + curr_level.name + ".tscn")

	if target_level and target_level.name in LevelData.level_dic and LevelData.level_dic[target_level.name]["unlocked"] and completed_movement:
		completed_movement = false
		player.get_node("AnimationPlayer").play("RUN")
		lerp_progress = 0.0
		while lerp_progress < 1.0:
			lerp_progress += lerp_speed * delta
			lerp_progress = clamp(lerp_progress, 0.0, 1.0)
			player.global_position = player.global_position.lerp(target_level.global_position, lerp_progress)

			if player.global_position.distance_to(target_level.global_position) < lerp_threshold:
				break
			
			await get_tree().create_timer(delta).timeout
		player.global_position = target_level.global_position
		curr_level = target_level
		player.get_node("AnimationPlayer").play("IDLE")
		completed_movement = true
		
		print("Player position: ", player.global_position)
		print("Target position: ", target_level.global_position)


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
