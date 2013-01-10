require 'spec_helper'

describe "notes/edit" do
  before(:each) do
    @note = assign(:note, stub_model(Note,
      :content_hash => "MyString",
      :title => "MyString",
      :content_raw => "MyText",
      :content_markdown => "MyText",
      :content_html => "MyText"
    ))
  end

  it "renders the edit note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path(@note), :method => "post" do
      assert_select "input#note_content_hash", :name => "note[content_hash]"
      assert_select "input#note_title", :name => "note[title]"
      assert_select "textarea#note_content_raw", :name => "note[content_raw]"
      assert_select "textarea#note_content_markdown", :name => "note[content_markdown]"
      assert_select "textarea#note_content_html", :name => "note[content_html]"
    end
  end
end
