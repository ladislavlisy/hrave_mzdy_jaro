class ScheduleTermConcept < PayrollConcept
  attr_reader :work_from, :work_end

  def initialize(tag_code, values)
    super(ScheduleTermConceptRefer.new, tag_code)

    @work_from = values[:work_from]
    @work_end  = values[:work_end]
  end

  def evaluate(period, results)
    day_term_from = TERM_BEG_FINISHED
    day_term_end  = TERM_END_FINISHED

    period_date_beg = Date.new(period.year, period.month, 1)
    period_date_end = Date.new(period.year, period.month, period_date_beg.mday)

    day_term_from = @work_from.day unless @work_from.nil?
    day_term_end  = @work_end.day unless @work_end.nil?

    day_term_from =  1 if (@work_from.nil? || @work_from < period_date_beg)
    day_term_end  = 31 if (@work_end.nil? || @work_end > period_date_end)

    ScheduleTermResult.new(@tag_code, @code, self, {term_from: day_term_from, term_end: day_term_end})
  end
end