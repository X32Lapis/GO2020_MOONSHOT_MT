extends Node2D

func _ready():
	$CanvasLayer/AnimationPlayer.play("Fade_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Title_scene.tscn")
