# -*- coding: utf-8 -*-
class NotesController < ApplicationController
  before_filter :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.where(user_id: current_user.id).all

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

  #   [OK] Evernote Serverにあるものを CaMK2へ
  # [TODO] CaMK2へ同期済だったが Evernote serverで削除されているもの
  def sync
    notebook = current_user.notebook_name || "Blog"
    notes = evernote.notes_in_a_notebook(notebook)
    Note.store(notes, evernote, current_user)
    redirect_to :notes
  end
end
