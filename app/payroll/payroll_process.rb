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

  def new_term_with_order(term_hash, period, term_refer, code_order, amount)
    term_key = TagRefer.new(period, term_refer.code, code_order)
    term_tag = tags.tag_for(term_refer.name)
    {term_key => concepts.concept_for(term_refer.code, term_tag.concept.name, amount)}
  end

  def ins_term(period, term_refer, code_order, amount)
    term_to_insert = new_term_with_order(@terms, period, term_refer, code_order, amount)
    @terms.merge!(term_to_insert)
    term_to_insert.keys[0]
  end

  def new_term(term_hash, period, term_refer, amount)
    new_code_order = get_new_tag_order_from(term_hash, period, term_refer.code)

    new_term_with_order(term_hash, period, term_refer, new_code_order,amount)
  end

  def merge_term(term_hash, period, term_refer, amount)
    merge_code_order = get_tag_order_from(term_hash, period, term_refer.code)

    new_term_with_order(term_hash, period, term_refer, merge_code_order, amount)
  end

  def add_term(term_refer, amount)
    period = PayrollPeriod::NOW
    term_to_add = new_term(@terms, period, term_refer, amount)
    @terms.merge!(term_to_add)
    term_to_add.keys[0]
  end

  def get_new_tag_order(period, code)
    get_new_tag_order_from(@terms, period, code)
  end

  def get_new_tag_order_from(term_hash, period, code)
    get_new_tag_order_in_array(term_hash.keys, period, code)
  end

  def get_new_tag_order_in_array(keys_array, period, code)
    selected_tags = select_tags_for_code(keys_array, period, code)
    mapped_orders = map_tags_to_code_orders(selected_tags)
    get_new_order_in_sorted_orders(mapped_orders.sort)
  end

  def get_tag_order_from(term_hash, period, code)
    get_tag_order_in_array(term_hash.keys, period, code)
  end

  def get_tag_order_in_array(keys_array, period, code)
    selected_tags = select_tags_for_code(keys_array, period, code)
    mapped_orders = map_tags_to_code_orders(selected_tags)
    get_first_order_in_sorted_orders(mapped_orders.sort)
  end

  def map_tags_to_code_orders(keys_array)
    keys_array.map { |x| x.code_order }
  end

  def select_tags_for_code(keys_array, period, code)
    keys_array.select { |x| x.period_base==period && x.code==code }
  end

  def get_new_order_in_sorted_orders(orders_sorted)
    last_code_order = orders_sorted.inject(0) { |agr, x| x-agr > 1 ? agr : x }
    (last_code_order + 1)
  end

  def get_first_order_in_sorted_orders(orders_sorted)
    first_code_order = 1
    first_code_order = orders_sorted.first unless orders_sorted.first.nil?
  end

  def get_term(pay_tag)
    @terms.select { |key,_| key==pay_tag }
  end

  def get_result(pay_tag)
    @results.select { |key,_| key==pay_tag }
  end

  def evaluate(pay_tag)
    period = PayrollPeriod::NOW

    pending_uniq = collect_pending_codes_for(@terms)

    calculation_steps = create_calculation_steps(@terms, period, pending_uniq)

    calculation_sort = calculation_steps.sort {|a,b| a<=>b}

    @results = Hash[@terms.map { |x,y| [x, y.evaluate] }]
    get_result(pay_tag)
  end

  def collect_pending_codes_for(term_hash)
    pending = term_hash.inject ([]) { |agr, e| agr.concat(e.last.pending_codes()) }
    pending_uniq = pending.uniq
  end

  def create_calculation_steps(term_hash, period, pending_codes)
    empty_value = {}
    calculation_steps = pending_codes.inject (term_hash.deep_dup) do |agr,code|
      agr.merge!(merge_term(agr, period, code, empty_value)) do |tag, term_value, _|
        term_value
      end
    end

  end

  def run_verify_pending
    terms_verify = @terms

    new_pending_tags = Hash.new
    terms_verify.each do |tag, concept|
      pending_codes = concept.pending_codes
      pending_codes.each do |pending_code|
        pending_tag = TagRefer.new(PayrollPeriod::NOW, pending_code.code, 1)
    #    if terms_verify.has_key?(pending_tag)
    #      new_pending_tags << pending_codes.assoc(pending_tag)
    #    else
    #      pending_term = tags.tag_for(term_tag.name)
    #      pending_values = {hours_weekly: 0}
    #      pending_concept = concepts.concept_for(term_tag.concept.name)
    #      new_pending_tags << {pending_tag: pending_concept}
    #    end
      end
    end
  end
end