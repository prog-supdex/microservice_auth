Sequel.migration do
  change do
    create_table(:user_sessions) do
      primary_key :id, type: :Bignum

      column :uuid, :uuid, null: false, index: true
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false

      foreign_key :user_id, :users, null: false
    end
  end
end
