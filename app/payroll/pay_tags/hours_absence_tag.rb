class HoursAbsenceTag < PayrollTag
  def initialize
    super(HoursAbsenceTagRefer.new,
          CodeNameRefer.new(:CONCEPT_HOURS_ABSENCE, :CONCEPT_HOURS_ABSENCE.id2name))
  end
end