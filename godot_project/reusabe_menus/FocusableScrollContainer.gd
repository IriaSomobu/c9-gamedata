class_name FocusableScrollContainer
extends ScrollContainer


func make_scrollable(child):
	child.connect("focus_entered", self, "_on_focus_change")


func _on_focus_change():
	var focused = get_focus_owner()
	var focus_offset = focused.rect_position.y
	var focus_offset_bottom = focus_offset + focused.get_size().y;
	
	var scrolled_top = get_v_scroll()
	var scrolled_bottom = scrolled_top + get_size().y - focused.get_size().y
	
	if focus_offset < scrolled_top:
		set_v_scroll(focus_offset)
	
	if focus_offset_bottom >= scrolled_bottom:
		var t = focus_offset_bottom - scrolled_bottom;
		set_v_scroll(get_v_scroll() + t)
