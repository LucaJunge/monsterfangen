class_name MonsterData
extends Resource

export var unique_id := ""

export var display_name := ""
export var nickname := ""
export var description := ""
export var icon: Texture
export (MonsterType.Type) var primary_type := MonsterType.Type.NORMAL
export (MonsterType.Type) var secondary_type := MonsterType.Type.NONE

# base values
export var base_attack := 1
export var base_health := 1
export var base_defense := 1
export var base_tempo := 1
export var base_xp := 1

# current values
var xp := 1
var attack := 1
var health := 1
var defense := 1
var tempo := 1
var level := 1

var current_health := 1
