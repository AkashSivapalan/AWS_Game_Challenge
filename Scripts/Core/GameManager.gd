extends Node


var current_checkpoint: Checkpoint
var coins: int

var player: Player


func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_coins(coins_gained):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
