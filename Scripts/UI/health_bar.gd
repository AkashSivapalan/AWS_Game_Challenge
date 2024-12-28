extends Control

@onready var fill_max = $ColorRect.size.x
var fill_amount: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_healthbar(health, max_health):
	fill_amount = (float(health) / max_health)
	$ColorRect.size.x = fill_amount
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
