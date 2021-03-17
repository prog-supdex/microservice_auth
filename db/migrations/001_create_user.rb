Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, type: :Bignum

      column :name, 'character varying', null: false
      column :email, 'text', null: false, unique: true
      column :password_digest, 'character varying', null: false
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false
    end
  end
end
