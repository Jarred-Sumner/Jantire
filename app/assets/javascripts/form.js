$(document).ready(function()
{
  $("input:submit").button();
  $("#submit").button();
  $(".commit").children("input").button();
  $("#assignment_due").datepicker();
  if (location.pathname == "/users/sign_up")
	{
	  $("#lacking_humility").hide();
	}
});
