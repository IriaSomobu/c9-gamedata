tool extends Button

export var title = "" setget t_set
export var subtitle = "" setget s_set

func t_set(newval):
	title = newval
	$Label.text = title

func s_set(newval):
	subtitle = newval
	$RichTextLabel.bbcode_text = subtitle
