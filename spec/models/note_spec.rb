# -*- coding: utf-8 -*-
require 'spec_helper'

describe Note do
  def dummy_guid
    [8,4,4,4,12].map{|num| Faker::Lorem.characters(num) }.join("-")
  end
  before do
    @efullnote = mock(Evernote::EDAM::Type::Note)
    @efullnote.stub!(:guid => dummy_guid,
                     :title => "タイトル".force_encoding('ASCII-8BIT'),
                     :contentHash => "S\x11eAL9\xB4\xAB\xFF\xC1\x8E6]{\xEA*",
                     :content => "コンテンツ".force_encoding('ASCII-8BIT'),
                     :tagGuids => [dummy_guid, dummy_guid] )

  end


  describe 'validations' do
    it "has a valid factory" do
      FactoryGirl.create(:note).should be_valid
    end
    it "is invalid without guid" do
      FactoryGirl.build(:note, guid: nil).should_not be_valid
    end
    it "is invalid without content_hash" do
      FactoryGirl.build(:note, content_hash: nil).should_not be_valid
    end
    it "is invalid without content_raw" do
      FactoryGirl.build(:note, content_raw: nil).should_not be_valid
    end
    it "is invalid without title" do
      FactoryGirl.build(:note, title: nil).should_not be_valid
    end
  end

  describe ".store" do
    before do
      Note.stub!(:get_fullnotes).and_return([@efullnote])
      user = mock(User)
      user.stub!(id: 1)
      evernote = mock(EvernoteApi)
      evernote.stub!(get_tag_names: ["tagA","tagB","tagC"])
      Note.store("dummynotes", evernote, user)
    end
    it { @efullnote.title.encoding.name.should eq "ASCII-8BIT" }
    it { @efullnote.content.encoding.name.should eq "ASCII-8BIT" }

    subject { Note.first }
    its(:guid) { should eq @efullnote.guid }
    its(:content_hash) { should eq Digest::SHA1.hexdigest(@efullnote.contentHash) }
    its("title.encoding.name") { should eq "UTF-8" }
    its("content_raw.encoding.name") { should eq "UTF-8" }
  end

  describe ".update_with_fullnote" do
    before do
      Note.stub!(extract_tagstrings: 'same')
      note = FactoryGirl.create(:note, guid: "abcd", content_hash: Digest::SHA1.hexdigest("xyz"))
      note.stub!(stags: 'same')
      @fullnote = mock(Evernote::EDAM::Type::Note)
    end
    context "there's no guid-related note in DB" do
      it "raise" do 
        Note.destroy_all
        expect{Note.update_with_fullnote(@efullnote)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    context "has same content_hash" do
      before do
        @fullnote.stub!(guid: "abcd", contentHash: "xyz", title: "hoge", content: "hoge", tagGuids: [dummy_guid, dummy_guid])
      end
      it "should not update" do
        expect {
          Note.update_with_fullnote(@fullnote)
        }.to_not change{ Note.first.content_hash }
      end
    end

    context "has different content_hash" do
      before do
        @fullnote.stub!(guid: "abcd", contentHash: "xyz2", title: "hoge", content: "hoge", tagGuids: [dummy_guid, dummy_guid])
      end
      it "should update" do
        expect {
          Note.update_with_fullnote(@fullnote)
        }.to change{ Note.first.content_hash }.
          from(Digest::SHA1.hexdigest("xyz")).to(Digest::SHA1.hexdigest("xyz2"))
      end
    end

  end
end
