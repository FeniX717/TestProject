require 'rails_helper'

describe User do
  before do
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  @user = FactoryGirl.create(:user)
  subject { @user }
end

  it { should respond_to(:name) }

  it "#name returns a string" do
    expect(@user.name).to match 'Test User'
  end
end
