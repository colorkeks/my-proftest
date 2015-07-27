class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
        t.attachment :file_content
        t.integer :user_id
        t.timestamps
    end
  end
end
