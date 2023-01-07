extends Panel

onready var license_container = $ScrollContainer/MarginContainer/LicenseList/MarginContainer/LicenseContainer
onready var license_template = preload("res://scenes/LicenseContainer/LicenseContainer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var licenses = load_licenses()
	
	for license in licenses:
		var current_license = license_template.instance()
		
		var project_name = current_license.get_node("LicenseName")
		var project_description = current_license.get_node("LicenseDescription")
		var project_link = current_license.get_node("LinkButton")
		
		project_name.set_text(license["name"])
		project_description.set_text(license["description"])
		project_link.url = license["url"]
		
		license_container.add_child(current_license)
	
func load_licenses():
	var license_files := []
	var license_folder := "res://resources/licenses"
	
	var directory := Directory.new()
	var can_continue := directory.open(license_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [license_folder])
		return license_files
		
	# warning-ignore:return_value_discarded
	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			license_files.append(license_folder.plus_file(file_name))
		file_name = directory.get_next()
	
	var license_resources := []
	for path in license_files:
		license_resources.append(load(path))
		
	return license_resources

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
	SceneTransition.change_overlay(self, "fade")
