require 'rails_helper'

describe User do
  before do
    @request = OmniAuth.config.mock_auth[:google_oauth2]
  end
  it "should saved created from OmniAuth user" do
    expect(User.create_with_omniauth(@request)).to eq(User.first)
  end
  it "should call create OmniAuth" do
    expect(User).to receive(:create_with_omniauth).with(@request)
    User.from_omniauth(@request)
  end
  it "should find in db by OmniAuth uid" do
    expect(User).to receive(:find_by_provider_and_uid).with(@request["provider"], @request["uid"])
    User.from_omniauth(@request)
  end
  it "should expired token" do
  	user = FactoryGirl.create(:user)
    expect(user.token_expired?).to eq(true)
  end
end
