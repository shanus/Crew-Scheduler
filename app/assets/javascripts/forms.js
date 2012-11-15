$(document).ready(function() {
	$('.make-toggle label.checkbox').toggleButtons({
	    style: {
	        // Accepted values ["primary", "danger", "info", "success", "warning"] or nothing
	        enabled: "success"
	    },
			label: {
			    enabled: "YES",
			    disabled: "NO"
			  }
	});
	$('.colorpicker').colorpicker();
});