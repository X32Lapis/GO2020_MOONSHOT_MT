extends KinematicBody2D


var velocity = Vector2()
var state = IDLE
onready var player = get_parent().get_parent().get_parent().get_node("LittleGirl")
var speed = 0
export var max_speed = 200
export var color = Color(1,1,1)

enum {	IDLE,
		SEEKING,
		DRAINING
		}

const DRAIN_FUEL = 25

func _ready():
	set_modulate(color)

func _physics_process(_delta):
	match state:
		IDLE:
			idle_state()
		
		SEEKING:
			seeking_state()
		
		DRAINING:
			draining_state()


func idle_state():
	velocity.x = move_toward(velocity.x,0,1)
	velocity.y = move_toward(velocity.y,0,1)
	speed = move_toward(speed,0,1)
	velocity = move_and_slide(velocity)


func seeking_state():
	if speed < max_speed:
		speed = move_toward(speed,max_speed,1.2)
	var distance = Vector2(player.global_position - global_position)
	velocity = move_and_slide(speed * distance.normalized())


func draining_state():
	seeking_state()
	if player.fuel > 0:
		player.fuel -= DRAIN_FUEL


func _on_SeekProxy_body_entered(_body):
	state = SEEKING


func _on_SeekProxy_body_exited(_body):
	state = IDLE


func _on_HurtProx_body_entered(_body):
	state = DRAINING


func _on_HurtProx_body_exited(_body):
	state = SEEKING


func _on_EatenRadius_body_entered(body):
		queue_free()
