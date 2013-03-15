class HoursWorkingConcept < PayrollConcept
  attr_reader :hours

  TAG_TIMESHEET_WORK = PayTagGateway::REF_TIMESHEET_WORK.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_HOURS_WORKING, tag_code)
    init_values(values)
  end

  def init_values(values)
    @hours = values[:hours] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def pending_codes
    [
      TimesheetWorkTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_TIMES
  end

  def evaluate(period, tag_config, results)
    result_timesheet = get_result_by(results, TAG_TIMESHEET_WORK)

    result_hours = result_timesheet.hours + hours
    TermHoursResult.new(@tag_code, @code, self, {hours: result_hours})
  end
end