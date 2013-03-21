class PayrollPeriod < ActiveRecord::Base
  NOW = 0

  self.primary_key = :code
  validates :code, :presence => true
  validates :name, :presence => true,
            :length     => { :maximum => 30 }
  attr_accessible :code, :name

  def year
    code/100
  end

  def month
    code%100
  end

  def description
    calendar_day = Date.new(year, month, 1)
    calendar_day.to_formatted_s(:month_name_and_year)
  end
end
