extends Node2D
class_name Coin

func _on_area_2d_area_entered(area: Area2D) -> void:
	# GameManager.gain_coins(1)
	queue_free()
