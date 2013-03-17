# -*- coding: utf-8 -*-
module Adapters
  class Base < ActiveRecord::Base
    self.abstract_class = true
    self.table_name = 'adapters'
    self.inheritance_column = '_type' # default 'type'
    # store_full_sti_class default is true, which comes to try to find plain "Livedoor" class
    self.store_full_sti_class = false

    belongs_to :user

    # for mass assignment
    attr_accessible :user_id, :_type, :created_at, :updated_at

    before_save :_type_setter

    private
    def _type_setter
      raise "you should override it"
    end
  end
end
