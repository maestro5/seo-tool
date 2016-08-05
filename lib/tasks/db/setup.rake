require 'pg'
require 'yaml'

def db_exists?(db_conf)
  PG.connect(db_conf)
rescue PG::ConnectionBad => e
  false
end

namespace :db do
  desc 'Create databases and tables'
  task :setup do
    database_config = YAML::load(File.read('./config/database.yml'))
    env_name = %w(test development)

    env_name.each do |name|
      db_conf = database_config[name].clone
      db_conf.delete 'adapter'
      db_conf['dbname'] = db_conf.delete 'database'

      pg_conf = db_conf.clone
      pg_conf['dbname'] = 'postgres'

      # --------------------------------
      # create db if db does not exist
      # --------------------------------
      unless db_exists? db_conf
        PG.connect(pg_conf).exec("CREATE DATABASE #{db_conf['dbname']}")
      end

      connection = db_exists? db_conf
      puts "Success, database #{db_conf['dbname']} was created" if connection

      # --------------------------------
      # create user table
      # --------------------------------
      connection.exec(
        "CREATE TABLE dm_users
        (
          id serial NOT NULL,
          email character varying(50) DEFAULT ''::character varying,
          password_hash character varying(60),
          storage character varying(50) DEFAULT ''::character varying,
          admin boolean DEFAULT false,
          CONSTRAINT dm_users_pkey PRIMARY KEY (id )
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE dm_users
          OWNER TO #{db_conf['user']};"
      )

      # --------------------------------
      # create report table
      # --------------------------------
      connection.exec(
        "CREATE TABLE dm_reports
        (
          id serial NOT NULL,
          created_at timestamp without time zone DEFAULT '2016-06-02 09:39:24.841382'::timestamp without time zone,
          url character varying(50) DEFAULT ''::character varying,
          ip character varying(50) DEFAULT ''::character varying,
          location character varying(50) DEFAULT ''::character varying,
          server character varying(50) DEFAULT ''::character varying,
          title text DEFAULT ''::text,
          description text DEFAULT ''::text,
          keywords text DEFAULT ''::text,
          urls text DEFAULT ''::text,
          dm_user_id integer NOT NULL,
          CONSTRAINT dm_reports_pkey PRIMARY KEY (id )
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE dm_reports
          OWNER TO #{db_conf['user']};

        CREATE INDEX index_dm_reports_dm_user
          ON dm_reports
          USING btree
          (dm_user_id );"
      )

      puts "Success, #{db_conf['dbname']} tables was created"
    end # env_name.each
  end # create
end # namespace :db
