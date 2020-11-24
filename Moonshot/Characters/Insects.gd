extends KinematicBody2D


var velocity = Vector2()
var state = IDLE
onready var player = get_parent().get_parent().get_node("LittleGirl")
var speed = 0

enum {IDLE,SEEKING,DRAINING}

const MAX_SPEED = 400
const DRAIN_FUEL = 20


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
	if speed < MAX_SPEED:
		speed = move_toward(speed,MAX_SPEED,1.2)
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
