class PayConceptGateway
  attr_reader :models

  CONCEPT_UNKNOWN = 0
  REFCON_UNKNOWN = CodeNameRefer.new(CONCEPT_UNKNOWN, :CONCEPT_UNKNOWN.id2name)

  CONCEPT_SALARY_MONTHLY = 100
  REFCON_SALARY_MONTHLY = CodeNameRefer.new(CONCEPT_SALARY_MONTHLY, :CONCEPT_SALARY_MONTHLY.id2name)
  CONCEPT_SCHEDULE_WEEKLY = 200
  REFCON_SCHEDULE_WEEKLY = CodeNameRefer.new(CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name)
  CONCEPT_SCHEDULE_TERM = 201
  REFCON_SCHEDULE_TERM = CodeNameRefer.new(CONCEPT_SCHEDULE_TERM, :CONCEPT_SCHEDULE_TERM.id2name)
  CONCEPT_TIMESHEET_PERIOD = 202
  REFCON_TIMESHEET_PERIOD = CodeNameRefer.new(CONCEPT_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name)
  CONCEPT_TIMESHEET_WORK = 203
  REFCON_TIMESHEET_WORK = CodeNameRefer.new(CONCEPT_TIMESHEET_WORK, :CONCEPT_TIMESHEET_WORK.id2name)
  CONCEPT_HOURS_WORKING = 204
  REFCON_HOURS_WORKING = CodeNameRefer.new(CONCEPT_HOURS_WORKING, :CONCEPT_HOURS_WORKING.id2name)
  CONCEPT_HOURS_ABSENCE = 205
  REFCON_HOURS_ABSENCE = CodeNameRefer.new(CONCEPT_HOURS_ABSENCE, :CONCEPT_HOURS_ABSENCE.id2name)

  CONCEPT_TAX_INCOME_BASE = 300
  REFCON_TAX_INCOME_BASE = CodeNameRefer.new(CONCEPT_TAX_INCOME_BASE, :CONCEPT_TAX_INCOME_BASE.id2name)

  CONCEPT_INSURANCE_HEALTH_BASE = 301
  REFCON_INSURANCE_HEALTH_BASE = CodeNameRefer.new(CONCEPT_INSURANCE_HEALTH_BASE, :CONCEPT_INSURANCE_HEALTH_BASE.id2name)
  CONCEPT_INSURANCE_SOCIAL_BASE = 302
  REFCON_INSURANCE_SOCIAL_BASE = CodeNameRefer.new(CONCEPT_INSURANCE_SOCIAL_BASE, :CONCEPT_INSURANCE_SOCIAL_BASE.id2name)

  CONCEPT_INSURANCE_HEALTH = 303
  REFCON_INSURANCE_HEALTH = CodeNameRefer.new(CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name)
  CONCEPT_INSURANCE_SOCIAL = 304
  REFCON_INSURANCE_SOCIAL = CodeNameRefer.new(CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name)
  CONCEPT_SAVINGS_PENSIONS = 305
  REFCON_SAVINGS_PENSIONS = CodeNameRefer.new(CONCEPT_SAVINGS_PENSIONS, :CONCEPT_SAVINGS_PENSIONS.id2name)

  CONCEPT_TAX_EMPLOYERS_HEALTH = 306
  REFCON_TAX_EMPLOYERS_HEALTH = CodeNameRefer.new(CONCEPT_TAX_EMPLOYERS_HEALTH, :CONCEPT_TAX_EMPLOYERS_HEALTH.id2name)
  CONCEPT_TAX_EMPLOYERS_SOCIAL = 307
  REFCON_TAX_EMPLOYERS_SOCIAL = CodeNameRefer.new(CONCEPT_TAX_EMPLOYERS_SOCIAL, :CONCEPT_TAX_EMPLOYERS_SOCIAL.id2name)

  CONCEPT_TAX_CLAIM_PAYER = 308
  REFCON_TAX_CLAIM_PAYER = CodeNameRefer.new(CONCEPT_TAX_CLAIM_PAYER, :CONCEPT_TAX_CLAIM_PAYER.id2name)
  CONCEPT_TAX_CLAIM_DISABILITY = 309
  REFCON_TAX_CLAIM_DISABILITY = CodeNameRefer.new(CONCEPT_TAX_CLAIM_DISABILITY, :CONCEPT_TAX_CLAIM_DISABILITY.id2name)
  CONCEPT_TAX_CLAIM_STUDYING = 312
  REFCON_TAX_CLAIM_STUDYING = CodeNameRefer.new(CONCEPT_TAX_CLAIM_STUDYING, :CONCEPT_TAX_CLAIM_STUDYING.id2name)
  CONCEPT_TAX_CLAIM_CHILD = 313
  REFCON_TAX_CLAIM_CHILD = CodeNameRefer.new(CONCEPT_TAX_CLAIM_CHILD, :CONCEPT_TAX_CLAIM_CHILD.id2name)

  CONCEPT_TAX_ADVANCE_BASE = 314
  REFCON_TAX_ADVANCE_BASE = CodeNameRefer.new(CONCEPT_TAX_ADVANCE_BASE, :CONCEPT_TAX_ADVANCE_BASE.id2name)
  CONCEPT_TAX_ADVANCE = 315
  REFCON_TAX_ADVANCE = CodeNameRefer.new(CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name)

  CONCEPT_TAX_RELIEF_PAYER = 316
  REFCON_TAX_RELIEF_PAYER = CodeNameRefer.new(CONCEPT_TAX_RELIEF_PAYER, :CONCEPT_TAX_RELIEF_PAYER.id2name)
  CONCEPT_TAX_RELIEF_DISABILITY = 317
  REFCON_TAX_RELIEF_DISABILITY = CodeNameRefer.new(CONCEPT_TAX_RELIEF_DISABILITY, :CONCEPT_TAX_RELIEF_DISABILITY.id2name)
  CONCEPT_TAX_RELIEF_STUDYING = 318
  REFCON_TAX_RELIEF_STUDYING = CodeNameRefer.new(CONCEPT_TAX_RELIEF_STUDYING, :CONCEPT_TAX_RELIEF_STUDYING.id2name)
  CONCEPT_TAX_RELIEF_CHILD = 319
  REFCON_TAX_RELIEF_CHILD = CodeNameRefer.new(CONCEPT_TAX_RELIEF_CHILD, :CONCEPT_TAX_RELIEF_CHILD.id2name)

  CONCEPT_TAX_BONUS_CHILD = 320
  REFCON_TAX_BONUS_CHILD = CodeNameRefer.new(CONCEPT_TAX_BONUS_CHILD, :CONCEPT_TAX_BONUS_CHILD.id2name)

  CONCEPT_TAX_ADVANCE_FINAL = 321
  REFCON_TAX_ADVANCE_FINAL = CodeNameRefer.new(CONCEPT_TAX_ADVANCE_FINAL, :CONCEPT_TAX_ADVANCE_FINAL.id2name)


  CONCEPT_TAX_WITHHOLD_BASE = 325
  REFCON_TAX_WITHHOLD_BASE = CodeNameRefer.new(CONCEPT_TAX_WITHHOLD_BASE, :CONCEPT_TAX_WITHHOLD_BASE.id2name)
  CONCEPT_TAX_WITHHOLD = 326
  REFCON_TAX_WITHHOLD = CodeNameRefer.new(CONCEPT_TAX_WITHHOLD, :CONCEPT_TAX_WITHHOLD.id2name)

  CONCEPT_INCOME_GROSS = 901
  REFCON_INCOME_GROSS = CodeNameRefer.new(CONCEPT_INCOME_GROSS, :CONCEPT_INCOME_GROSS.id2name)
  CONCEPT_INCOME_NETTO = 902
  REFCON_INCOME_NETTO = CodeNameRefer.new(CONCEPT_INCOME_NETTO, :CONCEPT_INCOME_NETTO.id2name)

  def initialize
    load_concepts
    @models = Hash.new
    @models[CONCEPT_UNKNOWN] = UnknownConcept.new
  end

  def concept_for(tag_code, concept_name, values)
    concept_class = classname_for(concept_name)
    concept_class = self.class.const_get(concept_class)
    concept_class.new(tag_code, values)
  end

  def classname_for(code_name)
    concept_name = code_name.match(/CONCEPT_(.*)/)[1]
    class_name = concept_name.underscore.camelize + 'Concept'
    class_name
  end

  def load_concepts
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'concepts', '*.rb')
    Dir.glob(full_pattern).each {|file| require file}
  end

  #concept tree
  def concept_from_models(term_tag)
    if !models.include?(term_tag.concept_code)
      base_concept = empty_concept_for(term_tag)
      models[term_tag.concept_code] = base_concept
    else
      base_concept = models[term_tag.concept_code]
    end
    base_concept
  end

  def find_concept(concept_code)
    if models.include?(concept_code)
      base_concept = models[concept_code]
    else
      base_concept = models[CONCEPT_UNKNOWN]
    end
    base_concept
  end

  def empty_concept_for(term_tag)
    empty_values = {}
    empty_concept = concept_for(term_tag.code, term_tag.concept_name, empty_values)
    empty_pending = rec_pending_codes(empty_concept.pending_codes)
    empty_concept.set_pending_codes(empty_pending)
    return empty_concept
  end

  def collect_pending_codes_for(term_hash)
    pending = term_hash.inject ([]) do |agr, term_item|
      term_concept = term_item.last
      term_pending_codes = term_concept.pending_codes
      agr.concat(rec_pending_codes(term_pending_codes))
    end
    pending_uniq = pending.uniq
  end

  def rec_pending_codes(pending_codes)
    #rspec_log_pending_array(pending_codes)
    ret_codes = pending_codes.inject(pending_codes.dup)  do |agr, tag|
      pending_codes_fot_tag = pending_codes_for_tag_code(tag)
      agr.concat(pending_codes_fot_tag)
    end
    ret_codes.uniq
  end

  def pending_codes_for_tag_code(tag_refer)
    base_concept = concept_from_models(tag_refer)
    if base_concept.tag_pending_codes.nil?
      rec_pending_codes(base_concept.pending_codes)
    else
      base_concept.tag_pending_codes
    end
  end

  #debug log in RSpec log
  def rspec_log_pending_array(pending_codes)
    pending_codes.each do |item|
      ::Rails.logger.info("#{item.name} - #{item.concept_name}\n")
    end
  end

end