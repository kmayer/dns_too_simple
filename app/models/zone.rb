class Zone < ApplicationRecord
  validates_uniqueness_of :domain_name
  validates_presence_of :domain_name

  has_many :records, dependent: :destroy
end
