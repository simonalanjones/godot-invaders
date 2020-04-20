extends Node2D

var hi_score = 0
var score = 0
var extra_life = false
var demo_mode = false

signal extra_life
signal score_updated(score)

onready var hi_score_value = $"Scores/Hi_score_value"
onready var score_value = $"Scores/Score_value"

func _ready():
	demo_mode = Scene_switcher.get_param("demo_mode")
	hi_score = load_hi_score()
	var hi_score_text = "%05d" %hi_score
	hi_score_value.text = str(hi_score_text)
	
func get_score():
	return score
	
func pulse_score():
	var count = 0
	while count < 25:
		score_value.visible = !score_value.visible
		yield(get_tree().create_timer(.1),"timeout")
		count+=1
	score_value.visible = true
	
func add_score(score_add):
	if demo_mode == false:
		score += score_add
		if score >= 1500 and extra_life == false:
			extra_life = true
			emit_signal('extra_life')
		update_score()

func update_score():
	var score_text = "%05d" %score
	score_value.text = str(score_text)
	emit_signal('score_updated', score)
	
func reset_score():
	score = 0
	update_score()

func final_score():
	if score > hi_score:
		hi_score = score
		var hi_score_text = "%05d" %hi_score
		hi_score_value.text = str(hi_score_text)
		save_hi_score(score)

func save_hi_score(score):
	var data = {
		hi_score = score
	}
	var file = File.new()
	if file.open("user://saved_game.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	file.store_line(to_json(data))
	file.close()
	
func load_hi_score():
	var file = File.new()
	if not file.file_exists("user://saved_game.sav"):
		print("No file saved!")
		return
	# Open existing file
	if file.open("user://saved_game.sav", File.READ) != 0:
		print("Error opening file")
		return

	# Get the data
	var data = parse_json(file.get_line())
	hi_score = data.hi_score
	return hi_score