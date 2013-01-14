# -*- coding: utf-8 -*-
require 'spec_helper'

describe Note do
  before do
    @efullnote = mock(Evernote::EDAM::Type::Note)
    @efullnote.stub!(:guid =>  [8,4,4,4,12].map{|num| Faker::Lorem.characters(num) }.join("-"),
                     :title => "タイトル".force_encoding('ASCII-8BIT'),
                     :contentHash => "S\x11eAL9\xB4\xAB\xFF\xC1\x8E6]{\xEA*",
                     :content => "コンテンツ".force_encoding('ASCII-8BIT') )

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
      Note.store("dummynotes", "dummyevernote")
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
    describe "there's no guid-related note in DB" do
      before { Note.destroy_all }
      it {expect{Note.update_with_fullnote(@efullnote)}.to \
        raise_error(ActiveRecord::RecordNotFound) }
    end
    describe "has same content_hash" do
      before do
        FactoryGirl.create(:note, guid: "abcd", content_hash: Digest::SHA1.hexdigest("xyz"))
        @fullnote = mock(Evernote::EDAM::Type::Note)
        @fullnote.stub!(guid: "abcd", contentHash: "xyz", title: "hoge", content: "hoge")
      end
      it "should not update" do
        expect {
          Note.update_with_fullnote(@fullnote)
        }.to_not change{ Note.first.content_hash }
      end
    end
    describe "has different content_hash" do
      before do
        FactoryGirl.create(:note, guid: "abcd", content_hash: Digest::SHA1.hexdigest("xyz"))
        @fullnote = mock(Evernote::EDAM::Type::Note)
        @fullnote.stub!(guid: "abcd", contentHash: "xyz2", title: "hoge", content: "hoge")
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
