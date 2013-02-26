class HoursAbsenceConcept < PayrollConcept
  def initialize(tag_code, values)
    super(HoursAbsenceConceptRefer.new, tag_code)
  end
end