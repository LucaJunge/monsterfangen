extends Node

export (Array, Resource) var sound_files

func _ready() -> void:
	pass
	
func play(stream: AudioStream, volume_db: float = 0.0) -> void:
	var audio_stream_player: Node = AudioStreamPlayer.new()
	
	audio_stream_player.bus = "Master"
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()
	
	# destroy (queue free) the stream player if the song has finished playing
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	self.add_child(audio_stream_player)

