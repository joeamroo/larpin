class CreateLarpinSchema < ActiveRecord::Migration[8.1]
  def change
    create_table :personas do |t|
      t.string :name, null: false
      t.string :headline, null: false
      t.text :bio
      t.integer :hue, null: false, default: 210
      t.string :device_token
      t.boolean :is_bot, null: false, default: false
      t.date :larping_since, null: false
      t.integer :base_clout, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.timestamps
    end
    add_index :personas, :device_token, unique: true

    create_table :posts do |t|
      t.references :persona, null: false, foreign_key: true
      t.text :body, null: false, default: ""
      t.string :kind, null: false, default: "post"
      t.integer :impressions_seed, null: false, default: 0
      t.integer :reactions_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.timestamps
    end
    add_index :posts, :created_at
    add_index :posts, :kind

    create_table :reactions do |t|
      t.references :post, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.string :kind, null: false
      t.timestamps
    end
    add_index :reactions, [ :post_id, :persona_id ], unique: true

    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :likes_count, null: false, default: 0
      t.timestamps
    end

    create_table :comment_likes do |t|
      t.references :comment, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.timestamps
    end
    add_index :comment_likes, [ :comment_id, :persona_id ], unique: true

    create_table :connections do |t|
      t.references :requester, null: false, foreign_key: { to_table: :personas }
      t.references :receiver, null: false, foreign_key: { to_table: :personas }
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
    add_index :connections, [ :requester_id, :receiver_id ], unique: true

    create_table :endorsements do |t|
      t.references :persona, null: false, foreign_key: true
      t.references :endorser, null: false, foreign_key: { to_table: :personas }
      t.string :skill, null: false
      t.timestamps
    end
    add_index :endorsements, [ :persona_id, :endorser_id, :skill ], unique: true, name: "idx_endorsements_unique"

    create_table :notifications do |t|
      t.references :persona, null: false, foreign_key: true
      t.references :actor, foreign_key: { to_table: :personas }
      t.string :body, null: false
      t.string :url
      t.boolean :read, null: false, default: false
      t.timestamps
    end
    add_index :notifications, [ :persona_id, :read ]

    create_table :jobs do |t|
      t.references :persona, null: false, foreign_key: true
      t.string :title, null: false
      t.string :company, null: false
      t.string :location
      t.string :comp
      t.text :description
      t.integer :applications_count, null: false, default: 0
      t.timestamps
    end

    create_table :job_applications do |t|
      t.references :job, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.timestamps
    end
    add_index :job_applications, [ :job_id, :persona_id ], unique: true

    create_table :conversations do |t|
      t.references :a, null: false, foreign_key: { to_table: :personas }
      t.references :b, null: false, foreign_key: { to_table: :personas }
      t.datetime :last_message_at
      t.timestamps
    end
    add_index :conversations, [ :a_id, :b_id ], unique: true

    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :personas }
      t.text :body, null: false
      t.boolean :read, null: false, default: false
      t.timestamps
    end
    add_index :messages, [ :conversation_id, :created_at ]
  end
end
