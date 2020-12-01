extends KinematicBody2D


var velocity = Vector2()
var fuel = 0
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
const FUEL_MAX = 10000
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


# Jet Pack Regen #####################################################

	if fuel < FUEL_MAX && $RayCast2D.is_colliding():
		fuel += FUEL_DRAIN * 2


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

## Debug
#	velocity.x = stepify(velocity.x,1)
#	velocity.y = stepify(velocity.y,1)


# Enemy Interaction ###########################################
func bounce():
#	if STATES.NORMAL:
	velocity.y = -BOUNCE


	# Damage ##################################################
func hurt(origin,daze,power):

	if velocity.x > origin.x:
		velocity = (self.global_position - origin).normalized() * -power
	else:
		velocity = (self.global_position - origin).normalized() * power

		set_dazed(daze)
		state = STATES.DAZED


func fall_damage():
	velocity.y = -BOUNCE * 0.6
	set_dazed(stun_length)
	state = STATES.DAZED


# Movement ####################################################
func move_state(_delta):
# Turn off visibility for star daze
	$StarDaze.set_visible(false)
	
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

	
# Left and Right movement
	if Input.is_action_pressed("moveLeft"):
		velocity.x = -SPEED
		if is_on_floor():
			$AnimatedSprite.set_animation("run")
			$AnimatedSprite.set_flip_h(true)
		elif velocity.y < 10:
			$AnimatedSprite.set_animation("fly")
			$AnimatedSprite.set_flip_h(true)
		elif velocity.y > 10 && !$RayCast2D.is_colliding():
			$AnimatedSprite.set_animation("fall")
	elif Input.is_action_pressed("moveRight"):
		velocity.x = SPEED
		if is_on_floor():
			$AnimatedSprite.set_animation("run")
			$AnimatedSprite.set_flip_h(false)
		elif velocity.y < 10:
			$AnimatedSprite.set_animation("fly")
			$AnimatedSprite.set_flip_h(false)
		elif velocity.y > 10 && !$RayCast2D.is_colliding():
			$AnimatedSprite.set_animation("fall")
	else:
		velocity.x = lerp(velocity.x,0,0.3)
		if is_on_floor():
			$AnimatedSprite.set_animation("idle")
		elif velocity.y > 20 && !$RayCast2D.is_colliding():
			$AnimatedSprite.set_animation("fall")
		elif velocity.y < -20:
			$AnimatedSprite.set_animation("fly")


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
	$AnimatedSprite.set_animation("daze")
	if velocity.x > 10:
		$AnimatedSprite.set_flip_h(false)
	elif velocity.x < -10:
		$AnimatedSprite.set_flip_h(true)
	
	$StarDaze.set_visible(true)
	if is_on_floor():
		velocity.x = lerp(velocity.x,0,0.3)
	else:
		velocity.x = lerp(velocity.x,0,0.01)
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_Timer_timeout():
	state = STATES.NORMAL


func lose_state():
	get_tree().change_scene("res://Scenes/Level1.tscn")
