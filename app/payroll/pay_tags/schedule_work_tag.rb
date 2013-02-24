# Specification:
# Job timesheet hours
# Job timesheet days
# Job timesheet hours in holidays
# Job timesheet days in holidays
# Job hours
# Job days
# Job hours in holidays
# Job days in holidays

# Working timesheet hours
# Working timesheet days
# Working timesheet hours in holidays
# Working timesheet days in holidays
# Working hours
# Working days
# Working hours in holidays
# Working days in holidays

class ScheduleWorkTag < PayrollTag
  def initialize
    super(ScheduleWorkTagRefer.new,
          CodeNameRefer.new(:CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name))
  end
end