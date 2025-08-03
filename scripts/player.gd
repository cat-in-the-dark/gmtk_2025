extends CharacterBody2D
class_name Player

const SPEED = 72.0
const JUMP_VELOCITY = -300.0
const CIRCLE_LEN = PI * 16

var started = false
var was_on_floor = false

@onready var sprite = $Sprite2D
@onready var bgm_player = get_node("/root/game_scene/BgmPlayer") as BgmPlayer

func _physics_process(delta):
	if not started:
		if Input.is_action_just_pressed("ui_accept"):
			started = true
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		bgm_player.jump()
	if Input.is_action_just_released("player_jump") and velocity.y < 0:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	var direction = 1 # always moving

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	var on_floor = is_on_floor()
	if (!was_on_floor and on_floor):
		bgm_player.fall()
	was_on_floor = on_floor

	# Animate sprite
	var vx = get_position_delta().x
	sprite.rotate(vx / 16.0)


func collect_note():
	print("Collect note")

func disable_player():
	Globals.n_restarts += 1
	$AnimationPlayer.play("damaged")
	bgm_player.hit()
	$DamageHitArea/CollisionShape2D.set_deferred('disabled', true)
	$CollisionShape2D.set_deferred('disabled', true)
	started = false
	
func restore_player():
	$AnimationPlayer.stop()
	$DamageHitArea/CollisionShape2D.set_deferred('disabled', false)
	$CollisionShape2D.set_deferred('disabled', false)
	velocity.x = 0
	velocity.y = 0
	started = true
	

func _on_damage_hit_area_body_entered(body: Node2D):
	# Collide with spike
	var room = body.get_parent()
	if room is Room:
		disable_player()
		var tween = get_tree().create_tween()
		tween.tween_property(self, 'global_position', room.player_spawn_point.global_position, 0.5)
		tween.tween_callback(restore_player)
	else:
		print("WTF!!!")
