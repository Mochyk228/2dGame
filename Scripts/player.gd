extends CharacterBody2D

@export var move_speed : float = 50.0
@export var gravity : float = 100.0
@export var jump_velocity : float = 60.0
@export var tile_map : TileMapLayer
var mouse_pos : Vector2
var tile_pos
var old_tile_pos
var is_the_same_place : bool
var is_once : bool

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer_animation: AnimatedSprite2D = $TimerAnimation
@onready var timer: Timer = $Timer

func _process(delta):
	if Input.is_action_pressed("left_mouse_click"):
		is_the_same_place = true
		mouse_pos = get_global_mouse_position()
		timer_animation.visible = true
		timer_animation.play("default")
		timer_animation.global_position = mouse_pos + Vector2(3,3)
		tile_pos = tile_map.local_to_map(mouse_pos)
		if tile_pos != old_tile_pos:
			old_tile_pos = tile_pos
			is_the_same_place = false 
		
		if is_the_same_place and not is_once:
			timer.start()
			is_once = true
	else:
		timer_animation.stop()
		timer_animation.visible = false
		timer.stop()
		is_once = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_velocity
	
	var input = Input.get_axis("left", "right")
	velocity.x = input * move_speed
	
	move_and_slide()
	
	if velocity.length() > 0.0:
		if velocity.x > 0:
			ray_cast.target_position.x = 10.0
			sprite.flip_h = false
		else:
			ray_cast.target_position.x = -10.0
			sprite.flip_h = true


func _on_timer_timeout() -> void:
	tile_map.set_cell(tile_pos, -1)
