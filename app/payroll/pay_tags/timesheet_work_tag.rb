class TimesheetWorkTag < PayrollTag
  def initialize
    super(TimesheetWorkTagRefer.new,
          CodeNameRefer.new(:CONCEPT_TIMESHEET_WORK, :CONCEPT_TIMESHEET_WORK.id2name))
  end
end