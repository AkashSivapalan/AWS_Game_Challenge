extends CharacterBody2D
class_name Player

@onready var player
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var attack_area = $AttackArea

@export var SPEED = 300.0
var facing_right = true
@export var JUMP_VELOCITY = -400.0
@export var attacking: bool = false

var max_health = 3
var health = 0
var can_take_damage = true
@export var hit = false

func _ready():
	health = max_health
	GameManager.player = self
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	if Input.is_action_just_pressed("attack") and not hit and not attacking:
		attack()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		facing_right = false
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x)
		facing_right = true
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not attacking and not hit:
		update_animation()
	
	move_and_slide()

	if position.y >= 1000:
		die()

func attack():
	if attacking or hit:
		return
	attacking = true
	animation.play("ATTACK")
	
	var overlapping_objects = $RightAttackArea.get_overlapping_areas()
	if !facing_right:
		overlapping_objects = $LeftAttackArea.get_overlapping_areas()
	for area in overlapping_objects:
		var parent = area.get_parent()
		if parent.is_in_group("Enemies"):
			parent.take_damage(1)
		else:
			parent.queue_free()

func take_damage(damage_amount: int):
	if can_take_damage:
		iframes()
		hit = true
		attacking = false
		animation.play("HIT")
		
		health -= damage_amount
		update_health()
		if health <= 0:
			die()

func update_health():
	get_node("HealthBar").update_healthbar(health, max_health)

func _on_animation_finished(animation_name: String):
	if animation_name == "ATTACK":
		attacking = false
	elif animation_name == "HIT":
		hit = false

func update_animation():
	if velocity.x != 0:
		animation.play("RUN")
	else:
		animation.play("IDLE")
	if velocity.y > 0:
		animation.play("FALL")
	elif velocity.y < 0:
		animation.play("JUMP")
		

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	GameManager.respawn_player()
	velocity = Vector2.ZERO