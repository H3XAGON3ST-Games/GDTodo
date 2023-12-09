extends Control

var todo_item_paths: ToDoItemPath
var todo_item_resources: Dictionary

onready var todo_container = $PanelBack/ScrollContainer/ToDoContainer

onready var edit_create_back = $EditCreateBack

onready var search_line = $PanelBack/SearchLine

func _ready():
	edit_create_back.connect("saving_data_todo", self, "saving_data_todo")
	var checking_file = File.new()
	if checking_file.file_exists("user://items_paths.tres"):
		todo_item_paths = ResourceLoader.load("user://items_paths.tres")
	else:
		var new_resource = ToDoItemPath.new()
		ResourceSaver.save("user://items_paths.tres", new_resource)
		todo_item_paths = new_resource
	create_todo_item()


func init_item_signal(item_todo: ToDoItem):
	item_todo.connect("update_data_button_pressed", self, "update_data_button_pressed")
	item_todo.connect("delete_item", self, "queue_free_todo_item")


func save_todo_item_path():
	ResourceSaver.save("user://items_paths.tres", todo_item_paths)

func saving_data_todo(item_todo: ToDoItem):
	ResourceSaver.save(todo_item_resources[item_todo.todo_item_resource], item_todo.todo_item_resource)

func create_todo_item():
	for item in todo_item_paths.paths_todo_resource:
		var item_todo: ToDoItem = load("res://scenes/item_todo/item_todo.tscn").instance()
		
		init_item_signal(item_todo)
		
		var loaded_item: ToDoItemResource = load(item)
		
		todo_item_resources[loaded_item] = item
		
		item_todo.todo_item_resource = loaded_item
		todo_container.add_child(item_todo)


func _on_searchline_text_changed(new_text: String):
	print(new_text)
	if new_text.length() == 0:
		update_todo_item()

func _on_SearchButton_pressed():
	update_todo_item()

var todo_nodes
func update_todo_item():
	todo_nodes = todo_container.get_children()
	
	if search_line.text.length() == 0:
		for item in todo_nodes:
			item.visible = true
		return 
	
	for item in todo_nodes:
		item.visible = false
		var text_todo: String = item.todo_item_resource.info_about_todo 
		
		if text_todo.findn(search_line.text) != -1:
			item.visible = true


func add_todo_item(todo_item_name: String) -> ToDoItem:
	var new_resource: ToDoItemResource = ToDoItemResource.new()
	
	var additional_number = 1
	var checking_file = File.new()
	
	while checking_file.file_exists("user://" + todo_item_name + str(additional_number) + ".tres"):
		additional_number += 1
	
	var item_res_path: String = "user://" + todo_item_name + str(additional_number) + ".tres"
	
	ResourceSaver.save(item_res_path, new_resource)
	todo_item_resources[new_resource] = item_res_path
	
	todo_item_paths.paths_todo_resource.append(item_res_path)
	save_todo_item_path()
	
	var item_todo: ToDoItem = load("res://scenes/item_todo/item_todo.tscn").instance()
	
	item_todo.name = todo_item_name + str(additional_number)
	
	init_item_signal(item_todo)
	
	item_todo.todo_item_resource = new_resource
	todo_container.add_child(item_todo)
	return item_todo


func queue_free_todo_item(item_todo: ToDoItem):
	var path = todo_item_resources[item_todo.todo_item_resource]
	todo_item_resources.erase(item_todo.todo_item_resource)
	
	todo_item_paths.paths_todo_resource.erase(path)
	save_todo_item_path()
	
	var dir = Directory.new()
	dir.remove(path)
	
	item_todo.queue_free()


func update_data_button_pressed(item_todo: ToDoItem):
	edit_create_back.object_edit = item_todo
	edit_create_back.set_edit_mode(edit_create_back.EditMode.Edit)


func _on_exit_pressed():
	edit_create_back.set_edit_mode(edit_create_back.EditMode.NotVisible)


func _on_add_new_todo_pressed():
	var item_todo = add_todo_item(generate_unique_abbreviation(6))
	edit_create_back.object_edit = item_todo
	edit_create_back.set_edit_mode(edit_create_back.EditMode.Create)


var ascii = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
func generate_unique_abbreviation(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii[randi() % ascii.length()]
	return result









