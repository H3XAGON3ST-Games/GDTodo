class_name Date

var day : int
var month : int
var year : int

func _init(day : int = OS.get_datetime()["day"], 
		month : int = OS.get_datetime()["month"], 
		year : int = OS.get_datetime()["year"]):
	self.day = day
	self.month = month
	self.year = year

func date(date_format = "DD-MM-YY") -> String:
	if("DD".is_subsequence_of(date_format)):
		date_format = date_format.replace("DD", str(day).pad_zeros(2))
	if("MM".is_subsequence_of(date_format)):
		date_format = date_format.replace("MM", str(month).pad_zeros(2))
	if("YYYY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YYYY", str(year))
	elif("YY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YY", str(year).substr(2,3))
	return date_format

func change_to_prev_month():
	var selected_month = month
	selected_month -= 1
	if(selected_month < 1):
		month = 12
		year = year - 1
	else:
		month = selected_month

func change_to_next_month():
	var selected_month = month
	selected_month += 1
	if(selected_month > 12):
		month = 1
		year = year + 1
	else:
		month = selected_month

func change_to_prev_year():
	year = year - 1

func change_to_next_year():
	year = year + 1
