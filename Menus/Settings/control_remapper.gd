class_name ControlRemapper
extends HBoxContainer

signal control_remapping(control_remapper: ControlRemapper)

@export var control_name: String = "Control Name"
@export var action_name: String = "Action Name"
@export var input_event_key: InputEventKey = InputEventKey.new()

@onready var control_label: Label = $ControlLabel
@onready var control_remap_button: Button = $ControlRemapButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(!action_name.is_empty(), "Control remapper does not have an action assigned.")
	assert(Settings.control_mappings.has(action_name), "Control action does not match a defined control mapping.")
	set_process_unhandled_key_input(false)
	control_label.text = control_name
	input_event_key.keycode = OS.find_keycode_from_string(Settings.control_mappings[action_name])
	set_action_event()


func _on_control_remap_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		control_remap_button.text = "PRESS ANY KEY..."
		set_process_unhandled_key_input(toggled_on)
		for control_remapper in get_tree().get_nodes_in_group("Control Remappers"):
			control_remapper = control_remapper as ControlRemapper
			if control_remapper.action_name != self.action_name:
				control_remapper.control_remap_button.toggle_mode = false
				control_remapper.control_remap_button.disabled = true
				control_remapper.set_process_unhandled_key_input(false)
	else:
		for control_remapper in get_tree().get_nodes_in_group("Control Remappers"):
			control_remapper = control_remapper as ControlRemapper
			if control_remapper.action_name != self.action_name:
				control_remapper.control_remap_button.toggle_mode = true
				control_remapper.control_remap_button.disabled = false
				control_remapper.set_process_unhandled_key_input(false)
		set_action_event()


func _unhandled_key_input(event: InputEvent) -> void:
	control_remap_button.button_pressed = false
	set_process_unhandled_key_input(false)
	if event.is_action_pressed("player_cancel"):
		return
	input_event_key = event
	set_action_event()


func set_action_event() -> void:
	if !InputMap.has_action(action_name):
		return
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input_event_key)
	if action_name == "player_next_colour":
		var mouse_button = InputEventMouseButton.new()
		mouse_button.button_index = MOUSE_BUTTON_WHEEL_DOWN
		InputMap.action_add_event(action_name, mouse_button)
	if action_name == "player_previous_colour":
		var mouse_button = InputEventMouseButton.new()
		mouse_button.button_index = MOUSE_BUTTON_WHEEL_UP
		InputMap.action_add_event(action_name, mouse_button)
	Settings.control_mappings[action_name] = OS.get_keycode_string(input_event_key.keycode)

	control_remap_button.text = Settings.control_mappings[action_name]
