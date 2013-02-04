class PayTagGateway
  TAG_SCHEDULE_WORK = 10001
  TAG_SALARY_BASE = 10101
  TAG_INCOME_TAXABLE = 30001
  TAG_INSURANCE_HEALTH_BASE = 30002
  TAG_INSURANCE_SOCIAL_BASE = 30003
  TAG_TAX_ADVANCE = 30004
  TAG_INSURANCE_HEALTH = 30005
  TAG_INSURANCE_SOCIAL = 30006

  TAG_INCOME_GROSS = 90001
  TAG_INCOME_NETTO = 90002

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