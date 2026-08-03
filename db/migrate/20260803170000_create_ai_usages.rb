class CreateAiUsages < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_usages do |t|
      t.string :feature, null: false
      t.string :model, null: false
      t.integer :input_tokens, null: false, default: 0
      t.integer :output_tokens, null: false, default: 0
      t.integer :cost_micros, null: false, default: 0
      t.integer :ms, null: false, default: 0
      t.datetime :created_at, null: false
    end

    add_index :ai_usages, :created_at
  end
end
