# -*- coding: utf-8 -*-
class Note < ActiveRecord::Base
  attr_accessible :guid, :content_hash, :content_html, :content_markdown, :content_raw, :title
  validates_presence_of :guid, :content_hash, :content_raw, :title

  def self.store(notes, evernote)
    @evernote = evernote # TODO: @evernoteの利用, 正統じゃない気が. よい方法ないか

    fullnotes = self.get_fullnotes(notes)
    # @evernoteが正常にsetできないときは誤って全削してしまわない(raiseで止まる)ことをspecで確認

    Note.destroy_all # TODO: 現状全削全insertしているが, guidで引いて存在したら更新するように.

    fullnotes.each do |fullnote|
      # TODO: 既に存在するnoteのcontent_hashが一致すれば更新はないのでskipさせる
      # TODO: specでencoding挿入テスト => Encoding::UndefinedConversionError: "\xE9" from ASCII-8BIT to UTF-8: INSERT INTO
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
end
