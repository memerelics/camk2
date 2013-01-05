require 'spec_helper'

describe "notes/show" do
  before(:each) do
    @note = assign(:note, stub_model(Note,
      :contentHash => "Content Hash",
      :title => "Title",
      :content_raw => "MyText",
      :content_markdown => "MyText",
      :content_html => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content Hash/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
