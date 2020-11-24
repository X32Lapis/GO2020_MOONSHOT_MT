extends KinematicBody2D


var velocity = Vector2()
var health = 5
var fuel = 0
var cans = 3
var state = STATES.NORMAL
var stun_length = 1
var too_high = false
var collide_object
var collide_with_platform = false

enum STATES{
		NORMAL,
		DAZED,
		ATTACK,
		Lose
		}

const JETPACK_POWER = -400
const FUEL_MAX = 5000
const FUEL_DRAIN = 10
const GRAVITY = 3000
const GRAVITY_MAX = 2000
const SPEED = 500
const BOUNCE = 1200
const ATTACK_SPEED = 0.5

func _ready():
	fuel = FUEL_MAX


func _physics_process(delta):
# Gravity #########################################################
	if velocity.y < GRAVITY_MAX and !is_on_floor():
		velocity.y += GRAVITY * delta


# State Machine #####################################################
	match state:
		STATES.NORMAL:
			move_state(delta)
		
		STATES.DAZED:
			dazed_state(delta)
		
		STATES.ATTACK:
			attack_state(delta)
		
		STATES.Lose:
			lose_state()

# Debug
	velocity.x = stepify(velocity.x,1)
	velocity.y = stepify(velocity.y,1)


func recharge_fuel():
	if cans > 0 and is_on_floor() and fuel != FUEL_MAX:
		fuel = FUEL_MAX
		cans -= 1


# Enemy Interaction ###########################################
func bounce():
	if STATES.NORMAL:
		velocity.y = -BOUNCE

	# Damage ##################################################
func hurt(origin):
	health = health - 1
	if health <= 0:
		state = STATES.Lose
	else:
		velocity = (self.global_position - origin).normalized() * -300
		set_dazed(stun_length)
		state = STATES.DAZED


func fall_damage():
	health = health - 1
	if health <= 0:
		state = STATES.Lose
	else:
		velocity.y = -BOUNCE * 0.6
		set_dazed(stun_length)
		state = STATES.DAZED


func shockwave_hurt(origin):
	health = health - 1
	if health <= 0:
		state = STATES.Lose
	else:
		velocity = (self.global_position - origin).normalized() * 3000
		set_dazed(5)
		state = STATES.DAZED


# Movement ####################################################
func move_state(_delta):
# Check for fall damage
	if velocity.y >= GRAVITY_MAX:
		too_high = true
	else:
		too_high = false


	if too_high and $RayCast2D.is_colliding():
		stun_length = 3
		fall_damage()


# Use Jet Pack
	if Input.is_action_pressed("moveUp") and fuel > 0:
		velocity.y = JETPACK_POWER
		fuel -= FUEL_DRAIN
		
# Re-charge Jet Pack
	if Input.is_action_just_pressed("recharge_fuel"):
		recharge_fuel()
	
# Left and Right movement
	if Input.is_action_pressed("moveLeft"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("moveRight"):
		velocity.x = SPEED
	else:
		velocity.x = lerp(velocity.x,0,0.3)

	if Input.is_action_just_pressed("attack") and $Timer.is_stopped():
		$Timer.start(ATTACK_SPEED)
		state = STATES.ATTACK

	velocity = move_and_slide(velocity,Vector2.UP)


# Character Interaction #######################################
func attack_state(delta):
	move_state(delta)
	$AnimationPlayer.play("Attack_Anim")


func attack_animation_finished():
	state = STATES.NORMAL


func set_dazed(set_length):
	$Timer.start(set_length)


func dazed_state(_delta):
	$AnimationPlayer.play("Dazed_Anim")
	if is_on_floor():
		velocity.x = lerp(velocity.x,0,0.3)
	else:
		velocity.x = lerp(velocity.x,0,0.01)
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_Timer_timeout():
	state = STATES.NORMAL


func lose_state():
	get_tree().change_scene("res://Scenes/Level1.tscn")
