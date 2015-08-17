FactoryGirl.define do
  factory :user do
    email "tony@stark.com"
    provider "google_oauth2"
    uid "12345"
    access_token "'1111111111'"
    created_at { Time.now }
    updated_at { Time.now }
    access_expires_at Time.at(1354920555)
    refresh_token "2222222222"
  end
end
