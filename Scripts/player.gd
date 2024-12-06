extends CharacterBody2D
class_name Player
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


func _ready():
	GameManager.player = self

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	if Input.is_action_just_pressed("ui_right"):
		sprite.scale.x = abs(sprite.scale.x)
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		animation.play("IDLE")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation()
	move_and_slide()

	if position.y >= 600:
		die()

func update_animation():
	if velocity.x != 0:
		animation.play("RUN")
	else:
		animation.play("IDLE")
	
	if velocity.y < 0:
		animation.play("JUMP")
	if velocity.y > 0:
		animation.play("FALL")

func die():
	GameManager.respawn_player()
