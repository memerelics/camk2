# -*- coding: utf-8 -*-
class Note < ActiveRecord::Base
  attr_accessible :guid, :contentHash, :content_html, :content_markdown, :content_raw, :title
end
