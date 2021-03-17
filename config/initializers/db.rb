Sequel.connect(Settings.db.to_hash)

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true

Sequel.default_timezone = :utc
