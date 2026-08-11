extends Control
@onready var supabase_request: HTTPRequest = get_node("../../SupabaseRequest")
@onready var leaderboard_button: TextureButton = get_node("../LeaderboardButton")
@onready var close_button: Button = $Panel/CloseHitBox
@onready var close_animation: AnimatedSprite2D = $Panel/CloseButton
@onready var username_input: LineEdit = $Panel/UsernameInput
@onready var score_label: Label = $Panel/Score
@onready var submit_button: Button = $Panel/SubmitButton
@onready var leaderboard_list: VBoxContainer = $Panel/LeaderboardList
@onready var chat_request: HTTPRequest = get_node("../../ChatRequest")
@onready var message_input: LineEdit = $Panel/MessageInput
@onready var send_button: Button = $Panel/SendButton
@onready var messages: VBoxContainer = $Panel/ChatList/Messages
const CHAT_REFRESH_TIME := 1.0
const DEFAULT_MESSAGE_PLACEHOLDER := "Type ur message :]"
var chat_refresh_timer := 0.0
var chat_request_type := ""
var chat_request_busy := false
var should_scroll_to_bottom := false
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
	chat_request.request_completed.connect(_on_chat_request_completed)
	send_button.pressed.connect(_on_chat_send_pressed)
	fetch_chat()
func _process(delta):
	if not visible:
		return
	chat_refresh_timer += delta
	if chat_refresh_timer >= CHAT_REFRESH_TIME:
		chat_refresh_timer = 0.0
		fetch_chat()
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
func _on_chat_send_pressed():
	var message := message_input.text.strip_edges()
	if message.is_empty():
		return
	if message.length() > 100:
		message_input.text = ""
		message_input.placeholder_text = "Message too long :<"
		return
	var username := username_input.text.strip_edges()
	if username.is_empty():
		message_input.placeholder_text = "Set a username pls :3"
		return
	message_input.placeholder_text = DEFAULT_MESSAGE_PLACEHOLDER
	should_scroll_to_bottom = true
	send_chat_message(username, message)
func fetch_chat():
	if chat_request_busy:
		return
	chat_request_busy = true
	chat_request_type = "fetch"
	var url := SUPABASE_URL + "/rest/v1/chat_messages?select=username,message,created_at&order=created_at.asc&limit=50"
	var headers := [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY
	]
	var error := chat_request.request(
		url,
		headers,
		HTTPClient.METHOD_GET
	)
	if error != OK:
		chat_request_busy = false
		print("Failed to fetch chat: ", error)
func send_chat_message(username: String, message: String):
	if chat_request_busy:
		return
	chat_request_busy = true
	chat_request_type = "send"
	var url := SUPABASE_URL + "/rest/v1/chat_messages"
	var headers := [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]
	var data := {
		"username": username,
		"message": message
	}
	var json_body := JSON.stringify(data)
	var error := chat_request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		json_body
	)
	if error != OK:
		chat_request_busy = false
		print("Failed to send chat message: ", error)
		return
	message_input.text = ""
func _on_chat_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
):
	chat_request_busy = false
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Chat network error: ", result)
		return
	if response_code < 200 or response_code >= 300:
		print("Chat Supabase error: ", response_code)
		print(body.get_string_from_utf8())
		return
	if chat_request_type == "fetch":
		var data = JSON.parse_string(
			body.get_string_from_utf8()
		)
		if data == null:
			return
		display_chat(data)
	elif chat_request_type == "send":
		fetch_chat()
func display_chat(data):
	for child in messages.get_children():
		child.queue_free()
	for entry in data:
		var username := str(entry.get("username", "Unknown"))
		var message := str(entry.get("message", ""))
		var row := RichTextLabel.new()
		row.bbcode_enabled = true
		row.fit_content = true
		row.scroll_active = false
		row.custom_minimum_size.y = 24
		row.text = "[color=#63e05b]" + username + ":[/color] " + message
		messages.add_child(row)
	await get_tree().process_frame
	if should_scroll_to_bottom:
		var scroll_container := $Panel/ChatList
		scroll_container.scroll_vertical = (
			scroll_container.get_v_scroll_bar().max_value
		)
		should_scroll_to_bottom = false
