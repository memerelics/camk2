# -*- coding: utf-8 -*-
class EvernoteApi
  class InvalidVersion < StandardError; end
  class LostAuth < StandardError; end
  class NotebookNotFound < StandardError; end
  class TagNotFound < StandardError; end

  DEFAULT_LIMIT = 10

  attr_accessor :token, :notestore

  def initialize(token)

    userStoreUrl = "https://#{Camk2::Application.config.evernote_host}/edam/user"
    userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
    userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
    userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)

    versionOK = userStore.checkVersion("Evernote EDAMTest (Ruby)",
                                        Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                                        Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    raise InvalidVersion unless versionOK

    noteStoreUrl = userStore.getNoteStoreUrl(token)

    noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    @notestore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

    @token = token
  end


  ## wrappers of raw Evernote APIs
  ######################################################################
  # TODO: published filter
  def notebooks(options={})
    list_notebooks = self.notestore.listNotebooks(self.token)
    return list_notebooks if options.empty?
    if options[:name] # TODO: allow regexp
      return list_notebooks.select{|nb| nb.name == options[:name] }
    end
    list_notebooks
  end

  def notebook(options={})
    list_notebooks = self.notestore.listNotebooks(self.token)
    return list_notebooks.first if options.empty?
    if options[:name]
      return list_notebooks.find{|nb| nb.name == options[:name] } || raise(NotebookNotFound)
    end
    list_notebooks.first
  end

  def notes(options={})
    offset = options.delete(:offset) || 0
    limit  = options.delete(:limit)  || DEFAULT_LIMIT
    self.notestore.findNotes(self.token, build_filter(options), offset, limit)
  end

  # filter.methods.grep(/=/)
  # :order=, :ascending=, :words=, :notebookGuid=, :tagGuids=, :timeZone=, :inactive=, :emphasized=
  def build_filter(options={})
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    if options[:notebook]
      filter.notebookGuid = options[:notebook].is_a?(Evernote::EDAM::Type::Notebook) ? options[:notebook].guid : options[:notebook]
    end
    if options[:tag]
      filter.tagGuids = [(options[:tag].is_a?(Evernote::EDAM::Type::Tag) ? options[:tag].guid : options[:tag])]
      #elsif options[:tags]
      #filter.tagGuids =
    end
    filter
  end

  def tags(options={})
    list_tags = self.notestore.listTags(self.token)
    return list_tags if options.empty?
    if options[:name]
      return list_tags.select{|t| t.name == options[:name] }
    end
    list_tags
  end

  def tag(options={})
    list_tags = self.notestore.listTags(self.token)
    return list_tags.first if options.empty?
    if options[:name]
      return list_tags.find{|t| t.name == options[:name] } || raise(TagNotFound)
    end
    list_tags.first
  end

  # It'll be deprecated. use Evernote::EDAM::Type::Notebook#notes
  def notes_in_a_notebook(name)
    notebook = notebook_named(name)
    return nil if notebook.nil?
    f = Evernote::EDAM::NoteStore::NoteFilter.new
    f.notebookGuid = notebook.guid
    # findNotesはメタ情報(startIndex, totalNotes, updateCount(?))付きの検索結果を返す.
    notelist = self.notestore.findNotes(self.token, f, 0, DEFAULT_LIMIT)
    return notelist.notes
  end

  def get_tag_names(guids); guids.map{|guid| get_tag_name(guid) }; end
  def get_tag_name(guid)
    self.notestore.getTag(self.token, guid).name
  rescue Evernote::EDAM::Error::EDAMUserException
    raise TagNotFound, $!.message
  end

end


################################################################################
# Extend Evernote::EDAM classes
################################################################################
class Evernote::EDAM::Type::Note
  def tag_names(evernote)
    return [] if self.tagGuids.nil?
    evernote.get_tag_names(self.tagGuids)
  end
end

class EvernoteApi::Notebook < Evernote::EDAM::Type::Notebook
  # TODO: store token to call findNotes inside it. Need to wrap the class.
  # def notes(options={})
  # end
end
