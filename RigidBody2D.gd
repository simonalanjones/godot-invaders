extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var thrust = Vector2(0, 250)
var torque = 20000

func _integrate_forces(state):
    if Input.is_action_pressed("ui_up"):
        print('up')
        applied_force = thrust.rotated(rotation)
    else:
        applied_force = Vector2()
    var rotation_dir = 0
    if Input.is_action_pressed("ui_right"):
        print('right')
        rotation_dir += 1
    if Input.is_action_pressed("ui_left"):
        print('left')
        rotation_dir -= 1
    applied_torque = rotation_dir * torque
