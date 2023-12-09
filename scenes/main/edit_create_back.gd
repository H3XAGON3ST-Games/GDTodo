extends Panel

signal saving_data_todo(node)

enum EditMode {
	NotVisible, 
	Edit,
	Create
}

onready var name_mode = $EditCreateMode/NameMode
onready var time_text = $EditCreateMode/TimeText
onready var text_edit = $EditCreateMode/TextEdit

var date_for_item setget set_date_for_item

var object_edit: ToDoItem


func set_date_for_item(value):
	date_for_item = value
	
	if value == null:
		time_text.text = "Enter date"
		return
	
	time_text.text = "%s.%s.%s" % [value.day(), value.month(), value.year()]


func set_edit_mode(value: int):
	match value:
		EditMode.NotVisible:
			visible = false
		EditMode.Edit:
			visible = true
			name_mode.text = "Edit ToDo"
			read_data_from_todo()
		EditMode.Create:
			visible = true
			name_mode.text = "Create new ToDo"
			read_data_from_todo()


func read_data_from_todo():
	if object_edit == null:
		return
	
	text_edit.text = object_edit.todo_item_resource.info_about_todo
	
	
	if object_edit.todo_item_resource.info_about_time.size() == 3:
		date_for_item = Date.new()
		date_for_item.set_day(object_edit.todo_item_resource.info_about_time[0])
		date_for_item.set_month(object_edit.todo_item_resource.info_about_time[1])
		date_for_item.set_year(object_edit.todo_item_resource.info_about_time[2])
		self.date_for_item = date_for_item
	else:
		set_date_for_item(null)
	


func _on_CalendarButton_date_selected(date: Date):
	self.date_for_item = date


func _on_ExitFromCalendar_pressed():
	$EditCreateMode/CalendarButton.pressed = false


func _on_save_pressed():
	object_edit.todo_item_resource.info_about_todo = text_edit.text
	
	if date_for_item != null:
		print(object_edit.todo_item_resource.info_about_time)
		if object_edit.todo_item_resource.info_about_time.size() == 3:
			object_edit.todo_item_resource.info_about_time[0] = date_for_item.day()
			object_edit.todo_item_resource.info_about_time[1] = date_for_item.month()
			object_edit.todo_item_resource.info_about_time[2] = date_for_item.year()
		elif object_edit.todo_item_resource.info_about_time.size() == 0:
			object_edit.todo_item_resource.info_about_time.append(date_for_item.day())
			object_edit.todo_item_resource.info_about_time.append(date_for_item.month())
			object_edit.todo_item_resource.info_about_time.append(date_for_item.year())
		print(object_edit.todo_item_resource.info_about_time)
	
	object_edit.update_resource_data()
	
	set_edit_mode(EditMode.NotVisible)
	
	emit_signal("saving_data_todo", object_edit)


func _on_Delete_pressed():
	object_edit.delete_item()
	set_edit_mode(EditMode.NotVisible)
