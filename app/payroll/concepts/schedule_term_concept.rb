class ScheduleTermConcept < PayrollConcept
  attr_reader :date_from, :date_end

  def initialize(tag_code, values)
    super(ScheduleTermConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())

    @date_from = values[:date_from]
    @date_end  = values[:date_end]
  end

  def evaluate(period, results)
    day_term_from = TERM_BEG_FINISHED
    day_term_end  = TERM_END_FINISHED

    period_date_beg = Date.new(period.year, period.month, 1)
    period_date_end = Date.new(period.year, period.month, Time.days_in_month(period.month, period.year))

    day_term_from = @date_from.day unless @date_from.nil?
    day_term_end  = @date_end.day unless @date_end.nil?

    day_term_from =  1 if (@date_from.nil? || @date_from < period_date_beg)
    day_term_end  = 31 if (@date_end.nil? || @date_end > period_date_end)

    ScheduleTermResult.new(@tag_code, @code, self, {day_ord_from: day_term_from, day_ord_end: day_term_end})
  end
end