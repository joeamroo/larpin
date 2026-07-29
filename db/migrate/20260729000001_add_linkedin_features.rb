class AddLinkedinFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.references :persona, null: false, foreign_key: true
      t.string :headline, null: false
      t.text :body
      t.integer :readers_seed, null: false, default: 0
      t.timestamps
    end
    add_index :articles, :created_at

    create_table :experiences do |t|
      t.references :persona, null: false, foreign_key: true
      t.string :title, null: false
      t.string :company, null: false
      t.integer :start_year, null: false
      t.integer :end_year
      t.text :description
      t.timestamps
    end

    create_table :profile_skills do |t|
      t.references :persona, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
    add_index :profile_skills, [:persona_id, :name], unique: true
  end
end
