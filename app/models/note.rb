class Note < ActiveRecord::Base
  attr_accessible :contentHash, :content_html, :content_markdown, :content_raw, :title
end
