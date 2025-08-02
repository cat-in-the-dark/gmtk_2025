extends CharacterBody2D
class_name Player

const SPEED = 96.0
const JUMP_VELOCITY = -300.0
const CIRCLE_LEN = PI * 16

var started = false

@onready var sprite = $Sprite2D

func _physics_process(delta):
	if not started:
		if Input.is_action_just_pressed("ui_accept"):
			started = true
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	var direction = 1 # always moving

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animate sprite
	if velocity.x > 0.01 or velocity.x < -0.01:
		sprite.rotate(-1 * velocity.x / 16.0)

	move_and_slide()


func collect_note():
	print("Collect note")

func _on_damage_hit_area_body_entered(body):
	# Collide with spike
	print(body)
