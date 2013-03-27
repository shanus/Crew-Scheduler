function helpContent() {
	var helpContent = "This page does not have any help content available.";
	var helpElem = $('#current_help');
	if ((helpElem != null) && (helpElem.html().trim() != '')) {
		helpContent = helpElem.html();
	}
	
	return helpContent;
}

$(document).ready(function() {
	$('#help-link').popover({ placement : 'bottom',
														trigger : 'manual',
														content : helpContent()
													});
});