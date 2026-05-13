extends Control
const GAME_SCENE := "res://scenes/global/tutorial/tutorial.tscn"

@onready var play_button: Button = $CenterContainer/PlayButton
@onready var settings_button: Button = $CenterContainer/SettingsButton
@onready var credits_button: Button = $CenterContainer/CreditsButton
@onready var quit_button: Button = $CenterContainer/QuitButton
@onready var settings_panel: PanelContainer = $SettingsPanel
@onready var master_slider: HSlider = $SettingsPanel/SettingsVbox/MasterVolumeSlider
@onready var close_settings_button: Button = $SettingsPanel/SettingsVbox/CloseSettingsButton
@onready var credits_panel: PanelContainer = $CreditsPanel
@onready var close_credits_button: Button = $CreditsPanel/CreditsVbox/CloseCreditsButton

func _ready():
	# Connect main menu buttons
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	close_settings_button.pressed.connect(_close_settings)
	close_credits_button.pressed.connect(_close_credits)
	
	#Connects volume slider and looks at the saved settings
	master_slider.value_changed.connect(_on_volume_changed)
	master_slider.value = _load_volume("master_volume",1.0)
	_apply_volume("Master", master_slider.value)
	
	#Hides the settings and credits at the start
	settings_panel.hide()
	credits_panel.hide()
	
func _on_play_pressed():
	#Loads the game when press play button
	get_tree().change_scene_to_file(GAME_SCENE)
	
func _on_settings_pressed():
	#Shows settings
	settings_panel.show()
	credits_panel.hide()
	
func _on_credits_pressed():
	#Shows credits
	settings_panel.hide()
	credits_panel.show()

func _on_quit_pressed():
	#Quit the application
	get_tree().quit()
	
func _close_credits():
	credits_panel.hide()
	
func _close_settings():
	settings_panel.hide()
	
func _on_volume_changed(value: float):
	# Called whenever the master volume slider value changes
	_apply_volume("Master", value)
	_save_volume("master_volume", value)
	
func _apply_volume(bus_name: String, linear_value: float):
	# For the future if we want to add more audios
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))

func _save_volume(key: String, value:float):
	var config := ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("audio", key, value)
	config.save("user://settings.cfg")
	
func _load_volume(key:String, default_value: float):
	var config := ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return default_value
	return config.get_value("audio", key, default_value)
