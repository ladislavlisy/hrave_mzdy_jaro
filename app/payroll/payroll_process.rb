#require "payroll_period.rb"
#require "pay_tag_gateway.rb"

class PayrollProcess
  attr_reader :period
  attr_reader :tags
  attr_reader :concepts

  def initialize(tag_gate, concept_gate, period)
    @tags = tag_gate
    @concepts = concept_gate

    @period = period
    @terms = Hash.new
    @results = Hash.new
  end

  def find_tag(tag_code)
    tags.find_tag(tag_code)
  end

  def find_concept(concept_code)
    concepts.find_concept(concept_code)
  end

  #add fetched term
  def ins_term(period_base, term_refer, code_order, term_values)
    ins_term_to_hash(@terms, period_base, term_refer, code_order, term_values)
  end

  def ins_term_to_hash(term_hash, period_base, term_refer, code_order, term_values)
    term_to_insert = new_term_pair_with_order(period_base, term_refer, code_order, term_values)
    term_hash.merge!(term_to_insert)
    term_to_insert.keys[0]
  end

  #add a new term
  def add_term(term_refer, term_values)
    period_base = PayrollPeriod::NOW
    add_term_to_hash(@terms, period_base, term_refer, term_values)
  end

  def add_term_to_hash(term_hash, period_base, term_refer, term_values)
    term_to_add = new_term_pair(term_hash, period_base, term_refer, term_values)
    term_hash.merge!(term_to_add)
    term_to_add.keys[0]
  end

  #add term for a new or ignore for existing term
  def merge_term_to_hash(term_hash, period_base, term_refer, term_values)
    merge_code_order = get_tag_order_from(term_hash, period_base, term_refer.code)
    term_to_merge = new_term_pair_with_order(period_base, term_refer, merge_code_order, term_values)
    term_hash.merge!(term_to_merge) do |tag, term_concept, _|
      term_concept
    end
    term_hash
  end

  #get term from Terms by key of tag
  def get_term(pay_tag)
    @terms.select { |key,_| key==pay_tag }
  end

  #get term from Results by key of tag
  def get_result(pay_tag)
    @results.select { |key,_| key==pay_tag }
  end

  #get term from Results by key of tag
  def get_results
    @results
  end

  #evaluate and return result from Results by key of tag
  def evaluate(pay_tag)
    period_base = PayrollPeriod::NOW

    pending_uniq_codes = concepts.collect_pending_codes_for(@terms)

    calculation_steps = create_calculation_steps(@terms, period_base, pending_uniq_codes)

    sorted_calculation = calculation_steps.sort {|a,b| a.last<=>b.last}

    @results = sorted_calculation.inject({}) do |agr, x|
      agr.merge!({x.first => x.last.evaluate(period, tags, agr)})
    end

    get_result(pay_tag)
  end

  #create key (class TagRefer) with period, code, code_order
  def new_term_key_with_order(period_base, term_refer, code_order)
    term_key = TagRefer.new(period_base, term_refer.code, code_order)
  end

  #create concept with value of amount, for tag code, figure out concept name
  def new_term_concept(term_refer, term_values)
    term_tag = tags.tag_from_models(term_refer)
    base_concept = concepts.concept_from_models(term_tag)
    term_concept = base_concept.dup_with_value(term_tag.code, term_values)
  end

  #create pair of TagRefer and PayrollConcept with code order
  def new_term_pair_with_order(period_base, term_refer, code_order, term_values)
    term_key = new_term_key_with_order(period_base, term_refer, code_order)
    term_concept = new_term_concept(term_refer, term_values)
    {term_key => term_concept}
  end

  #create pair of TagRefer and PayrollConcept with a new code order
  def new_term_pair(term_hash, period_base, term_refer, term_values)
    new_code_order = get_new_tag_order_from(term_hash, period_base, term_refer.code)
    term_key = new_term_key_with_order(period_base, term_refer, new_code_order)
    term_concept = new_term_concept(term_refer, term_values)
    {term_key => term_concept}
  end

  #get a new code order
  def get_new_tag_order(period_base, code)
    get_new_tag_order_from(@terms, period_base, code)
  end

  def get_new_tag_order_from(term_hash, period_base, code)
    get_new_tag_order_in_array(term_hash.keys, period_base, code)
  end

  def get_new_tag_order_in_array(keys_array, period_base, code)
    selected_tags = select_tags_for_code(keys_array, period_base, code)
    mapped_orders = map_tags_to_code_orders(selected_tags)
    get_new_order_from(mapped_orders.sort)
  end

  def get_tag_order_from(term_hash, period_base, code)
    get_tag_order_in_array(term_hash.keys, period_base, code)
  end

  def get_tag_order_in_array(keys_array, period_base, code)
    selected_tags = select_tags_for_code(keys_array, period_base, code)
    mapped_orders = map_tags_to_code_orders(selected_tags)
    get_first_order_from(mapped_orders.sort)
  end

  def map_tags_to_code_orders(keys_array)
    keys_array.map { |x| x.code_order }
  end

  def select_tags_for_code(keys_array, period_base, code)
    keys_array.select { |x| x.period_base==period_base && x.code==code }
  end

  def get_new_order_from(orders_sorted)
    last_code_order = orders_sorted.inject(0) { |agr, x| ((x > agr) && (x - agr) > 1) ? agr : x }
    (last_code_order + 1)
  end

  def get_first_order_from(orders_sorted)
    first_code_order = 1
    first_code_order = orders_sorted.first unless orders_sorted.first.nil?
  end

  def concept_for(code)
    empty_values = {}
    concept = concepts.concept_for(code.concept_code, code.concept_name, empty_values)
  end

  def create_calculation_steps(term_hash, period_base, pending_codes)
    empty_value = {}
    calculation_steps = pending_codes.inject (term_hash.deep_dup) do |agr,code|
      merge_term_to_hash(agr, period_base, code, empty_value)
    end
    calculation_steps
  end

end