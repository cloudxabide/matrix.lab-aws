function crtSearchFunction() {
	var input, filter, table, tr, td, i;
	input = document.getElementById("crtSearchInput");
	filter = input.value.toUpperCase();
	table = document.getElementById("crtTable");
	tr = table.getElementsByTagName("tr");
	th = table.getElementsByTagName("th");
	// Loop through all table rows, and hide those who don't match the search query
	for (i = 1; i < tr.length; i++) {
		tr[i].style.display = "none";
		for (var j = 0; j < th.length; j++) {
			td = tr[i].getElementsByTagName("td")[j];
			if (td) {
				if (td.innerHTML.toUpperCase().indexOf(filter.toUpperCase()) > -1) {
					tr[i].style.display = "";
					break;
				}
			}
		}
	}
}