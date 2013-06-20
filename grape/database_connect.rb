ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/starbucks.sqlite3')
ActiveRecord::Base.logger = Logger.new($stdout)
