# -*- coding: utf-8 -*-
class EvernoteApi
  class LostAuth < StandardError; end
  class NotebookNotFound < StandardError; end
  class TagNotFound < StandardError; end

  attr_accessor :token, :notestore

  def initialize(user, mode=:sandbox)

    evernoteHost = case mode
                   when :sandbox then "sandbox.evernote.com"
                   when :production then "www.evernote.com"
                   end

    userStoreUrl = "https://#{evernoteHost}/edam/user"
    userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
    userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
    userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)


    versionOK = userStore.checkVersion("Evernote EDAMTest (Ruby)",
                                        Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                                        Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    exit(1) if (!versionOK)

    @token = user.token
    noteStoreUrl = userStore.getNoteStoreUrl(token)

    noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    @notestore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
  end


  ######################################################################
  ## wrappers of raw Evernote APIs
  ######################################################################
  def notebooks
    self.notestore.listNotebooks(self.token)
  end

  def notebook_named(name)
    notebooks.select{|nb| nb.name == name }.first || raise(NotebookNotFound)
  end

  def notes_in_a_notebook(name)
    notebook = notebook_named(name)
    return nil if notebook.nil?
    f = Evernote::EDAM::NoteStore::NoteFilter.new
    f.notebookGuid = notebook.guid
    # findNotesはメタ情報(startIndex, totalNotes, updateCount(?))付きの検索結果を返す.
    notelist = self.notestore.findNotes(self.token, f, 0, 10) # TODO: tweak offset and limit
    return notelist.notes
  end

  def get_tag_names(guids); guids.map{|guid| get_tag_name(guid) }; end
  def get_tag_name(guid)
    self.notestore.getTag(self.token, guid).name
  rescue Evernote::EDAM::Error::EDAMUserException
    raise TagNotFound, $!.message
  end

end
