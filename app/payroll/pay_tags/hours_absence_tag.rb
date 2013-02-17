class HoursAbsenceTag < PayrollTag
  def initialize
    super(:TAG_HOURS_ABSENCE, :TAG_HOURS_ABSENCE.id2name,
          CodeNameRefer.new(:CONCEPT_HOURS_ABSENCE, :CONCEPT_HOURS_ABSENCE.id2name))
  end
end