class AddAuthToPersonas < ActiveRecord::Migration[8.1]
  def change
    add_column :personas, :email, :string
    add_column :personas, :password_digest, :string
    add_index :personas, :email, unique: true, where: "email IS NOT NULL"
  end
end
