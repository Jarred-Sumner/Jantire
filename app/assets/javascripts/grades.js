$("#grades").ready(function()
{
  $("#egp").click(function()
  {
    window.open("/assignments/" + location.pathname.split("/")[2] + " /egp");  
  });
  $(".grade").click(function()
  {
    clickDiv(this);
  });
  $(".user").click(function()
  {
    clickDiv(this);
  });
  $(".assignment").click(function()
  {
    clickDiv(this);
  });
  function clickDiv(div)
  {
    window.location.pathname = $(div).attr("href");
  }
});

