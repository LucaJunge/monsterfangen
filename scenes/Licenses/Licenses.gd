extends Panel

onready var license_container = $ScrollContainer/MarginContainer/LicenseList/MarginContainer/VBoxContainer
onready var license_template = preload("res://scenes/LicenseContainer/LicenseContainer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	list_licenses()

func list_licenses():
	var license_file = File.new()
	
	if license_file.open("res://assets/licenses.json", File.READ) != OK:
		return
	
	var license_text = license_file.get_as_text()
	license_file.close()
	
	var parsed_licenses = JSON.parse(license_text)
	if parsed_licenses.error != OK:
		return
	
	var data = parsed_licenses.result
	
	for project in data:
		var current_license = license_template.instance()
		
		var projectname_label = current_license.get_node("LicenseName")
		var projectname_desc = current_license.get_node("LicenseDescription")
		var link_button = current_license.get_node("LinkButton")
		
		projectname_label.set_text(project["projectName"])
		projectname_desc.set_text(project["projectDescription"])
		link_button.url = project["url"]
		
		license_container.add_child(current_license)
	license_container.update()


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")
