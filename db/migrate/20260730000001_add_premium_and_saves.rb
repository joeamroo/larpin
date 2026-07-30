class AddPremiumAndSaves < ActiveRecord::Migration[8.1]
  def change
    add_column :personas, :premium, :boolean, null: false, default: false
    add_column :personas, :open_to_larp, :boolean, null: false, default: false

    create_table :saved_posts do |t|
      t.references :persona, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
    add_index :saved_posts, [:persona_id, :post_id], unique: true
  end
end
