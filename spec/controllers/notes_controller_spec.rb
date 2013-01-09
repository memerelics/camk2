require 'spec_helper'

describe NotesController do

  # This should return the minimal set of attributes required to create a valid {{{
  # Note. As you add validations to Note, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "contentHash" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NotesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all notes as @notes" do
      note = Note.create! valid_attributes
      get :index, {}, valid_session
      assigns(:notes).should eq([note])
    end
  end

  describe "GET show" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :show, {:id => note.to_param}, valid_session
      assigns(:note).should eq(note)
    end
  end

  describe "GET new" do
    it "assigns a new note as @note" do
      get :new, {}, valid_session
      assigns(:note).should be_a_new(Note)
    end
  end

  describe "GET edit" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :edit, {:id => note.to_param}, valid_session
      assigns(:note).should eq(note)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Note" do
        expect {
          post :create, {:note => valid_attributes}, valid_session
        }.to change(Note, :count).by(1)
      end

      it "assigns a newly created note as @note" do
        post :create, {:note => valid_attributes}, valid_session
        assigns(:note).should be_a(Note)
        assigns(:note).should be_persisted
      end

      it "redirects to the created note" do
        post :create, {:note => valid_attributes}, valid_session
        response.should redirect_to(Note.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved note as @note" do
        # Trigger the behavior that occurs when invalid params are submitted
        Note.any_instance.stub(:save).and_return(false)
        post :create, {:note => { "contentHash" => "invalid value" }}, valid_session
        assigns(:note).should be_a_new(Note)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Note.any_instance.stub(:save).and_return(false)
        post :create, {:note => { "contentHash" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested note" do
        note = Note.create! valid_attributes
        # Assuming there are no other notes in the database, this
        # specifies that the Note created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Note.any_instance.should_receive(:update_attributes).with({ "contentHash" => "MyString" })
        put :update, {:id => note.to_param, :note => { "contentHash" => "MyString" }}, valid_session
      end

      it "assigns the requested note as @note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => valid_attributes}, valid_session
        assigns(:note).should eq(note)
      end

      it "redirects to the note" do
        note = Note.create! valid_attributes
        put :update, {:id => note.to_param, :note => valid_attributes}, valid_session
        response.should redirect_to(note)
      end
    end

    describe "with invalid params" do
      it "assigns the note as @note" do
        note = Note.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Note.any_instance.stub(:save).and_return(false)
        put :update, {:id => note.to_param, :note => { "contentHash" => "invalid value" }}, valid_session
        assigns(:note).should eq(note)
      end

      it "re-renders the 'edit' template" do
        note = Note.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Note.any_instance.stub(:save).and_return(false)
        put :update, {:id => note.to_param, :note => { "contentHash" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested note" do
      note = Note.create! valid_attributes
      expect {
        delete :destroy, {:id => note.to_param}, valid_session
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create! valid_attributes
      delete :destroy, {:id => note.to_param}, valid_session
      response.should redirect_to(notes_url)
    end
  end # }}}

end
