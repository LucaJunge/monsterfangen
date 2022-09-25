extends Resource

class_name ItemResource

export var name : String
export(String, MULTILINE) var description : String
export var max_stack_size : int = 99

# Examples
enum ItemType { GENERIC, CONSUMABLE, QUEST, EQUIPMENT }
export(ItemType) var type
export var texture : Texture
