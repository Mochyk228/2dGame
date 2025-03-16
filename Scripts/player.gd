extends CharacterBody2D

@export var move_speed : float = 50.0
@export var gravity : float = 100.0
@export var jump_velocity : float = 60.0

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

func _process(delta):
	if ray_cast.is_colliding():
		ray_cast.get_collider().queue_free()
		print("I am colliding!")

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
			sprite.flip_h = false
		else:
			sprite.flip_h = true
