class PayConceptGateway
  CONCEPT_AMOUNT_MONTHLY = 100
  CONCEPT_SCHEDULE_WEEKLY = 200
  CONCEPT_INCOME_TAXABLE = 300
  CONCEPT_INSURANCE_HEALTH_BASE = 301
  CONCEPT_INSURANCE_SOCIAL_BASE = 302
  CONCEPT_TAX_ADVANCE = 303
  CONCEPT_INSURANCE_HEALTH = 304
  CONCEPT_INSURANCE_SOCIAL = 305

  CONCEPT_INCOME_GROSS = 901
  CONCEPT_INCOME_NETTO = 902

  def initialize
    load_concepts
  end

  def concept_for(concept_code, values)
    concept_class = classname_for(concept_code)
    concept_class = self.class.const_get(concept_class)
    concept_class.new(values)
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