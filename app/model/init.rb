require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper::Model.raise_on_save_failure = true

require_relative 'blog'

DataMapper.auto_upgrade!
