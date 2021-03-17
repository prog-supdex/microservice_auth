namespace :db do
  require 'sequel/core'
  Sequel.extension :migration

  DB_MIGRATION_PATH = File.expand_path('../../db/migrations', __dir__).freeze

  task create: :settings do
    DB.execute("CREATE DATABASE #{Settings.db.database}")
  end

  task drop: :settings do
    DB.execute("DROP DATABASE IF EXISTS #{Settings.db.database}")
  end

  desc 'Prints current schema version'
  task version: :settings do
    db = Sequel.connect(Settings.db.to_hash)

    version =
      if db.tables.include?(:schema_info)
        db[:schema_info].first[:version]
      end || 0

    puts "Schema Version: #{version}"
  end

  desc 'Perform migration up to latest migration available'
  task migrate: :settings do
    db = Sequel.connect(Settings.db.to_hash)

    Sequel::Migrator.run(db, DB_MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end

  desc 'Perform rollback to specified target or full rollback as default'
  task :rollback, [:target] => :settings do |_, args|
    db = Sequel.connect(Settings.db.to_hash)

    version =
      if db.tables.include?(:schema_info)
        db[:schema_info].first[:version]
      end || 0

    target = version.zero? ? 0 : (version - 1)
    args.with_defaults(target: target)

    Sequel::Migrator.run(db, DB_MIGRATION_PATH, target: args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc 'Perform migration reset (full rollback and migration)'
  task reset: :settings do
    db = Sequel.connect(Settings.db.to_hash)

    Sequel::Migrator.run(db, DB_MIGRATION_PATH, target: 0)
    Sequel::Migrator.run(db, DB_MIGRATION_PATH)
    Rake::Task['db:version'].execute
  end
end
