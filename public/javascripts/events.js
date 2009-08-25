function OneMore(val) {
	var int = parseFloat(val);
	int++;
	if (int > 23) {
		return "23";
	} else if (int < 10) {
		return "0" + int;
	}
	return int;
}
function UpdateEndTime(elem, val) {
	Form.Element.setValue('event_end_time_4i', OneMore(val));
	return true;
}
function SetStartEndDates(elem, val) {
	var end = elem.id.substring(elem.id.length-2);
	Form.Element.setValue('event_start_time_' + end, val);
	Form.Element.setValue('event_end_time_' + end, val);
	return true;
}