class Zone < ApplicationRecord
  validates_uniqueness_of :domain_name
  validates_presence_of :domain_name
end
