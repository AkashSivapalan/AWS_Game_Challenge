extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if area.get_parent().health < area.get_parent().max_health:
			area.get_parent().health += 1
			area.get_parent().update_health()
		queue_free()