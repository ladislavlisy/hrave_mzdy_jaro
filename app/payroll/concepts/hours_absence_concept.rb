class HoursAbsenceConcept < PayrollConcept
  def initialize(tag_code)
    super(HoursAbsenceConceptRefer.new, tag_code)
  end
end