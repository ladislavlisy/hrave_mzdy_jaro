class PayTagGateway
  attr_reader :models

  TAG_UNKNOWN = 0
  REF_UNKNOWN = CodeNameRefer.new(TAG_UNKNOWN, :TAG_UNKNOWN.id2name)

  #Work Shift Schedule
  TAG_SCHEDULE_WORK = 10001
  REF_SCHEDULE_WORK = CodeNameRefer.new(TAG_SCHEDULE_WORK, :TAG_SCHEDULE_WORK.id2name)
  #Work Time Interval
  TAG_SCHEDULE_TERM = 10002
  REF_SCHEDULE_TERM = CodeNameRefer.new(TAG_SCHEDULE_TERM, :TAG_SCHEDULE_TERM.id2name)

  #Job Time Sheet
  TAG_TIMESHEET_PERIOD = 10003
  REF_TIMESHEET_PERIOD = CodeNameRefer.new(TAG_TIMESHEET_PERIOD, :TAG_TIMESHEET_PERIOD.id2name)

  #Work Time Sheet
  TAG_TIMESHEET_WORK = 10004
  REF_TIMESHEET_WORK = CodeNameRefer.new(TAG_TIMESHEET_WORK, :TAG_TIMESHEET_WORK.id2name)

  #Work Hours
  TAG_HOURS_WORKING = 10005
  REF_HOURS_WORKING = CodeNameRefer.new(TAG_HOURS_WORKING, :TAG_HOURS_WORKING.id2name)

  #Absence Hours
  TAG_HOURS_ABSENCE = 10006
  REF_HOURS_ABSENCE = CodeNameRefer.new(TAG_HOURS_ABSENCE, :TAG_HOURS_ABSENCE.id2name)

  #Salary Amount
  TAG_SALARY_BASE = 10101
  REF_SALARY_BASE = CodeNameRefer.new(TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)

  TAG_TAX_INCOME_BASE = 30001
  REF_TAX_INCOME_BASE = CodeNameRefer.new(TAG_TAX_INCOME_BASE, :TAG_TAX_INCOME_BASE.id2name)

  TAG_INSURANCE_HEALTH_BASE = 30002
  REF_INSURANCE_HEALTH_BASE = CodeNameRefer.new(TAG_INSURANCE_HEALTH_BASE, :TAG_INSURANCE_HEALTH_BASE.id2name)

  TAG_INSURANCE_SOCIAL_BASE = 30003
  REF_INSURANCE_SOCIAL_BASE = CodeNameRefer.new(TAG_INSURANCE_SOCIAL_BASE, :TAG_INSURANCE_SOCIAL_BASE.id2name)

  TAG_INSURANCE_HEALTH = 30005
  REF_INSURANCE_HEALTH = CodeNameRefer.new(TAG_INSURANCE_HEALTH, :TAG_INSURANCE_HEALTH.id2name)
  TAG_INSURANCE_SOCIAL = 30006
  REF_INSURANCE_SOCIAL = CodeNameRefer.new(TAG_INSURANCE_SOCIAL, :TAG_INSURANCE_SOCIAL.id2name)
  TAG_SAVINGS_PENSIONS = 30007
  REF_SAVINGS_PENSIONS = CodeNameRefer.new(TAG_SAVINGS_PENSIONS, :TAG_SAVINGS_PENSIONS.id2name)

  TAG_TAX_EMPLOYERS_HEALTH = 30008
  REF_TAX_EMPLOYERS_HEALTH = CodeNameRefer.new(TAG_TAX_EMPLOYERS_HEALTH, :TAG_TAX_EMPLOYERS_HEALTH.id2name)
  TAG_TAX_EMPLOYERS_SOCIAL = 30009
  REF_TAX_EMPLOYERS_SOCIAL = CodeNameRefer.new(TAG_TAX_EMPLOYERS_SOCIAL, :TAG_TAX_EMPLOYERS_SOCIAL.id2name)

  TAG_TAX_CLAIM_PAYER = 30010
  REF_TAX_CLAIM_PAYER = CodeNameRefer.new(TAG_TAX_CLAIM_PAYER, :TAG_TAX_CLAIM_PAYER.id2name)
  TAG_TAX_CLAIM_DISABILITY = 30011
  REF_TAX_CLAIM_DISABILITY = CodeNameRefer.new(TAG_TAX_CLAIM_DISABILITY, :TAG_TAX_CLAIM_DISABILITY.id2name)
  TAG_TAX_CLAIM_STUDYING = 30014
  REF_TAX_CLAIM_STUDYING = CodeNameRefer.new(TAG_TAX_CLAIM_STUDYING, :TAG_TAX_CLAIM_STUDYING.id2name)
  TAG_TAX_CLAIM_CHILD = 30019
  REF_TAX_CLAIM_CHILD = CodeNameRefer.new(TAG_TAX_CLAIM_CHILD, :TAG_TAX_CLAIM_CHILD.id2name)

  TAG_TAX_RELIEF_PAYER = 30020
  REF_TAX_RELIEF_PAYER = CodeNameRefer.new(TAG_TAX_RELIEF_PAYER, :TAG_TAX_RELIEF_PAYER.id2name)
  TAG_TAX_RELIEF_CHILD = 30029
  REF_TAX_RELIEF_CHILD = CodeNameRefer.new(TAG_TAX_RELIEF_CHILD, :TAG_TAX_RELIEF_CHILD.id2name)

  TAG_TAX_ADVANCE_BASE = 30030
  REF_TAX_ADVANCE_BASE = CodeNameRefer.new(TAG_TAX_ADVANCE_BASE, :TAG_TAX_ADVANCE_BASE.id2name)
  TAG_TAX_ADVANCE = 30031
  REF_TAX_ADVANCE = CodeNameRefer.new(TAG_TAX_ADVANCE, :TAG_TAX_ADVANCE.id2name)

  TAG_TAX_BONUS_CHILD = 30033
  REF_TAX_BONUS_CHILD = CodeNameRefer.new(TAG_TAX_BONUS_CHILD, :TAG_TAX_BONUS_CHILD.id2name)
  TAG_TAX_ADVANCE_FINAL = 30034
  REF_TAX_ADVANCE_FINAL = CodeNameRefer.new(TAG_TAX_ADVANCE_FINAL, :TAG_TAX_ADVANCE_FINAL.id2name)

  TAG_TAX_WITHHOLD_BASE = 30035
  REF_TAX_WITHHOLD_BASE = CodeNameRefer.new(TAG_TAX_WITHHOLD_BASE, :TAG_TAX_WITHHOLD_BASE.id2name)
  TAG_TAX_WITHHOLD = 30036
  REF_TAX_WITHHOLD = CodeNameRefer.new(TAG_TAX_WITHHOLD, :TAG_TAX_WITHHOLD.id2name)

  TAG_INCOME_GROSS = 90001
  REF_INCOME_GROSS = CodeNameRefer.new(TAG_INCOME_GROSS, :TAG_INCOME_GROSS.id2name)
  TAG_INCOME_NETTO = 90002
  REF_INCOME_NETTO = CodeNameRefer.new(TAG_INCOME_NETTO, :TAG_INCOME_NETTO.id2name)

  def initialize
    load_pay_tags
    @models = Hash.new
    @models[TAG_UNKNOWN] = UnknownTag.new
  end

  def tag_for(tag_code_name)
    tag_class = classname_for(tag_code_name)
    tag_class = self.class.const_get(tag_class)
    tag_class.new
  end

  def classname_for(tag_code_name)
    tag_name = tag_code_name.match(/TAG_(.*)/)[1]
    class_name = tag_name.underscore.camelize + 'Tag'
    class_name
  end

  def load_pay_tags
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'pay_tags', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end

  #pay tag cache
  def tag_from_models(term_tag)
    if !models.include?(term_tag.code)
      base_tag = empty_tag_for(term_tag)
      models[term_tag.code] = base_tag
    else
      base_tag = models[term_tag.code]
    end
    base_tag
  end

  def find_tag(tag_code)
    if models.include?(tag_code)
      base_tag = models[tag_code]
    else
      base_tag = models[TAG_UNKNOWN]
    end
    base_tag
  end

  def empty_tag_for(term_tag)
    empty_tag = tag_for(term_tag.name)
    return empty_tag
  end

end