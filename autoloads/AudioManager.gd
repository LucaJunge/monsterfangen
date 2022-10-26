extends Node

var click_sound = preload("res://assets/sounds/click.wav")

export (Array, Resource) var sound_files

var current_music: AudioStreamPlayer
#onready var click_sound = load("res://assets/sounds/click.wav")
#onready var direct_player = AudioStreamPlayer.new()

func _ready() -> void:
	#direct_player.stream = click_sound
	#direct_player.bus = "Master"
	#direct_player.volume_db = -10.0
	#self.add_child(direct_player)
	pass
	
func play(stream: AudioStream, volume_db: float = 0.0) -> AudioStreamPlayer:
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_stream_player.bus = "Master"
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()
	
	# destroy (queue free) the stream player if the song has finished playing
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	self.add_child(audio_stream_player)
	return audio_stream_player

func play_click() -> void:
	play(click_sound)

func play_loop(stream: AudioStream, volume_db: float = 0.0) -> AudioStreamPlayer:
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	current_music = audio_stream_player
	audio_stream_player.bus = "Master"
	audio_stream_player.stream = stream
	audio_stream_player.stream.loop = true
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()
	
	# do not destroy (queue free) the stream player if the song has finished playing
	# do not destroy it when it should loop? how?
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	self.add_child(audio_stream_player)
	return audio_stream_player

func stop() -> void:
	if current_music:
		current_music.stop()
	
func fade_out(stream: AudioStreamPlayer, duration: float = 2.0) -> void:
	var fade_tween := Tween.new()
	self.add_child(fade_tween)
	fade_tween.interpolate_property(stream, "volume_db", stream.volume_db, -100.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	fade_tween.connect("tween_completed", self, "destroy_fade", [stream, fade_tween])
	fade_tween.start()
	
func fade_in(_stream: AudioStreamPlayer, _duration: float = 2.0) -> void:
	pass

func destroy_fade(_object, _key, stream_player: AudioStreamPlayer, fade_tween: Tween) -> void:
	#print_debug("destroy stream")
	stream_player.queue_free()
	self.remove_child(fade_tween)
