require 'rails_helper'

describe SessionsController do
  before do
    @user = FactoryGirl.create(:user)
    @user.refresh_token=nil
    @user.stub(:get_emails)
    User.stub(:from_omniauth).and_return(@user)
  end
  describe "actions in SessionsController" do
    it "renders root template with Signed out!" do
      get :destroy
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq("Signed out!")
    end
    it "renders root template with alert" do
      get :failure
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq("Authentication failed, please try again.")
    end
  end
end