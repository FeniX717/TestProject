class EmailsController < ApplicationController
  def show
  	@email = Email.find(params[:id])
  end

  def update 
  	user = User.find(params[:id])
  	user.get_emails
  	redirect_to root_url
  end
end
