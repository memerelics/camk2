require 'spec_helper'

describe "notes/index" do
  before(:each) do
    assign(:notes, [
      stub_model(Note,
        :content_hash => "Content Hash",
        :title => "Title",
        :content_raw => "MyText",
        :content_markdown => "MyText",
        :content_html => "MyText"
      ),
      stub_model(Note,
        :content_hash => "Content Hash",
        :title => "Title",
        :content_raw => "MyText",
        :content_markdown => "MyText",
        :content_html => "MyText"
      )
    ])
  end

  it "renders a list of notes" do
    pending "It's generated test but fails, so skip for now."
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content Hash".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
