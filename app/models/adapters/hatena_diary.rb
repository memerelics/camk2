# -*- coding: utf-8 -*-
module Adapters
  class HatenaDiary < Base

    private
    def _type_setter
      self[:_type] = 'HatenaDiary'
    end
  end
end
