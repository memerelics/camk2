# -*- coding: utf-8 -*-
module Adapters
  class Qiita < Base

    private
    def _type_setter
      self[:_type] = 'Qiita'
    end
  end
end
