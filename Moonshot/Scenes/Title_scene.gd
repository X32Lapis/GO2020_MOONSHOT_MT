extends CanvasLayer


func _on_Button_pressed():
	$AnimationPlayer.play("Fade_Out")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Level1.tscn")
