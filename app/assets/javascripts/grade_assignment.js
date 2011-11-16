$(document).ready(function()
{
  //Disable olark
  olark('api.box.hide');    
  //Hide my name
  $("#lacking_humility").hide();
  setGrades();
  //Reset hash
  location.hash = "";
  setGradedAsGraded();
  nextAnswer();
  $(window).hashchange(function()
  {
    setActiveAnswer();
  });
  $(window).resize(function()
  {
    setMaxHeight();
  })
  $(".answer").click(function()
  {
    location.hash = $(this).attr("id");
  });
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
  $("#note").click(function()
  {
    addNote();
  });
  $("#custom_score_popup").keyup(function(e)
  {
    if (e.which == "13")
    {
      $("#custom_score_popup").children(".ui-dialog-buttonset").trigger("click");
    }
  });
  $("#custom_score").click(function()
  {
    $("#custom_score_popup").css("font-family", "Georgia");
    $("#custom_score_input").css("font-family", "Georgia");
    $("#custom_score_input").css("height", "20px");
    $("#custom_score_input").css("width", "40px");
    $("#custom_score_popup").css("text-align", "center");
    $("#custom_score_popup").dialog
    ({
      buttons:
      {
        "Save Score": function()
        {
          $("#custom_score_popup").dialog("close");
          gradeHomework();
        },
      }
    });
  });
});
function gradeHomework()
{
  currentGrade().score = parseInt($("#custom_score_input").val());
  currentGrade().graded = true;
  styleToolbar();
  saveGrade(currentGrade());
  nextAnswer();
}
function setActiveAnswer()
{
  $(".active").removeClass("active");
  $(location.hash).addClass("active");
  $("#current_student").text($(location.hash).children(".student_name").text());
  $("#custom_score_input").val(currentGrade().score);
  getHomework();
  setGradedAsGraded();
  styleToolbar();
}
function nextAnswer()
{
  if (grades[parseInt(location.hash.split("#")[1]) + 1])
  {
    location.hash = parseInt(location.hash.split("#")[1]) + 1;
  }
  if(location.hash == "")
  {
    location.hash = "0";
  }
  if (location.hash == "null" || location.hash == "NaN" || grades.indexOf(currentGrade()) > grades.length - 1)
  {
    gradingComplete();
  }
  setGradedAsGraded();
}

function setGradedAsGraded()
{
  for (index = 0; index < grades.length; index++)
  {
    if (grades[index].graded)
    {
      $("#" + index).addClass("graded");
    }
  }
}
function setGrades()
{
  $.ajax
  ({
    type: "GET",
    async: false,
    url: window.location.pathname + "s.json",
    success: function(data)
    {
      assignment = data;
      grades = data.grades;

    }
  });
} 
function setMaxHeight()
{
  if (navigator.appName != 'Microsoft Internet Explorer')
  {
    $("#answer_container").css("min-height", $(window).height() - 62);
    $("#scribd").children("embed").attr('height', $(window).height() * 0.75); 
  }
  else
  {
    $("#answer_container").css("min-height", $(window).height() - 65);
    $("body").css("overflow", "visible");
  }
}
function getHomework()
{
  //Sets up the homework for Scribd
  scribd_document = scribd.Document.getDoc(currentGrade().document_id, currentGrade().document_access_key);
  scribd_document.addParam('jsapi_version', 1);
  scribd_document.addParam('hide_disabled_buttons', true);
  scribd_document.write('scribd');
  //There's a weird bug relating to the height of this element. This is a workaround
  setMaxHeight();
}
function scoreHomeworkByPercent(percent)
{
  $("#custom_score_input").val(assignment.score * percent);
  gradeHomework();
}
function styleToolbar()
{
  resetToolbarItems();
  if (currentGrade().note != "" && currentGrade().note)
  {
    $("#note").addClass("note_active");
  }
  if (currentGrade().score == assignment.score)
  {
    $("#full").addClass("full_active");
  }
  else if (currentGrade().score == assignment.score / 2)
  {
    $("#half").addClass("half_active");
  }
  else if (currentGrade().score == 0)
  {
    $("#none").addClass("none_active");
  }
  else if (currentGrade().score)
  {
    $("#custom_score").addClass("custom_active");
  }
}
function resetToolbarItems()
{
  $("#note").removeClass("note_active");
  $("#none").removeClass("none_active");
  $("#half").removeClass("half_active");
  $("#full").removeClass("full_active");
  $("#custom_score").removeClass("custom_active");
}
function saveGrade(grade)
{        
  grade = validateGrade(grade);
  return $.ajax
  ({
    type: "PUT",
    url: "/grades/" + grade.id,
    data: { grade: { score: grade.score, graded: grade.graded, note: grade.note } },
    success: function()
    {
      return true;
    },
    fail: function()
    {
      return false;
    },
    error: function()
    {
      return false;
    }
  });
}
function addNote()
{
  setNoteStyle();
  resetNote();
  noteDialog();
}
function gradingComplete()
{
  $("#grading_complete").dialog(
    {
      buttons:
      {
        "I'm Done": function()
        {
          window.location.pathname = window.location.pathname + "s/";
        },
        "Not Yet": function()
        {
          $(this).dialog("close");
        }
      }
    }
  );
  $("#grading_complete").children("p").css("color", "black");
  $("#grading_complete").children("p").css("font-size", "12pt");
}
function currentGrade()
{
  return grades[location.hash.split("#")[1]];
}
function setNoteStyle()
{
  $("#notes_text").css("width", "400px");
  $("#notes_text").css("font-size", "12pt");
  $("#notes_text").css("float", "center");
  $("#notes_text").css("resize", "none");
}
function resetNote()
{
  if (currentGrade().note != undefined || currentGrade().note == "" || currentGrade().note == "null" || currentGrade() == null)
  {
    return $("#notes_text").val(currentGrade().note);
  }
}
function noteDialog()
{
    $("#notes").dialog(
    {
      width: 'auto',
      buttons:
      {
        "Add Note": function()
        {
          currentGrade().note = $("#notes_text").val();
          saveGrade(currentGrade());
          styleToolbar();
          $("#notes_text").val("");
          $(this).dialog("close");
        },
        "Cancel": function()
        {
          $("#notes_text").val("");
          $(this).dialog("close");
        }
      }
    });
}
function validateGrade(grade)
{
  if (grade.note == "null")
  {
    grade.note = "";
  }
  return grade;
}