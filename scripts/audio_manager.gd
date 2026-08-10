extends Node
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE := 12
var audio_enabled := true
var sounds := {
	"fall": preload("res://assets/Audio/fall.ogg"),
	"land": preload("res://assets/Audio/land.ogg"),
	"scuttle": preload("res://assets/Audio/scuttle.ogg"),
	"spawn_evolve": preload("res://assets/Audio/spawn evolve.ogg"),
	"splat": preload("res://assets/Audio/splat.ogg"),
	"chomp": preload("res://assets/Audio/chomp.ogg"),
	"poke": preload("res://assets/Audio/poke.ogg")
}
var music := preload("res://assets/Audio/idk_music.ogg")
func _ready():
	music.loop = true
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = music
	music_player.volume_db = 0.0
	music_player.play()
	for i in SFX_POOL_SIZE:
		var player = AudioStreamPlayer.new()
		player.volume_db = -3.0
		add_child(player)
		sfx_players.append(player)
func play_sfx(sound_name: String):
	if not sounds.has(sound_name):
		push_warning("Unknown sound: " + sound_name)
		return
	for player in sfx_players:
		if not player.playing:
			player.stream = sounds[sound_name]
			if sound_name == "poke":
				player.pitch_scale = randf_range(0.92, 1.08)
			else:
				player.pitch_scale = 1.0
			player.play()
			return
	push_warning("All SFX players are currently busy")
func toggle_audio():
	audio_enabled = !audio_enabled
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus == -1:
		push_error("Master audio bug not found.")
		return
	AudioServer.set_bus_mute(master_bus, not audio_enabled)
	print("Audio Toggle: ", audio_enabled)
