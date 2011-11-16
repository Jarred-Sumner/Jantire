$("#index").ready ->
	$(".course").click ->
		window.location.pathname = $(this).attr("href")
	$(".student").click ->
		window.location.pathname = $(this).attr("href") unless $(this).hasClass("no_hover")
