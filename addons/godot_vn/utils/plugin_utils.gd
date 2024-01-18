class_name PluginUtils

static func gen_uinque_hexideci():
	var datetime_str = Time.get_datetime_string_from_system()
	var regex = RegEx.new()
	regex.compile("(\\d+)")
	var deci_str = ""
	for result in regex.search_all(datetime_str):
		deci_str += result.get_string()
	return "%x" % int(deci_str + str(Time.get_ticks_msec() % 999))
	

