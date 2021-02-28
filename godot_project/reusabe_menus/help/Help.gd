extends Panel

onready var core = get_node("/root/Root").core;

var help_array = [];

func _ready():
	get_node("/root/Root").connect("settings_changed", self, "reload_data");
	reload_data()


func reload_data():
	help_array = core.get_help_data();
	
	for item in help_array:
		$OptionButton.add_item(item["name"])
	
	$OptionButton.selected = 0;
	$OptionButton.select(0);
	_on_OptionButton_item_selected(0);


func _on_OptionButton_item_selected(id):
	$RichTextLabel.bbcode_text = help_array[id]["content"]
	pass
