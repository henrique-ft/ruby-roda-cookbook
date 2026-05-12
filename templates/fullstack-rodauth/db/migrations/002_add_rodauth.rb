Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :email, null: false, unique: true
      column :status, Integer, default: 1, null: false
    end

    create_table(:account_password_hashes) do
      foreign_key :id, :accounts, primary_key: true

      String :password_hash, text: true, null: false
    end
  end
end
