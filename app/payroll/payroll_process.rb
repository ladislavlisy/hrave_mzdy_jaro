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

  #add fetched term
  def ins_term(period_base, term_refer, code_order, amount)
    ins_term_to_hash(@terms, period_base, term_refer, code_order, amount)
  end

  def ins_term_to_hash(term_hash, period_base, term_refer, code_order, amount)
    term_to_insert = new_term_pair_with_order(period_base, term_refer, code_order, amount)
    term_hash.merge!(term_to_insert)
    term_to_insert.keys[0]
  end

  #add a new term
  def add_term(term_refer, amount)
    period_base = PayrollPeriod::NOW
    add_term_to_hash(@terms, period_base, term_refer, amount)
  end

  def add_term_to_hash(term_hash, period_base, term_refer, amount)
    term_to_add = new_term_pair(term_hash, period_base, term_refer, amount)
    term_hash.merge!(term_to_add)
    term_to_add.keys[0]
  end

  #add term for a new or ignore for existing term
  def merge_term_to_hash(term_hash, period_base, term_refer, amount)
    merge_code_order = get_tag_order_from(term_hash, period_base, term_refer.code)
    term_to_merge = new_term_pair_with_order(period_base, term_refer, merge_code_order, amount)
    term_hash.merge!(term_to_merge) do |tag, term_value, _|
      term_value
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

  #evaluate and return result from Results by key of tag
  def evaluate(pay_tag)
    period_base = PayrollPeriod::NOW

    pending_uniq_codes = collect_pending_codes_for(@terms)

    calculation_steps = create_calculation_steps(@terms, period_base, pending_uniq_codes)

    sorted_calculation = calculation_steps.sort {|a,b| a.last<=>b.last}

    @results = sorted_calculation.inject({}) do |agr, x|
      agr.merge!({x[0] => x[1].evaluate(period, agr)})
    end

    get_result(pay_tag)
  end

  #create key (class TagRefer) with period, code, code_order
  def new_term_key_with_order(period_base, term_refer, code_order)
    term_key = TagRefer.new(period_base, term_refer.code, code_order)
  end

  #create concept with value of amount, for tag code, figure out concept name
  def new_term_concept(term_refer, amount)
    term_tag = tags.tag_for(term_refer.name)
    term_concept = concepts.concept_for(term_refer.code, term_tag.concept.name, amount)
  end

  #create pair of TagRefer and PayrollConcept with code order
  def new_term_pair_with_order(period_base, term_refer, code_order, amount)
    term_key = new_term_key_with_order(period_base, term_refer, code_order)
    term_concept = new_term_concept(term_refer, amount)
    {term_key => term_concept}
  end

  #create pair of TagRefer and PayrollConcept with a new code order
  def new_term_pair(term_hash, period_base, term_refer, amount)
    new_code_order = get_new_tag_order_from(term_hash, period_base, term_refer.code)
    term_key = new_term_key_with_order(period_base, term_refer, new_code_order)
    term_concept = new_term_concept(term_refer, amount)
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
    last_code_order = orders_sorted.inject(0) { |agr, x| x-agr > 1 ? agr : x }
    (last_code_order + 1)
  end

  def get_first_order_from(orders_sorted)
    first_code_order = 1
    first_code_order = orders_sorted.first unless orders_sorted.first.nil?
  end

  def collect_pending_codes_for(term_hash)
    pending = term_hash.inject ([]) { |agr, e| agr.concat(rec_pending_codes(e.last)) }
    pending_uniq = pending.uniq
  end

  def rec_pending_codes(concept)
    pending_codes = concept.pending_codes
    ret_codes = pending_codes.inject(pending_codes.dup) {|agr, t| agr.concat(rec_pending_codes(concept_for(t)))}
  end

  def concept_for(code)
    values = {}
    concept = concepts.concept_for(code.concept_code, code.concept_name, values)
  end

  def create_calculation_steps(term_hash, period_base, pending_codes)
    empty_value = {}
    calculation_steps = pending_codes.inject (term_hash.deep_dup) do |agr,code|
      merge_term_to_hash(agr, period_base, code, empty_value)
    end
    calculation_steps
  end
end