class_name CalendarButtons

const buttons_count = 42
var calendar = load("res://addons/calendar_button/class/calendar.gd").new()
var buttons_container : GridContainer

const cur_date := preload("res://global/themes/cur_date.tres")

func _init(var calendar_script, var buttons_container : GridContainer):
	self.buttons_container = buttons_container
	setup_button_signals(calendar_script)

func setup_button_signals(var calendar_script):
	for i in range(buttons_count):
		var btn_node = buttons_container.get_node("btn_" + str(i))
		btn_node.connect("pressed", calendar_script, "day_selected", [btn_node])

func update_calendar_buttons(var selected_date : Date):
	_clear_calendar_buttons()
	
	var days_in_month : int = calendar.get_days_in_month(selected_date.month, selected_date.year)
	var start_day_of_week : int = calendar.get_weekday(1, selected_date.month, selected_date.year)
	for i in range(days_in_month):
		var btn_node : Button = buttons_container.get_node("btn_" + str(i + start_day_of_week))
		btn_node.text = str(i + 1)
		
		btn_node.disabled = false
		btn_node.modulate = Color(1, 1, 1)
		
		if(i + 1 == calendar.day()) && (selected_date.year == calendar.year()) && (selected_date.month == calendar.month() ):
			btn_node.add_stylebox_override("normal", cur_date)
		else:
			btn_node.modulate = Color(1, 1, 1)

func _clear_calendar_buttons():
	for i in range(buttons_count):
		var btn_node : Button = buttons_container.get_node("btn_" + str(i))
		btn_node.set_text("")
		btn_node.disabled = true
		btn_node.modulate = Color(1, 1, 1, 0.243137)
		btn_node.set_flat(false)
