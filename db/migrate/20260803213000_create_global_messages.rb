class CreateGlobalMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :global_messages do |t|
      t.references :persona, null: false, foreign_key: true
      t.text :body, null: false
      t.datetime :created_at, null: false
    end

    add_index :global_messages, :created_at
  end
end
