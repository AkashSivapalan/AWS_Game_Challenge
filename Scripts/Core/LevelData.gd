extends Node

var level_dic = {
	"Level1": {
		"unlocked": true,
		"score": 0,
		"max_score": 0,
		"coins": 0,
		"max_coins": 0,
		"damage_taken": 0,
		"unlocks": "Level2",
		"beaten": false
	},
		"Level2": {
		"unlocked": false,
		"score": 0,
		"max_score": 0,
		"coins": 0,
		"max_coins": 0,
		"damage_taken": 0,
		"unlocks": "Level3",
		"beaten": false
	},
		"Level3": {
		"unlocked": false,
		"score": 0,
		"max_score": 0,
		"coins": 0,
		"max_coins": 0,
		"damage_taken": 0,
		"unlocks": "Level1",
		"beaten": false
	}
}
func unlock_level(level_name: String) -> void:
	if level_name in level_dic:
		level_dic[level_name]["unlocked"] = true

func mark_level_beaten(level_name: String) -> void:
	if level_name in level_dic:
		level_dic[level_name]["beaten"] = true
