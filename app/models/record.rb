require "resolv"

class Record < ApplicationRecord
  belongs_to :zone
  validates_numericality_of :ttl, :greater_than_or_equal_to => 0
  validates_presence_of :name

  def as_json(*)
    super.merge("type" => type)
  end
end

class A < Record
  validates :ipaddr, :presence => true,
            :format => { :with => Resolv::IPv4::Regex, :message => "Not an valid IPv4 format"}
  alias_attribute :ipaddr, :record_data

  def as_json(*)
    super.merge("ipaddr" => record_data)
  end
end

class CNAME < Record
  validates :domain_name, :presence => true
  alias_attribute :domain_name, :record_data

  def as_json(*)
    super.merge("domain_name" => record_data)
  end
end
