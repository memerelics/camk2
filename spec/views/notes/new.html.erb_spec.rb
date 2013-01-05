require 'spec_helper'

describe "notes/new" do
  before(:each) do
    assign(:note, stub_model(Note,
      :contentHash => "MyString",
      :title => "MyString",
      :content_raw => "MyText",
      :content_markdown => "MyText",
      :content_html => "MyText"
    ).as_new_record)
  end

  it "renders new note form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notes_path, :method => "post" do
      assert_select "input#note_contentHash", :name => "note[contentHash]"
      assert_select "input#note_title", :name => "note[title]"
      assert_select "textarea#note_content_raw", :name => "note[content_raw]"
      assert_select "textarea#note_content_markdown", :name => "note[content_markdown]"
      assert_select "textarea#note_content_html", :name => "note[content_html]"
    end
  end
end
