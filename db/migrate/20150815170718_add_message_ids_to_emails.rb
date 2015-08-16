class AddMessageIdsToEmails < ActiveRecord::Migration
  def change
  	add_column :emails, :message_id, :string
  end
end
