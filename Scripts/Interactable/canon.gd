extends StaticBody2D


var canon_ball = load("res://Scenes/Interactable/canonball.tscn")
# var debris = load("res://Scenes/Interactable/canon_debris.tscn")

@export var shooting : bool
var firerate = 2
var destroyed = false

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $Firepoint

var max_health = 3
var health

func _ready():
	health = max_health
	shooting = true
	shoot()


func shoot():
	while shooting:
		$AnimationPlayer.play("Fire")
		await  get_tree().create_timer(firerate).timeout
		

func fire():
	var spawned_ball = canon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)

func take_damage(damage_amount):
	health -= damage_amount

	animation_player.play("Hit")

	if health <= 0:
		# $Area2D/CollisionShape2D.disabled = true
		die()

func die():
	destroyed = true
	shooting = false
	$AnimationPlayer.play("crumble")
	$Area2D/CollisionShape2D.disabled = true
	# var spawned_debris = debris.instantiate()
	# spawned_debris.global_position = position
	# spawned_debris.scale.x = scale.x
	# spawned_debris.get_child(1).play("crumble")
	# print("canon died at position:", position)
	# print("canon died at position:", spawned_debris.global_position)
	#queue_free()
	#get_tree().get_root().get_child(1).add_child(spawned_debris)
	# print("2nd canon died at position:", position)
	# print("2nd canon died at position:", spawned_debris.global_position)
