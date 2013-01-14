# -*- coding: utf-8 -*-
class Note < ActiveRecord::Base
  attr_accessible :guid, :content_hash, :content_html, :content_markdown, :content_raw, :title
  validates_presence_of :guid, :content_hash, :content_raw, :title
  validates_uniqueness_of :guid

  def self.store(notes, evernote)
    @evernote = evernote
    # TODO: @evernoteが正常にsetできないときは誤って全削してしまわない(raiseで止まる)ことをspecで確認

    fullnotes = self.get_fullnotes(notes)
    fullnotes.each do |fullnote|
      self.update_with_fullnote(fullnote) and next if note_exists?(fullnote.guid)
      Note.create(
        guid: fullnote.guid,
        content_hash: Digest::SHA1.hexdigest(fullnote.contentHash),
        title: fullnote.title.encode('UTF-8', 'UTF-8'),
        content_raw: fullnote.content.encode('UTF-8', 'UTF-8')
      )
    end
  end

  private

  # return [Evernote::EDAM::Type::Note]
  def self.get_fullnotes(notes)
    raise EvernoteApi::LostAuth unless @evernote
    notes = [notes] unless notes.is_a? Array
    notes.map{|note|
      @evernote.notestore.getNote(@evernote.token, note.guid, true, true, false, false)
    }
  end

  def self.find_by_guid(guid)
    self.where(guid: guid).first || raise(ActiveRecord::RecordNotFound)
  end

  def self.note_exists?(guid)
    self.where(guid: guid).first ? true : false
  end

  def self.update_with_fullnote(fullnote)
    note = self.find_by_guid(fullnote.guid)

    # 既に存在するnoteのcontent_hashが一致すれば更新はないのでskip
    return if note.content_hash == Digest::SHA1.hexdigest(fullnote.contentHash)

    note.update_attributes({
      content_hash: Digest::SHA1.hexdigest(fullnote.contentHash),
      title: fullnote.title.encode('UTF-8', 'UTF-8'),
      content_raw: fullnote.content.encode('UTF-8', 'UTF-8')
    })
  end

end
