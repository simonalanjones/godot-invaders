# scene_switcher.gd
extends Node

# Private variable
var _params = null

# Call this instead to be able to provide arguments to the next scene
func change_scene(next_scene, params=null):
	call_deferred("_deferred_change_scene",next_scene,params)
	
func _deferred_change_scene(next_scene,params):
	_params = params
	if get_tree().change_scene(next_scene)!= OK:
		print('failed to open scene ' + str(next_scene))

# In the newly opened scene, you can get the parameters by name
func get_param(name):
    if _params != null and _params.has(name):
        return _params[name]
    return null