require 'rails_helper'

describe EmailsController do
  before do
    @email=FactoryGirl.create(:email)
    @user = FactoryGirl.create(:user)
    User.any_instance.stub(:get_emails).and_return([])
  end
  describe "actions in EmailsController" do
    it "renders root template with updated emails" do
      put :update ,id: @user.id
      expect(response).to redirect_to root_path
    end
  end
end