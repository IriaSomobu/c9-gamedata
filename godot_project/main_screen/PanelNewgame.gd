extends GridContainer

onready var core = get_node("/root/Root").core;

var subtitle_custom = "Allows you to fully customize points pool, scenario, and character's profession, stats, traits, skills and other parameters."
var subtitle_preset = "Select from one of previously created character templates."
var subtitle_random = "Creates random character, but lets you preview the generated character and the scenario and change character and/or scenario if needed."
var subtitle_playnow = "Puts you right in the game, randomly choosing scenario and character's traits, profession, skills and other parameters."

func _ready():
	$Cursom.title = core.tr("Custom Character");
	$Cursom.subtitle = "[color=yellow]"+core.tr(subtitle_custom)+"[/color]";
	
	$Preset.title = core.tr("Preset Character");
	$Preset.subtitle = "[color=yellow]"+core.tr(subtitle_preset)+"[/color]";
	
	$Random.title = core.tr("Random Character");
	$Random.subtitle = "[color=yellow]"+core.tr(subtitle_random)+"[/color]";
	
	$Playnow.title = core.tr("Play Now!");
	$Playnow.subtitle = "[color=yellow]"+core.tr(subtitle_playnow)+"[/color]";


func _on_btn_press(mode):
	get_node("/root/Root").goto_newchar(mode);
