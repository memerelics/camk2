require 'spec_helper'

describe NotesController do
  login_user

  # This should return the minimal set of attributes required to create a valid
  # Note. As you add validations to Note, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "guid" => "xxxxx",
      "title" => "xxxxx",
      "content_raw" => "xxxxx",
      "content_hash" => "MyString",
      "user_id" => "1"}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NotesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  ### {{{
  describe "GET index" do
    it "assigns all notes as @notes" do
      note = Note.create! valid_attributes
      # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
      get :index, {} #, valid_session
      assigns(:notes).should eq([note])
    end
  end

  describe "GET show" do
    it "assigns the requested note as @note" do
      note = Note.create! valid_attributes
      get :show, {:id => note.to_param} #, valid_session
      assigns(:note).should eq(note)
    end
  end

end
