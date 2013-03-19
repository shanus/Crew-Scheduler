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
	$('.make-toggle span.labelLeft, .make-toggle span.labelRight').bind("click", function() {
      $(this).siblings('label').trigger('mousedown').trigger('mouseup').trigger('click');
  });
	$('.colorpicker').colorpicker();
});