class CreateTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :teachers do |t|
      t.belongs_to :admin, null: false, foreign_key: true
      t.string :username
      t.string :password_digest
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :picture_url

      t.timestamps
    end
  end
end
