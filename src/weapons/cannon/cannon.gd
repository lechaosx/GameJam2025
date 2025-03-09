extends Node2D

@onready var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

var velocity: Vector2
var previous_position: Vector2

@export var ball_speed = 40000
@export var default_cannon_cooldown_time : float = 2

var can_fire: bool = true

var level = 0

func _ready() -> void:
	previous_position = global_position
	$Timer.wait_time = default_cannon_cooldown_time

func level_up():
	if level >= 5:
		return

	level += 1
	
	$Timer.wait_time = default_cannon_cooldown_time - (default_cannon_cooldown_time / 6) * level
	
func fire():
	if not can_fire:
		return
		
	can_fire = false
		
	var instance = cannon_ball.instantiate()
	instance.position = global_position + global_transform.x * $Sprite2D.texture.get_width()
	instance.scale = Vector2(0.5, 0.5)
	instance.add_collision_exception_with(get_parent())
	instance.apply_force(ball_speed * global_transform.x + velocity)
	get_tree().get_root().add_child(instance)

	if $Timer.is_stopped():
		$Timer.start()
			
func _physics_process(delta: float) -> void:
	velocity = (global_position - previous_position) / delta
	previous_position = global_position

func _on_timer_timeout() -> void:
	can_fire = true
