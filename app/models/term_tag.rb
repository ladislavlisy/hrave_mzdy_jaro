class TermTag
  include Comparable

  attr_reader :period_base, :code, :code_order

  def initialize(period_base, code, code_order)
    @period_base = period_base
    @code = code
    @code_order = code_order
  end

  def set_order(tag_before)
    if @code_order.nil?
      if tag_before.nil?
        @code_order = 1
      else
        @code_order = tag_before.code_order + 1
      end
    end
  end

  def init_code_order(period, code, code_order)
    @period_base = period
    @code = code
    if @code_order.nil?
      @code_order = code_order
    end
  end

  def set_code_order(code_order)
    @code_order = code_order
  end

  def is_equal(tag_other)
    if @period_base == tag_other.period_base
      if @code == tag_other.code
        if !@code_order.nil? && !tag_other.code_order.nil?
          return (@code_order == tag_other.code_order)
        else
          return (@code_order.nil? && tag_other.code_order.nil?)
        end
      end
    end
    return false
  end

  def is_greater(tag_prev, tag_other)
    if @period_base == tag_other.period_base
      if @code == tag_other.code
        if !@code_order.nil? && !tag_other.code_order.nil?
          @code_order > tag_other.code_order
        elsif @code_order.nil? && !tag_other.code_order.nil?
          tag_prev.init_code_order(@period_base, @code, 1)
          if (tag_other.code_order - tag_prev.code_order) > 1
            false
          else
            tag_prev.set_code_order(tag_other.code_order)
            true
          end
        else
          false
        end
      else
        @code > tag_other.code
      end
    else
      @period_base > tag_other.period_base
    end
  end

  def <=>(tag_other)
    if @period_base == tag_other.period_base
      if @code == tag_other.code
        if !@code_order.nil? && !tag_other.code_order.nil?
          @code_order <=> tag_other.code_order
        elsif @code_order.nil? && tag_other.code_order.nil?
          return 0
        elsif !@code_order.nil? && tag_other.code_order.nil?
          return -1
        else
          return 1
        end
      else
        @code <=> tag_other.code
      end
    else
      @period_base <=> tag_other.period_base
    end
  end
end