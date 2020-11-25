extends KinematicBody2D

var velocity = Vector2()
var state = NORMAL
var direction = 1
export var speed = 2500

enum {
		NORMAL,
		SEEKING
}

const DAZE_LENGTH = 1
const KNOCKBACK_STRENGTH = 1000


func _physics_process(_delta):
	match state:
		NORMAL:
			normal_state()
		SEEKING:
			seeking_state()


func normal_state():
	velocity.x = lerp(velocity.x,0,0.05)
	velocity.y = lerp(velocity.y,0,0.05)
	
	velocity = move_and_slide(velocity,Vector2.UP)


func seeking_state():
	pass


func attack(player_position):
	velocity = (global_position - player_position).normalized() * -speed


func _on_HurtBox_body_entered(body):
	if body.state == 0:
		body.hurt(get_parent().global_position,DAZE_LENGTH,KNOCKBACK_STRENGTH)
		velocity = Vector2.ZERO


func _on_SeekRange_body_entered(body):
	attack(body.global_position)


func _on_TopDetection_body_entered(body):
	body.bounce()
	queue_free()
