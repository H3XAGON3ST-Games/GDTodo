extends Panel
class_name ToDoItem

signal update_data_button_pressed(node)
signal delete_item(node)
signal complete_item(node)

var todo_item_resource: ToDoItemResource

onready var complete_to_do = $CompleteToDo

onready var info_about_to_do = $PressItemButton/InfoAboutToDo
onready var info_about_time = $PressItemButton/InfoAboutTime


func _ready():
	update_resource_data()

func update_resource_data():
	complete_to_do.pressed = todo_item_resource.complete_todo
	info_about_to_do.text = todo_item_resource.info_about_todo
	
	if todo_item_resource.info_about_time.size() == 3:
		var value = todo_item_resource.info_about_time
		info_about_time.text = "To %s.%s.%s" % [value[0], value[1], value[2]]
		
		var current_date = Time.get_date_dict_from_system()
		
		print(current_date)
		if current_date["year"] > value[2]:
			info_about_time.modulate = Color(0.9375, 0.45625, 0.45625)
		elif current_date["year"] < value[2]:
			info_about_time.modulate = Color(0.629199, 0.9375, 0.45625)
		else:
			if current_date["month"] > value[1]:
				info_about_time.modulate = Color(0.9375, 0.45625, 0.45625)
			elif current_date["month"] < value[1]:
				info_about_time.modulate = Color(0.629199, 0.9375, 0.45625)
			else:
				if current_date["day"] > value[0]:
					info_about_time.modulate = Color(0.9375, 0.45625, 0.45625)
				elif current_date["day"] <= value[0]:
					info_about_time.modulate = Color(0.629199, 0.9375, 0.45625)
		
	else:
		info_about_time.text = "Without date"
		info_about_time.modulate = Color(1, 1, 1, 0.486275)


func _on_PressItemButton_pressed():
	emit_signal("update_data_button_pressed", self)


func delete_item():
	emit_signal("delete_item", self)


func _on_complete_todo_toggled(button_pressed):
	if button_pressed:
		$Done.visible = true
		self.modulate = Color(1, 1, 1, 0.576471)
	else:
		$Done.visible = false
		self.modulate = Color(1, 1, 1)
	
	todo_item_resource.complete_todo = button_pressed
	
	emit_signal("complete_item", self)
