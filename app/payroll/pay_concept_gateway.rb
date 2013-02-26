class PayConceptGateway
  CONCEPT_SALARY_MONTHLY = 100
  REFCON_SALARY_MONTHLY = CodeNameRefer.new(:CONCEPT_SALARY_MONTHLY, :CONCEPT_SALARY_MONTHLY.id2name)
  CONCEPT_SCHEDULE_WEEKLY = 200
  REFCON_SCHEDULE_WEEKLY = CodeNameRefer.new(:CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name)
  CONCEPT_SCHEDULE_TERM = 201
  REFCON_SCHEDULE_TERM = CodeNameRefer.new(:CONCEPT_SCHEDULE_TERM, :CONCEPT_SCHEDULE_TERM.id2name)
  CONCEPT_TIMESHEET_PERIOD = 202
  REFCON_TIMESHEET_PERIOD = CodeNameRefer.new(:CONCEPT_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name)
  CONCEPT_TIMESHEET_WORK = 203
  REFCON_TIMESHEET_WORK = CodeNameRefer.new(:CONCEPT_TIMESHEET_WORK, :CONCEPT_TIMESHEET_WORK.id2name)
  CONCEPT_HOURS_WORKING = 204
  REFCON_HOURS_WORKING = CodeNameRefer.new(:CONCEPT_HOURS_WORKING, :CONCEPT_HOURS_WORKING.id2name)
  CONCEPT_HOURS_ABSENCE = 205
  REFCON_HOURS_ABSENCE = CodeNameRefer.new(:CONCEPT_HOURS_ABSENCE, :CONCEPT_HOURS_ABSENCE.id2name)
  CONCEPT_TAX_INCOME_BASE = 300
  REFCON_TAX_INCOME_BASE = CodeNameRefer.new(:CONCEPT_TAX_INCOME_BASE, :CONCEPT_TAX_INCOME_BASE.id2name)
  CONCEPT_INSURANCE_HEALTH_BASE = 301
  REFCON_INSURANCE_HEALTH_BASE = CodeNameRefer.new(:CONCEPT_INSURANCE_HEALTH_BASE, :CONCEPT_INSURANCE_HEALTH_BASE.id2name)
  CONCEPT_INSURANCE_SOCIAL_BASE = 302
  REFCON_INSURANCE_SOCIAL_BASE = CodeNameRefer.new(:CONCEPT_INSURANCE_SOCIAL_BASE, :CONCEPT_INSURANCE_SOCIAL_BASE.id2name)
  CONCEPT_TAX_ADVANCE = 303
  REFCON_TAX_ADVANCE = CodeNameRefer.new(:CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name)
  CONCEPT_INSURANCE_HEALTH = 304
  REFCON_INSURANCE_HEALTH = CodeNameRefer.new(:CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name)
  CONCEPT_INSURANCE_SOCIAL = 305
  REFCON_INSURANCE_SOCIAL = CodeNameRefer.new(:CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name)

  CONCEPT_INCOME_GROSS = 901
  REFCON_INCOME_GROSS = CodeNameRefer.new(:CONCEPT_INCOME_GROSS, :CONCEPT_INCOME_GROSS.id2name)
  CONCEPT_INCOME_NETTO = 902
  REFCON_INCOME_NETTO = CodeNameRefer.new(:CONCEPT_INCOME_NETTO, :CONCEPT_INCOME_NETTO.id2name)

  def initialize
    load_concepts
  end

  def concept_for_tag_code(tag_refer)
    values = {}
    concept_class = classname_for(tag_refer.concept_name)
    concept_class = self.class.const_get(concept_class)
    concept_class.new(tag_refer, values)
  end

  def concept_for(tag_code, concept_code, values)
    concept_class = classname_for(concept_code)
    concept_class = self.class.const_get(concept_class)
    concept_class.new(tag_code, values)
  end

  def classname_for(code)
    concept_name = code.match(/CONCEPT_(.*)/)[1]
    class_name = concept_name.underscore.camelize + 'Concept'
    class_name
  end

  def load_concepts
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'concepts', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end
end