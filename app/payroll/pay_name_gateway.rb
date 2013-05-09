class PayNameGateway
  TAG_UNKNOWN = PayTagGateway::TAG_UNKNOWN
  VPAYGRP_UNKNOWN = nil
  HPAYGRP_UNKNOWN = nil

  VPAYGRP_SCHEDULE   = 'VPAYGRP_SCHEDULE'
  VPAYGRP_PAYMENTS   = 'VPAYGRP_PAYMENTS'
  VPAYGRP_TAX_SOURCE = 'VPAYGRP_TAX_SOURCE'
  VPAYGRP_TAX_RESULT = 'VPAYGRP_TAX_RESULT'
  VPAYGRP_INS_RESULT = 'VPAYGRP_INS_RESULT'
  VPAYGRP_TAX_INCOME = 'VPAYGRP_TAX_INCOME'
  VPAYGRP_INS_INCOME = 'VPAYGRP_INS_INCOME'
  VPAYGRP_SUMMARY    = 'VPAYGRP_SUMMARY'

  attr_reader :models

  def initialize
    load_pay_names
    @models = Hash.new
    @models[TAG_UNKNOWN] = UnknownName.new
    load_models
  end

  def load_models
    name_from_models(PayTagGateway::REF_SCHEDULE_WORK)
    name_from_models(PayTagGateway::REF_SCHEDULE_TERM)
    name_from_models(PayTagGateway::REF_TIMESHEET_PERIOD)
    name_from_models(PayTagGateway::REF_TIMESHEET_WORK)
    name_from_models(PayTagGateway::REF_HOURS_WORKING)
    name_from_models(PayTagGateway::REF_HOURS_ABSENCE)
    name_from_models(PayTagGateway::REF_SALARY_BASE)
    name_from_models(PayTagGateway::REF_TAX_INCOME_BASE)
    name_from_models(PayTagGateway::REF_INSURANCE_HEALTH_BASE)
    name_from_models(PayTagGateway::REF_INSURANCE_SOCIAL_BASE)
    name_from_models(PayTagGateway::REF_INSURANCE_HEALTH)
    name_from_models(PayTagGateway::REF_INSURANCE_SOCIAL)
    name_from_models(PayTagGateway::REF_SAVINGS_PENSIONS)
    name_from_models(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH)
    name_from_models(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL)
    name_from_models(PayTagGateway::REF_TAX_CLAIM_PAYER)
    name_from_models(PayTagGateway::REF_TAX_CLAIM_DISABILITY)
    name_from_models(PayTagGateway::REF_TAX_CLAIM_STUDYING)
    name_from_models(PayTagGateway::REF_TAX_CLAIM_CHILD)
    name_from_models(PayTagGateway::REF_TAX_RELIEF_PAYER)
    name_from_models(PayTagGateway::REF_TAX_RELIEF_CHILD)
    name_from_models(PayTagGateway::REF_TAX_ADVANCE_BASE)
    name_from_models(PayTagGateway::REF_TAX_ADVANCE)
    name_from_models(PayTagGateway::REF_TAX_BONUS_CHILD)
    name_from_models(PayTagGateway::REF_TAX_ADVANCE_FINAL)
    name_from_models(PayTagGateway::REF_TAX_WITHHOLD_BASE)
    name_from_models(PayTagGateway::REF_TAX_WITHHOLD)
    name_from_models(PayTagGateway::REF_INCOME_GROSS)
    name_from_models(PayTagGateway::REF_INCOME_NETTO)
  end

  def name_for(tag_code_name)
    tag_class = classname_for(tag_code_name)
    tag_class = self.class.const_get(tag_class)
    tag_class.new
  end

  def classname_for(tag_code_name)
    tag_name = tag_code_name.match(/TAG_(.*)/)[1]
    class_name = tag_name.underscore.camelize + 'Name'
    class_name
  end

  def load_pay_names
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'pay_tag_names', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end

  #pay name cache
  def name_from_models(term_tag)
    if !models.include?(term_tag.code)
      base_name = empty_name_for(term_tag)
      models[term_tag.code] = base_name
    else
      base_name = models[term_tag.code]
    end
    base_name
  end

  def find_name(tag_code)
    if models.include?(tag_code)
      base_name = models[tag_code]
    else
      base_name = models[TAG_UNKNOWN]
    end
    base_name
  end

  def empty_name_for(term_tag)
    empty_name = name_for(term_tag.name)
    return empty_name
  end
end