class User
  include MongoMapper::Document

  key :age, Integer, :default => 0
  key :interest, Array
end
