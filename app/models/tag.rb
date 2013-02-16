# -*- coding: utf-8 -*-
class Tag < ActiveRecord::Base
  attr_accessible :name, :note_id
  validates_uniqueness_of :name

  belongs_to :note

  scope :named, lambda {|name| where(name: name) }

  def self.gather(names)
    names.map{|name| find_or_create_by_name(name) }
  end
  def self.find_or_create_by_name(name)
    where(name: name).first || create(name: name)
  end
end
