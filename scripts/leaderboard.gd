extends Control
@onready var supabase_request: HTTPRequest = get_node("../../SupabaseRequest")
@onready var leaderboard_button: TextureButton = get_node("../LeaderboardButton")
@onready var close_button: Button = $Panel/CloseHitBox
@onready var close_animation: AnimatedSprite2D = $Panel/CloseButton
@onready var username_input: LineEdit = $Panel/UsernameInput
@onready var score_label: Label = $Panel/Score
@onready var submit_button: Button = $Panel/SubmitButton
@onready var leaderboard_list: VBoxContainer = $Panel/LeaderboardList
const USERNAME_PATH := "user://leaderboard_username.txt"
const SUPABASE_URL := "https://ggnhpzpydkndnhqgnymw.supabase.co"
const SUPABASE_KEY := "sb_publishable_vxSJcH5i0wadZLuGf2PNEQ_--yXPhEl"
var current_request := ""
func _ready():
	visible = false
	supabase_request.request_completed.connect(_on_leaderboard_request_completed)
	leaderboard_button.pressed.connect(_on_leaderboard_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	submit_button.pressed.connect(_on_submit_pressed)
	close_animation.play("default")
	load_username()
func _on_leaderboard_button_pressed():
	visible = true
	score_label.text = "Your Crumbs: " + str(GameManager.crumbs)
	load_username()
	fetch_leaderboard()
func _on_close_button_pressed():
	visible = false
func load_username():
	if not FileAccess.file_exists(USERNAME_PATH):
		print("No Saved username yet.")
		return
	var file := FileAccess.open(USERNAME_PATH, FileAccess.READ)
	if file:
		var saved_username := file.get_as_text().strip_edges()
		username_input.text = saved_username
		print("Loaded Username: ", saved_username)
func _on_submit_pressed():
	var username := username_input.text.strip_edges()
	if username.length() < 2:
		username_input.text = ""
		username_input.placeholder_text = "Too Short :<"
		return
	if username.length() > 16:
		username = username.substr(0, 16)
		username_input.text = username
	var username_regex := RegEx.new()
	username_regex.compile("^[A-Za-z0-9 _-]+$")
	if not username_regex.search(username):
		username_input.text = ""
		username_input.placeholder_text = "Weird username ;-;"
		return
	var file := FileAccess.open(USERNAME_PATH, FileAccess.WRITE)
	if file:
		file.store_string(username)
	print("Username Saved: ", username)
	print("Score Submitted: ", GameManager.crumbs)
	submit_score()
func fetch_leaderboard():
	current_request = "fetch"
	var url := SUPABASE_URL + "/rest/v1/leaderboard?select=username,crumbs&order=crumbs.desc&limit=10"
	var headers := [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY
	]
	var error := supabase_request.request(url, headers, HTTPClient.METHOD_GET)
	if error != OK:
		print("Leaderboard request failed to start: ", error)
		return
	print("Fetching leaderboard...")
func _on_leaderboard_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Leaderboard network error: ", result)
		return
	if response_code < 200 or response_code >= 300:
		print("Supabase error: ", response_code)
		print(body.get_string_from_utf8())
		return
	if current_request == "submit":
		print("Score submitted successfully.")
		fetch_leaderboard()
		return
	if current_request == "fetch":
		var data = JSON.parse_string(body.get_string_from_utf8())
		print("LEADERBOARD:")
		print(data)
		display_leaderboard(data)
func submit_score():
	current_request = "submit"
	var username := username_input.text.strip_edges()
	var crumbs := GameManager.crumbs
	var url := SUPABASE_URL + "/rest/v1/leaderboard?on_conflict=username"
	var headers := [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY,
		"Content-Type: application/json",
		"Prefer: resolution=merge-duplicates"
	]
	var data := {
		"username": username,
		"crumbs": crumbs
	}
	var json_body := JSON.stringify(data)
	var error := supabase_request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json_body
	)
	if error != OK:
		print("Failed to submit score: ", error)
		return
	print("Submitting score: ", username, " ", crumbs)
func display_leaderboard(data):
	for child in leaderboard_list.get_children():
		child.queue_free()
	if data == null or data.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No worthy players yet :<"
		leaderboard_list.add_child(empty_label)
		return
	var rank := 1
	for entry in data:
		var row := Label.new()
		var username := str(entry.get("username", "Unknown"))
		var crumbs := int(entry.get("crumbs", 0))
		row.text = str(rank) + ". " + username + "    " + str(crumbs) + " crumbs"
		leaderboard_list.add_child(row)
		rank += 1
