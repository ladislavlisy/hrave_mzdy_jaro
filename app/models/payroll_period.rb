class PayrollPeriod < ActiveRecord::Base
  self.primary_key = :code
  validates :code, :presence => true
  validates :name, :presence => true,
            :length     => { :maximum => 30 }
  attr_accessible :code, :name
end
