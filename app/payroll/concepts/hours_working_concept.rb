class HoursWorkingConcept < PayrollConcept
  attr_reader :hours

  def initialize(tag_code, values)
    super(HoursWorkingConceptRefer.new, tag_code)
    @hours = values[:hours]
  end

  def evaluate(period, results)
    result_timesheet = get_result_by(results, :TAG_TIMESHEET_WORK)

    result_hours = result_timesheet.hours + hours
    HoursWorkingResult.new(@tag_code, @code, self, {hours: result_hours})
  end
end