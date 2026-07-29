class AddFunFeatures < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :hyped, :boolean, null: false, default: false

    create_table :certifications do |t|
      t.references :persona, null: false, foreign_key: true
      t.string :course, null: false
      t.string :hours, null: false
      t.timestamps
    end
    add_index :certifications, [:persona_id, :course], unique: true
  end
end
