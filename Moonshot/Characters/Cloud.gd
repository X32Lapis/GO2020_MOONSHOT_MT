extends StaticBody2D


export var direction = 1
export var speed = 10
var current_speed = speed
export var is_grumpy = false
export var aggression_multiplier = 1

var state = NORMAL
var aggression_level = 0
var is_angry = false
var is_shockwave_range = false
var is_able_shockwave = true

onready var parent_node = get_parent()

enum {
		NORMAL,
		GRUMPY,
		STORM
		}

const AGGRESSION_RATE = 5
const AGGRESSION_MAX = 95


func _ready():
	$GrumpyZone/CollisionShape2D.disabled = !is_grumpy

func _physics_process(delta):
	$AggressionLevel.text = String(stepify(aggression_level,1))
	if direction == 1:
		parent_node.global_position.x += current_speed * delta
	else:
		parent_node.global_position.x -= current_speed * delta

	$Extra.text = "Angry: " + String(is_angry) + " Shckwve RNG: " + String(is_shockwave_range)


	match state:
		NORMAL:
			normal_state(delta)
		
		GRUMPY:
			grumpy_state(delta)
		
		STORM:
			storm_state()


func normal_state(delta):
	$StateLabel.text = "Normal"
	
	current_speed = move_toward(current_speed,speed,0.5)
	
	if is_angry and is_shockwave_range:
		current_speed = move_toward(current_speed,0,0.5)
		intial_shockwave()
		
	if aggression_level > 0:
		aggression_level -= ((AGGRESSION_RATE * 0.5) * aggression_multiplier) * delta
	if aggression_level < 30:
		is_angry = false


func grumpy_state(delta):
	$StateLabel.text = "Grumpy"
		
	if is_angry and is_shockwave_range:
		current_speed = move_toward(current_speed,0,0.5)
		intial_shockwave()
		
	if aggression_level < AGGRESSION_MAX:
		aggression_level += (AGGRESSION_RATE * aggression_multiplier) * delta
	if aggression_level >= AGGRESSION_MAX:
		state = STORM
		is_angry = true


func storm_state():
	$StateLabel.text = "Storm"
	if is_angry and is_shockwave_range:
		current_speed = move_toward(current_speed,0,0.5)
		intial_shockwave()


func _on_GrumpyZone_body_entered(_body):
	state = GRUMPY


func _on_GrumpyZone_body_exited(_body):
	state = NORMAL


func _on_ShockwaveRange_body_entered(_body):
	is_shockwave_range = true


func _on_ShockwaveRange_body_exited(_body):
	is_shockwave_range = false


func intial_shockwave():
	$StateLabel.text = "Shockwave Attack"
	if is_able_shockwave:
		$AnimationPlayer.play("shockwave_anim")
		shockwave_attack()


func shockwave_attack():
	$StateLabel.text = "Cooldown"
	$Timer.start(5)
	is_able_shockwave = false


func _on_Timer_timeout():
	is_able_shockwave = true


func _on_ShockwaveArea_body_entered(body):
	body.shockwave_hurt($ShockwaveArea/CollisionShape2D2.global_position)

