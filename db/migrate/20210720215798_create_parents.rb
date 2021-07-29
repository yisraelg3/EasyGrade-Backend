class CreateParents < ActiveRecord::Migration[6.1]
  def change
    create_table :parents do |t|
      t.belongs_to :admin, null: false, foreign_key: true
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
