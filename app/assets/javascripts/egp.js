$("#egp").ready(function()
{
  setDefaults();
  $(window).hashchange(function()
  {
    setActiveGrade(location.hash);
  });
  $(".grade").click(function()
  {
    location.hash = "#" + $(this).attr("id");
  });
  $("#next").click(function()
  {
    location.hash = downGradeDOM();
  });
  $("#previous").click(function()
  {
    location.hash = upGradeDOM();
  });
  $(document).keyup(function(e)
  {
    var up = "38";
    var down = "40";
    if (e.keyCode == up)
    {
      //Go up one grade
      location.hash = upGradeDOM();
    }
    else if (e.keyCode == down)    
    {
      //Go down one grade
      location.hash = downGradeDOM();
    }
  });
  $(document).keydown(function(evt)
  {
    evt = evt || window.event;
    var keyCode = evt.keyCode;
    if (keyCode >= 37 && keyCode <= 40) 
    {
        return false;
    }
  });
  
  function setActiveGrade(dom_id)
  {
    $(".active").addClass('graded');
    $(".active").removeClass('active');
    $(dom_id).addClass('active');
  }
  function getActiveGrade()
  {
    return "#" + getActiveGradeIndex();
  }
  function getActiveGradeIndex()
  {
    return parseInt($(".active").attr("id"));
  }
  function downGrade()
  {
    //Goes down a grade unless it's at the bottom, if it's at the bottom then it brings the user back to the top
    if (getActiveGradeIndex() < gradeCount())
    {
      return getActiveGradeIndex() + 1;
    }
    else if (getActiveGradeIndex() == gradeCount())
    {
      $("#complete").dialog
      ({
        buttons:
        {
            "I'm Done": function()
            {
              location.pathname = "/grades";
            },
            "Not Yet": function()
            {
              $(this).dialog("close");
            }
        }
      });
    }
    else
    {
      return 0;
    }
  }
  function downGradeDOM()
  {
    return "#" + downGrade();
  }
  function upGrade()
  {
    //Goes up a grade unless it's at the top, if it's at the top it goes down to the bottom of the list
    if (getActiveGradeIndex() > 0)
    {
      return getActiveGradeIndex() - 1;
    }
    else
    {
      return gradeCount();
    }
  }
  function upGradeDOM()
  {
    return "#" + upGrade();
  }
  function gradeCount()
  {
    return ($("#grades_egp").children().size() - 1);
  }
  function setDefaults()
  {
    olark('api.box.hide');    
    $("#0").trigger("click");
    $("#top").hide();
    $("#lacking_humility").hide();
    location.hash = "#0";
  }
});