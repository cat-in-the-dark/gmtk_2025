extends CharacterBody2D
class_name Player

const ACCEL = 180
const MAX_SPEED_X = 180
const MAX_SPEED_FALL = 380
const GRAVITY = 700
const JUMP_GRAVITY = 500
const JUMP_FORCE = 250

var started = false
var now = 0
var on_floor_timestamp = 0
var jump_pressed_timestamp = 0

@onready var sprite = $Sprite2D

func _physics_process(delta):
	now += delta
	if not started:
		if Input.is_action_just_pressed("ui_accept"):
			started = true
		return

	var y_input = 0
	if Input.is_action_just_pressed("player_jump"):
		jump_pressed_timestamp = now
	if now - jump_pressed_timestamp < 0.15:
		y_input = -1
	if Input.is_action_just_released("player_jump"):
		y_input = 1
		jump_pressed_timestamp = 0

	velocity.x += ACCEL * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED_X, MAX_SPEED_X)

	var was_on_floor = is_on_floor()

	if (velocity.y < 0):
		velocity.y += JUMP_GRAVITY * delta
	else:
		velocity.y += GRAVITY * delta
	if velocity.y > MAX_SPEED_FALL:
		velocity.y = MAX_SPEED_FALL
	if (is_on_floor() or now - on_floor_timestamp < 0.15) and velocity.y > 0:
		if y_input < 0:
			on_floor_timestamp = 0
			# $SFX/RandomJump.play()
			velocity.y = -JUMP_FORCE
	else:
		# animation.play("jump_up")
		if y_input > 0 and velocity.y < 0:
			velocity.y = 0

	if abs(velocity.x) < 3:
		velocity.x = 0

	move_and_slide()

	if !was_on_floor and is_on_floor():
		# $SFX/RandomFallOnGround.play()
		pass

	if is_on_floor():
		on_floor_timestamp = now
		if abs(velocity.y) < 5:
			velocity.y = 0
		if velocity.x != 0:
			pass
			#if !$SFX/RandomStep.playing:
			#	$SFX/RandomStep.play()
#
	## Animate sprite
	var vx = get_position_delta().x
	#if vx > 1 or vx < -1:
	sprite.rotate(vx / 16)
#
	#move_and_slide()


func collect_note():
	print("Collect note")

func _on_damage_hit_area_body_entered(body):
	# Collide with spike
	print(body)
