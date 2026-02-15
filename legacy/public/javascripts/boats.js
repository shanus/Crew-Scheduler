function updateBoatIcon(obj, id) {
	var elem = null;
	try {
		elem = document.getElementById(id);
		elem.innerHTML = '<img src="/images/'+ (obj.value).replace( /[\+]/, "%2b") +'_48.gif" alt="'+ obj.value +'" />';
	} catch (e) {}
}
