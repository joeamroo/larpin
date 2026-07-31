class AddMemeFeatures < ActiveRecord::Migration[8.1]
  def change
    add_column :personas, :aura, :integer, null: false, default: 0
    add_column :personas, :verified, :boolean, null: false, default: false
    add_column :personas, :streak, :integer, null: false, default: 0
    add_column :personas, :last_larp_on, :date
    add_column :personas, :pilled, :string
    add_column :personas, :coded, :string

    add_column :posts, :poll_options, :text
    add_column :posts, :mogs_count, :integer, null: false, default: 0

    create_table :poll_votes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.integer :choice, null: false
      t.timestamps
    end
    add_index :poll_votes, [ :post_id, :persona_id ], unique: true

    create_table :mogs do |t|
      t.references :post, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.timestamps
    end
    add_index :mogs, [ :post_id, :persona_id ], unique: true
  end
end
