class TimesheetWorkTag < PayrollTag
  def initialize
    super(:TAG_TIMESHEET_WORK, :TAG_TIMESHEET_WORK.id2name,
          CodeNameRefer.new(:CONCEPT_TIMESHEET_WORK, :CONCEPT_TIMESHEET_WORK.id2name))
  end
end