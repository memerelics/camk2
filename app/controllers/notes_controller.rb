# -*- coding: utf-8 -*-
class NotesController < ApplicationController
  before_filter :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.where(user_id: current_user.id)

    # filter notes
    @notes = @notes.joins(:tags).merge(Tag.named(white_params["tag"])) if white_params["tag"]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  def raw2markdown
    note = Note.find(params[:id])
    note.update_attribute(:content_markdown, note.raw2markdown)
    redirect_to note_path
  end

  def markdown2html
    note = Note.find(params[:id])
    note.update_attribute(:content_html, note.markdown2html)
    redirect_to note_path
  end

  #   [OK] Evernote Serverにあるものを CaMK2へ
  # [TODO] CaMK2へ同期済だったが Evernote serverで削除されているもの
  def sync
    notebook = current_user.notebook_name || "Blog"
    notes = evernote.notes_in_a_notebook(notebook)
    Note.store(notes, evernote, current_user)
    flash[:success] = I18n.t 'notes.sync.success', name: notebook
  rescue EvernoteApi::NotebookNotFound
    flash[:error] = I18n.t 'notes.sync.notfound', name: notebook
  ensure
    redirect_to :notes
  end

  private
  def white_params
    params.select{|k,v| Note::SEARCHABLES.include?(k) }
  end
end
