extends KinematicBody2D


var velocity = Vector2()
var health = 3
var fuel = 0
var cans = 3
var state = STATES.NORMAL
var stun_length
var too_high = false
var collide_object

enum STATES{
		NORMAL,
		DAZED,
		ATTACK
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

# Debug
	velocity.x = stepify(velocity.x,1)
	velocity.y = stepify(velocity.y,1)


func recharge_fuel():
	if cans > 0 and is_on_floor() and fuel != FUEL_MAX:
		fuel = FUEL_MAX
		cans -= 1


# Enemy Interaction ###########################################
func bounce():
	velocity.y = -BOUNCE

	# Damage ##################################################

func sideHurt(var enemy_position_x):
	stun_length = 0.5
	if enemy_position_x > position.x:
		velocity.x = -BOUNCE * 2
	else:
		velocity.x = BOUNCE * 2
	Input.action_release("moveLeft")
	Input.action_release("moveRight")
	set_dazed(stun_length)
	state = STATES.DAZED


func downHurt():
	velocity.y = BOUNCE * 0.5
	Input.action_release("moveUp")
	set_dazed(stun_length)
	state = STATES.DAZED


func fall_damage():
	velocity.y = -BOUNCE * 0.6


# Movement ####################################################
func move_state(delta):
# Check for fall damage
	if velocity.y >= GRAVITY_MAX:
		too_high = true


	if too_high and is_on_floor():
		stun_length = 3
		fall_damage()
		set_dazed(stun_length)
		state = STATES.DAZED
		too_high = false


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


func dazed_state(delta):
	$AnimationPlayer.play("Dazed_Anim")
	velocity.x = lerp(velocity.x,0,0.3)
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_Timer_timeout():
	state = STATES.NORMAL

