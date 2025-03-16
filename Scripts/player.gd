extends CharacterBody2D

@export var move_speed : float = 50.0
@export var gravity : float = 100.0
@export var jump_velocity : float = 60.0
@export var tile_map : TileMapLayer

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

func _process(delta):
	if Input.is_action_pressed("left_mouse_click"):
		var pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(pos)
		var tile_data = tile_map.get_cell_tile_data(tile_pos)
		tile_map.set_cell(tile_pos, -1)
		print("I am colliding! at position: ", pos)

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
