module GradesHelper
  def status(grade)
    if !grade.graded? || grade.score.nil?
      "Not Graded Yet"
    else
      "#{ grade.score.to_i.to_s } out of #{ grade.assignment.score.to_i.to_s }"
    end
  end
  def note(grade)
    if grade.note.nil? || grade.note.empty? || grade.note == "null"
      "No Notes Given"
    else
      grade.note
    end
  end
  def score(grade)
    grade.score.to_s + "/" + grade.assignment.score.to_s if grade.score?
    "Not Graded Yet" unless grade.graded? || grade.score?
  end
  def egp_score(grade)
    return "#{grade.score.to_i}/#{grade.assignment.score.to_i}" if grade.score? && grade.graded?
    return "Not Graded Yet"
  end
end
