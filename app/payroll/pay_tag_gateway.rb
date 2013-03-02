class PayTagGateway
  #Work Shift Schedule
  TAG_SCHEDULE_WORK = 10001
  REF_SCHEDULE_WORK = CodeNameRefer.new(:TAG_SCHEDULE_WORK, :TAG_SCHEDULE_WORK.id2name)
  #Work Time Interval
  TAG_SCHEDULE_TERM = 10002
  REF_SCHEDULE_TERM = CodeNameRefer.new(:TAG_SCHEDULE_TERM, :TAG_SCHEDULE_TERM.id2name)

  #Job Time Sheet
  TAG_TIMESHEET_PERIOD = 10003
  REF_TIMESHEET_PERIOD = CodeNameRefer.new(:TAG_TIMESHEET_PERIOD, :TAG_TIMESHEET_PERIOD.id2name)

  #Work Time Sheet
  TAG_TIMESHEET_WORK = 10004
  REF_TIMESHEET_WORK = CodeNameRefer.new(:TAG_TIMESHEET_WORK, :TAG_TIMESHEET_WORK.id2name)

  #Work Hours
  TAG_HOURS_WORKING = 10005
  REF_HOURS_WORKING = CodeNameRefer.new(:TAG_HOURS_WORKING, :TAG_HOURS_WORKING.id2name)

  #Absence Hours
  TAG_HOURS_ABSENCE = 10006
  REF_HOURS_ABSENCE = CodeNameRefer.new(:TAG_HOURS_ABSENCE, :TAG_HOURS_ABSENCE.id2name)

  #Salary Amount
  TAG_SALARY_BASE = 10101
  REF_SALARY_BASE = CodeNameRefer.new(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)

  TAG_TAX_INCOME_BASE = 30001
  REF_TAX_INCOME_BASE = CodeNameRefer.new(:TAG_TAX_INCOME_BASE, :TAG_TAX_INCOME_BASE.id2name)

  TAG_INSURANCE_HEALTH_BASE = 30002
  REF_INSURANCE_HEALTH_BASE = CodeNameRefer.new(:TAG_INSURANCE_HEALTH_BASE, :TAG_INSURANCE_HEALTH_BASE.id2name)

  TAG_INSURANCE_SOCIAL_BASE = 30003
  REF_INSURANCE_SOCIAL_BASE = CodeNameRefer.new(:TAG_INSURANCE_SOCIAL_BASE, :TAG_INSURANCE_SOCIAL_BASE.id2name)

  TAG_TAX_ADVANCE = 30004
  REF_TAX_ADVANCE = CodeNameRefer.new(:TAG_TAX_ADVANCE, :TAG_TAX_ADVANCE.id2name)
  TAG_INSURANCE_HEALTH = 30005
  REF_INSURANCE_HEALTH = CodeNameRefer.new(:TAG_INSURANCE_HEALTH, :TAG_INSURANCE_HEALTH.id2name)
  TAG_INSURANCE_SOCIAL = 30006
  REF_INSURANCE_SOCIAL = CodeNameRefer.new(:TAG_INSURANCE_SOCIAL, :TAG_INSURANCE_SOCIAL.id2name)

  TAG_INCOME_GROSS = 90001
  REF_INCOME_GROSS = CodeNameRefer.new(:TAG_INCOME_GROSS, :TAG_INCOME_GROSS.id2name)
  TAG_INCOME_NETTO = 90002
  REF_INCOME_NETTO = CodeNameRefer.new(:TAG_INCOME_NETTO, :TAG_INCOME_NETTO.id2name)

  def initialize
    load_pay_tags
  end

  def tag_for(tag_code)
    tag_class = classname_for(tag_code)
    tag_class = self.class.const_get(tag_class)
    tag_class.new
  end

  def classname_for(tag_code)
    tag_name = tag_code.match(/TAG_(.*)/)[1]
    class_name = tag_name.underscore.camelize + 'Tag'
    class_name
  end

  def load_pay_tags
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'pay_tags', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end
end