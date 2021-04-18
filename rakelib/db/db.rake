namespace :db do
  if ENV['RACK_ENV'] == 'development'
    require 'dotenv/load'
  end

  require 'sequel/core'
  Sequel.extension :migration

  require_relative '../../app/services/root_service'
  require 'config'
  require_relative '../../config/initializers/config'

  DB = Sequel.connect(Settings.db.url || Settings.db.to_hash)

  task :create do
    DB.execute("CREATE DATABASE #{Settings.db.database}")
  end

  task :drop do
    DB.execute("DROP DATABASE IF EXISTS #{Settings.db.database}")
  end

  desc 'Prints current schema version'
  task :version do
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    puts "Schema Version: #{version}"
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do |t, args|
    db_migrate(args[:version] || db_migrations.last)
  end

  desc "Perform rollback to specified target or previous version as default"
  task :rollback, [:version] do |t, args|
    version =
      if DB.tables.include?(:schema_info)
        DB[:schema_info].first[:version]
      end || 0

    target = version.zero? ? 0 : (version - 1)
    args.with_defaults(target: target)

    db_migrate(args[:target].to_i)
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    db_migrate(0)
    db_migrate
  end

  desc 'Seed the database with application required data'
  task :seed do
    require 'sequel/extensions/seed'

    Sequel.extension :seed
    Sequel::Seed.setup(ENV['RACK_ENV'])

    Sequel::Seeder.apply(DB, Settings.app.seed_folder_path)
  end

  namespace :schema do
    task :dump do
      DB.extension(:schema_dumper)

      if Dir.exists?(Settings.app.db_schema_folder_path)
        File.open(File.join(Settings.app.db_schema_folder_path, Settings.app.schema_file_name).to_s, 'w') do |file|
          file << DB.dump_schema_migration(indexes: true, foreign_keys: true)
        end

      else
        abort "The db/ directory doesn't exist, please create it."
      end
    end
  end

  def db_migrations
    Dir["#{Settings.app.migrations_folder_path}/*.rb"].map { |f| File.basename(f) }.sort
  end

  def db_migrate(version = db_migrations.last)
    puts "Migrating database to version #{version}"
    Sequel::Migrator.run(DB, Settings.app.migrations_folder_path, target: version.to_i)

    Rake::Task['db:schema:dump'].execute
    Rake::Task['db:version'].execute
  end

  def require_dir(path)
    Dir["#{path}/**/*.rb"].each { |file| require file }
  end
end
