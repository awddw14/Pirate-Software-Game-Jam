extends Node


func reset():
	hit = false
	missed = false
	block_the_door = false
	temp_change = ""
	gun_parts_missing = []
	gun_parts_collected = []
	monster_select = ""
	current_sense = ""


var hit: bool = false
var missed: bool = false
var block_the_door: bool = false

var env_temp: int
var temp_change: String = ""

var gun_parts_missing: Array = []
var gun_parts_collected: Array = []

var monster_select: String

var current_sense: String = ""
