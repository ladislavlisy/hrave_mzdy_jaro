class PayTagGateway
  TAG_SCHEDULE_WORK = 10001
  TAG_SALARY_BASE = 10101

  def initialize
    load_pay_tags
  end

  def tag_for(tag_code)
    tag_class = classname_for(tag_code)
    tag_class = self.class.const_get(tag_class)
    tag_class.new
  end

  def classname_for(tag_code)
    tag_code.camelize + 'Tag'
  end

  def load_pay_tags
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'pay_tags', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end
end