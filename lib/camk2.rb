# -*- coding: utf-8 -*-
module Enumerable
  # mapが2段続くとかっこ悪い. 悔しい.
  # 引数があったらblock書かなければならない. 悔しい.
  # usage:
  # a = [1,2,3,4,5]
  # a.>>(:*, 10).>>(:+, 1).>>(:to_s)
  # => ["11", "21", "31", "41", "51"]
  def >>(method, *args)
    if args.size == 0
      map(&method) # map{|x| method.to_proc.call(x) }
    else
      each_with_object(*args).map(&method)
    end
  end
end
