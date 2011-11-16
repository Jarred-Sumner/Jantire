//This is mostly copy and pasted from 'grades.js.erb'
$("#show").ready(function()
{
  grade = null;
  setGrade();
  getHomework();
  function setGrade()
  {
    $.ajax
    ({
      type: "GET",
      async: false,
      url: "/grades/" + location.pathname.split("/")[2] + ".json",
      success: function(data)
      {
        grade = data;
        $("#custom_score_input").val(grade.score); // Sets the grade's current score
      }
    });
  } 
  $("#why").click(function()
  {
    showNote();
  });
  $("#note").click(function()
  {
    showNote();
  });
  $(".clickable").mouseenter(function ()
  {
    if ($(this).attr("id") == "none")
    {
      $(this).children("img").css("box-shadow",  "0px 0px 5px #A90000");
    }
    if ($(this).attr("id") == "half")
    {
      $(this).css("box-shadow",  "0px 0px 5px #BAB600");
    }
    if ($(this).attr("id") == "full")
    {
      $(this).children("img").css("box-shadow",  "0px 0px 5px #9DD20D");
    }
  });
  $(".clickable").mouseout(function()
  {
    //Removes hover attributes, it's done through JS to make sure students don't think they can change their score. 
    //The classes to show that the current item is selected has higher precedence than the 'clickable' class, so this is what needs to be done.
    if ($(this).attr("id") == "none")
    {
      $(this).children("img").attr("style", "");
    }
    if ($(this).attr("id") == "half")
    {
      $(this).attr("style", "");
    }
    if ($(this).attr("id") == "full")
    {
      $(this).children("img").attr("style", "");
    }
  });
  $(window).resize(function()
  {
    $("#scribd").children("embed").attr('height', window.innerHeight * 0.60);
  }) 
  $("#full").click(function()
  {
    scoreHomeworkByPercent(1);
  });
  $("#half").click(function()
  {
    scoreHomeworkByPercent(0.5);
  });
  $("#none").click(function()
  {
    scoreHomeworkByPercent(0);
  }); 
  $("#custom_score").click(function()
  {
    customScoreDialog();
  });
  function setActiveToolbar()
  {
    if (grade.graded && grade.score != null)
    {
      resetToolbarItems();
      if (grade.score * 2 == grade.assignment.score)
      {
        $("#half").addClass("half_active");
      }
      else if (grade.score == grade.assignment.score)
      {
        $("#full").addClass("full_active");
      }
      else if (grade.score == 0)
      {
        $("#none").addClass("none_active");
      }
      else if (grade.score)
      {
        $("#custom_score").addClass("custom_score_active");
      }
      if (validateNote())
      {
        $("#note").addClass("note_active");
      }

    }
  }
  function resetToolbarItems()
  {
    $("#note").removeClass("note_active");
    $("#none").removeClass("none_active");
    $("#half").removeClass("half_active");
    $("#full").removeClass("full_active");
    $("#custom_score").removeClass("custom_score_active")
  }
  function getHomework()
  {
    //Sets up the homework for Scribd. 
    doc = scribd.Document.getDoc(grade.document_id, grade.document_access_key);
    doc.addParam('jsapi_version', 1);
    doc.addParam('hide_disabled_buttons', true);
    doc.write('scribd');
    $("#scribd").children("embed").attr('height', window.innerHeight * 0.60);
    setActiveToolbar();
  }
  function scoreHomeworkByPercent(percent)
  {
    $("#custom_score_input").val(grade.assignment.score * percent);
    setActiveToolbar();
    scoreHomework();
  }
  function customScoreDialog()
  {
    $("#custom_score_input").css("width", "50px");
    $("#custom_score_popup").dialog
    ({
      width: "300px",
      buttons:
        {
          "Save Score": function()
          {
            scoreHomework();
            $(this).dialog("close");
          }
        }
    })
  }
  function scoreHomework()
  {
    if ($("#none").hasClass("clickable")) // It checks that it's clickable because I don't want it to make a request if it's a student who clicks on an assignment.
    {
      grade.score = parseInt($("#custom_score_input").val());
      saveScore();
      setActiveToolbar();
      setStatus();
    }
  }
  function saveScore()
  {
     $.ajax
     ({
       url: "/grades/" + location.pathname.split("/")[2],
       data: { grade: { score: grade.score, graded: true, note: grade.note } },
       type: "PUT",
     })
  }
  function setStatus()
  {
    // It sets the status according to the score. Apparently the integer '0' in javascript is 
    if (grade.score || grade.score == 0)
    {
      $("#status").text("Score: " + grade.score + " out of " + parseInt(grade.assignment.score).toString());
    }
    else
    {
      $("#status").text("Score: Not Graded Yet");
    }
  }
  function setNoteStatus()
  {
    if (grade.note && grade.note != "null" && grade.note != "")
    {
      $("#why").show();
      $("#separator").show();
      $("#why").text(grade.note);
    }
    else
    {
      $("#separator").hide();
      $("#why").hide();
    }
  }
  function validateNote()
  {
    /*
      This method needs to exist because Ruby replies that the 'note' attribute of the 'Grade' model is null in JSON. 
      It replies with null in a string instead of a null value.
      Which forces me to write something as stupid/boilerplate-y as this.
      What I really should do is get the as_json or to_json method to reply with null as a value itself.
    */

    if (grade.note == "null" || grade.note == "" || grade.note == undefined)
    {
      return false;
    }
    else
    {
      return true;
    }

  }
  function showNote()
  {
    if ($("#notes").text() == "null" || $("#notes").val() == "null")
    {
      $("#notes").val("No Notes Given");
    }
    $("#notes").css("font-size", "12pt");
    $("#notes").css("width", "450px");
    $("#note_container").css("overflow", "none");
    $("#notes").css("resize", "none");
    if ($("#notes").hasClass("teacher"))
    {
      $("#notes").val(grade.note);
      if (grade.note == "null")
      {
        $("#notes").val("No notes given");
      }
      $("#note_container").dialog(
      {
        width: "500px",
        buttons: 
          {
          "Update Note": function()
          {
            grade.note = $("#notes").val();
            setNoteStatus();
            saveScore();
            setActiveToolbar();
            $(this).dialog("close");
          },
          "Cancel": function()
          {
            $(this).dialog("close");
          }
        }
      });
    }
    else if ($("#notes").hasClass("student"))
    {
      $("#notes").text("Notes: No notes given");
      $("#note_container").dialog({width: "500px"});
    }
  }
});