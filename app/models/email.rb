class Email < ActiveRecord::Base
  belongs_to :user
  paginates_per 50
end
