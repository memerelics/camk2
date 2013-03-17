# -*- coding: utf-8 -*-
module Adapters
  class HatenaBlog < Base

    private
    def _type_setter
      self[:_type] = 'HatenaBlog'
    end
  end
end
