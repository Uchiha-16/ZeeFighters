#The Dimensions for the CollisionShape2D is 30 x 20.6
extends Area2D

@export var ledge_Side = "Left" # (String,"Left", "Right")
@onready var label = $"Label"
@onready var collision = $"CollisionShape2D"
var is_grabbed = false


func _on_Ledge_L_body_exited(body):
	is_grabbed = false

func _ready():
	if ledge_Side == "Left":
		label.text = "Ledge_L"
	else:
		label.text = "Ledge_R"
