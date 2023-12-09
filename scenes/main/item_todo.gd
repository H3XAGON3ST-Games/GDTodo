extends Panel


var todo_item_resource: ToDoItemResourse

onready var complete_to_do = $CompleteToDo

onready var info_about_to_do = $PressItemButton/InfoAboutToDo
onready var info_about_time = $PressItemButton/InfoAboutTime


# Called when the node enters the scene tree for the first time.
func _ready():
	todo_item_resource = load("res://test_resource.tres")
	
	init_resource()

func init_resource():
	todo_item_resource
