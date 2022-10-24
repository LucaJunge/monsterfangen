class_name License
extends Resource

export var name: String = ""
export var author: String = ""
export (String, MULTILINE) var description = ""
export (String, 'Textures', 'Sound Effects', "Music", "Fonts", "Software") var type
export (String, "The Unlicense", "CC0", "CC BY 3.0", "GPL-3.0", "MIT", "Open Font") var license = ""
export var url : String = ""
