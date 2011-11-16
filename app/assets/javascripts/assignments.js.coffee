$("#turn_in").ready ->
  $("#file").mouseenter ->
    $("#turn_in_box").css "border", "2px solid #D9D9D9"
    $("#turn_in_box").css "background", "#D9D9D9"
    $("#turn_in_box").css "color", "#393939"
    $("#turn_in_box").css "cursor", "pointer"
    $("#turn_in_box").css "box-shadow" ,"0px 0px 0px transparent"
  $("#file").mouseleave ->
    $("#turn_in_box").css "border", "2px solid #D9D9D9"
    $("#turn_in_box").css "background", "#393939"
    $("#turn_in_box").css "color", "#D9D9D9"
    $("#turn_in_box").css "cursor", "default"
  $("#file").bind 'dragover', (evt) -> 
    evt.stopPropagation()
    evt.preventDefault()
  $("#file").bind 'drop', ->
    $("#drag").css "display", "none"
    $("#turn_in_assignment").text "Turning In Assignment..."
    document.getElementById("submit").click()
  $("#file").bind 'change', ->
    $("#drag").css "display", "none"
    $("#turn_in_assignment").text "Turning In Assignment..."
    document.getElementById("submit").click()
$("#assignments").ready ->
  $(".assignment").click ->
    window.location.pathname = $(this).attr("href")
