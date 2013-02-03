#require "payroll_period.rb"
#require "pay_tag_gateway.rb"

class PayrollProcess
  attr_reader :period
  attr_reader :tags
  attr_reader :concepts

  def initialize(period, tag_gate, concept_gate)
    @period = period
    @terms = Hash.new
    @tags = tag_gate
    @concepts = concept_gate
  end

  def ins_term(period, term_refer, code_order, amount)
    term_key = TagRefer.new(period, term_refer.code, code_order)
    term_tag = tags.tag_for(term_refer.name)
    @terms[term_key] = concepts.concept_for(term_tag.concept.name, amount)
    term_key
  end

  def add_term(term_refer, amount)
    period = PayrollPeriod::NOW

    new_code_order = get_new_tag_order(period, term_refer.code)

    ins_term(period, term_refer, new_code_order, amount)
  end

  def get_new_tag_order(period, code)
    get_new_tag_order_in_array(@terms.keys, period, code)
  end

  def get_new_tag_order_in_array(keys_array, period, code)
    selected_tags = select_tags_for_code(keys_array, period, code)
    mapped_orders = map_tags_to_code_orders(selected_tags)
    get_new_order_in_sorted_orders(mapped_orders.sort)
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

  def get_term(pay_tag)
    @terms.select { |key,_| key==pay_tag }
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