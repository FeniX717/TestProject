class CreateEmails < ActiveRecord::Migration
  def change
    create_table(:emails) do |t|
      t.belongs_to :user, index: true
      t.string :subject,              null: false
      t.string :text_part
      t.string :from
      t.string :to
      t.datetime :date
      t.timestamps null: false
    end
  end
end
