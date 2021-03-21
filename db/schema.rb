Sequel.migration do
  change do
    create_table(:schema_info) do
      Integer :version, :default=>0
    end
    
    create_table(:schema_migrations) do
      String :filename, :text=>true, :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:schema_seeds) do
      String :filename, :text=>true, :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id, :type=>:Bignum
      String :name, :null=>false
      String :email, :text=>true, :null=>false
      String :password_digest, :null=>false
      DateTime :created_at, :size=>6, :null=>false
      DateTime :updated_at, :size=>6, :null=>false
      
      index [:email], :name=>:users_email_key, :unique=>true
    end
    
    create_table(:user_sessions, :ignore_index_errors=>true) do
      primary_key :id, :type=>:Bignum
      String :uuid, :null=>false
      DateTime :created_at, :size=>6, :null=>false
      DateTime :updated_at, :size=>6, :null=>false
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      
      index [:uuid]
    end
  end
end
