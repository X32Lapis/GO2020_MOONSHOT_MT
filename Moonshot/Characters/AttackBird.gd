extends KinematicBody2D

var velocity = Vector2()
var state = NORMAL
var direction = 1
export var speed = 3000
export var disable_detection = false
export var color = Color(1,1,1)
export var daze_length = 1
export var knockback_strength = 1000

enum {
		NORMAL,
		SEEKING
}


func _ready():
	$SeekRange/CollisionShape2D.disabled = disable_detection
	set_modulate(color)


func _physics_process(_delta):
	match state:
		NORMAL:
			normal_state()
		SEEKING:
			seeking_state()
			

func normal_state():
	if $AnimatedSprite.rotation_degrees < 90 && $AnimatedSprite.rotation_degrees > -90 || $AnimatedSprite.rotation_degrees > -90 && $AnimatedSprite.rotation_degrees < 90:
		$AnimatedSprite.flip_v = false
	elif $AnimatedSprite.rotation_degrees > 90 || $AnimatedSprite.rotation_degrees < -90:
		$AnimatedSprite.flip_v = true


	if velocity.x > -250 && velocity.x < 250 && velocity.y < 250 && velocity.y > -250:
		$AnimatedSprite.set_animation("idle")
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.set_rotation_degrees(0)


	else:
		$AnimatedSprite.set_animation("attack")
	velocity.x = lerp(velocity.x,0,0.02)
	velocity.y = lerp(velocity.y,0,0.02)
	
	
	velocity = move_and_slide(velocity,Vector2.UP)


func seeking_state():
	pass


func attack(player_position):
	velocity = (global_position - player_position).normalized() * -speed


func _on_HurtBox_body_entered(body):
	if body.state == 0:
		body.hurt(get_parent().global_position,daze_length,knockback_strength)
		velocity = Vector2.ZERO


func _on_SeekRange_body_entered(body):
	attack(body.global_position)
	$AnimatedSprite.look_at(body.global_position)


func _on_TopDetection_body_entered(body):
	body.bounce()
	queue_free()
