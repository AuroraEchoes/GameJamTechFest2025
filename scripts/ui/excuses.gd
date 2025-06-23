extends RichTextLabel

var excuses: Array[String] = [
	"That wasn’t your fault! Who designed this mountain anyway?",
	"That wasn’t your fault! That tree jumped into your way at the last minute.",
	"That wasn’t your fault! Your computer just lagged.",
	"That wasn’t your fault! I blame whatever idiot developer designed this garbage game.",
	"That wasn’t your fault! You clearly should have survived that obstacle… the game’s gotta be bugged.",
	"That wasn’t your fault! Your cat must’ve been playing that round."
]

func _ready() -> void:
	text = excuses[randi_range(0, len(excuses) - 1)]
	visible_ratio = 0
	get_tree().create_tween().tween_property(self, "visible_ratio", 1.0, 2.5)
