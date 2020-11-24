extends KinematicBody2D

var velocity = Vector2()
var state = NORMAL
export var speed = 100
export var direction = 1

enum {
		NORMAL,
		SEEKING
}


func _physics_process(_delta):
	match state:
		NORMAL:
			normal_state()
		SEEKING:
			seeking_state()


func normal_state():
	if direction == 1:
		velocity.x = speed
	else:
		velocity.x = -speed
	
	velocity = move_and_slide(velocity,Vector2.UP)


func seeking_state():
	pass


func _on_HurtBox_body_entered(body):
	body.hurt(get_parent().global_position)
