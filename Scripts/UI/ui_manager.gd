extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.pause_menu = $PauseMenu
	GameManager.win_screen = $WinScreen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_Play()
		get_tree().paused = GameManager.pause


func _on_quit_pressed() -> void:
	GameManager.quit()


func _on_world_map_pressed() -> void:
	GameManager.load_world()


func _on_restart_pressed() -> void:
	GameManager.restart()

func _on_resume_pressed() -> void:
	GameManager.resume()


func _on_finish_level_pressed() -> void:
	GameManager.load_world()
