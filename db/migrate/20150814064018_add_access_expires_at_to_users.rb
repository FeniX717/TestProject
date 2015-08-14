class AddAccessExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_expires_at, :datetime
  end
end
