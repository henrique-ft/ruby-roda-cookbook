Sequel.migration do
  change do
    enable_extension :citext

    create_table(:accounts) do
      primary_key :id
      citext :email, null: false, unique: true
      column :status, Integer, default: 1, null: false
    end

    create_table(:account_password_hashes) do
      primary_key :id
      foreign_key :account_id, :accounts, null: false, unique: true
      String :password_hash, text: true, null: false
    end
  end
end
