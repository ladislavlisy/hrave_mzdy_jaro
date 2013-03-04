class HoursWorkingConcept < PayrollConcept
  attr_reader :hours

  def initialize(tag_code, values)
    super(HoursWorkingConceptRefer.new, tag_code)
    @hours = values[:hours] || 0
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [
      TimesheetWorkTag.new
    ]
  end

  def evaluate(period, results)
    result_timesheet = get_result_by(results, :TAG_TIMESHEET_WORK)

    result_hours = result_timesheet.hours + hours
    HoursWorkingResult.new(@tag_code, @code, self, {hours: result_hours})
  end
end