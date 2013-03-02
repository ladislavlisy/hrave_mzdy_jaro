class HoursAbsenceConcept < PayrollConcept
  attr_reader :hours
  def initialize(tag_code, values)
    super(HoursAbsenceConceptRefer.new, tag_code)
    @hours = values[:hours]
  end

  def evaluate(period, results)
    result_hours = hours
    HoursAbsenceResult.new(@tag_code, @code, self, {hours: result_hours})
  end
end