# -*- coding: utf-8 -*-
class Note < ActiveRecord::Base
  attr_accessible :guid, :user_id, :content_hash, :content_html, :content_markdown, :content_raw, :title, :stags
  validates_presence_of :guid, :user_id, :content_hash, :content_raw, :title
  validates_uniqueness_of :guid

  belongs_to :user

  #        Class methods
  ###################################

  def self.store(notes, evernote, user)
    fullnotes = self.get_fullnotes(notes, evernote)
    fullnotes.each do |fullnote|
      self.update_with_fullnote(fullnote) and next if note_exists?(fullnote.guid)
      Note.create(
        guid: fullnote.guid,
        user_id: user.id,
        stags: evernote.extract_tagstrings(fullnote),
        content_hash: Digest::SHA1.hexdigest(fullnote.contentHash),
        title: fullnote.title.encode('UTF-8', 'UTF-8'),
        content_raw: fullnote.content.encode('UTF-8', 'UTF-8')
      )
    end
  end


  #        instance methods
  ###################################

  def raw2markdown!
    self.update_attributes(content_markdown: raw2markdown)
  end

  def raw2markdown
    raw = content_raw
    doc = Nokogiri::XML(raw)
    body_div = (doc/"en-note"/"div").first
    body_div.children.map{|e| e.name == "br" ? "\n" : e.text }.join
  end

  def markdown2html!
    self.update_attributes(content_html: markdown2html)
  end

  def markdown2html
    return nil if content_markdown.blank?
    renderer = MyRedcarpet.new(
      hard_wrap:          true, # newline to normal br
      fenced_code_blocks: true, # ```ruby (PHP-markdown style) enabled.
      no_intra_emphasis:  true, # hoge_fuga_piyo is not emphasis, but one word.
      autolink:           true, # autolink
      with_toc_data:      true, # add anchor to h1 etc
      strikethrough:      true  # ~~hoge~~ => <s>hoge</s>
    )
    markdown = Redcarpet::Markdown.new(renderer,
                                      fenced_code_blocks: true)
    markdown.render(content_markdown)
  end

  def tags
    return nil if stags.nil?
    stags.split(",")
  end


  private

  #        Class methods
  ###################################

  # return [Evernote::EDAM::Type::Note]
  def self.get_fullnotes(notes)
    notes = [notes] unless notes.is_a? Array
    notes.map{|note|
      evernote.notestore.getNote(evernote.token, note.guid, true, true, false, false)
    }
  end

  def self.find_by_guid(guid)
    self.where(guid: guid).first || raise(ActiveRecord::RecordNotFound)
  end

  def self.note_exists?(guid)
    self.where(guid: guid).first ? true : false
  end

  def self.update_with_fullnote(fullnote, evernote)
    note = self.find_by_guid(fullnote.guid)

    # tagの更新はcontent_hashを変更しないため個別にチェックする必要がある
    if (stags = evernote.extract_tagstrings(fullnote)) != note.stags
      note.update_attributes(stags: stags)
    end
    # 既に存在するnoteのcontent_hashが一致すれば更新はないのでskip
    return if note.content_hash == Digest::SHA1.hexdigest(fullnote.contentHash)

    note.update_attributes({
      content_hash: Digest::SHA1.hexdigest(fullnote.contentHash),
      title: fullnote.title.encode('UTF-8', 'UTF-8'),
      content_raw: fullnote.content.encode('UTF-8', 'UTF-8')
    })
  end
end
