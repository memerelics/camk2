# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :note do
    guid { [8,4,4,4,12].map{|num| Faker::Lorem.characters(num) }.join("-") }
    title { Faker::Lorem.sentence }
    content_hash { Faker::Lorem.characters(40) }
    content_raw { Faker::Lorem.paragraphs.join("\n") }
    user
  end

  factory :user do
    uid { "12345" }
    token { "xxxxxxxxx" }
    token_secret { "........." }
  end

  # ModelじゃないものはFactory生成できない.
  # EverNoteの返すefullnoteなど
end
