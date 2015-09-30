require 'bundler/setup'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "db/lab4.sqlite3"
)

class CreateAuthorsMigration < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :surname
      t.date :born
      t.date :died
      t.string :image_url
    end
  end
end

class CreateBooksMigration < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :language
      t.references :author
      t.integer :published
      t.string :image_url
    end
  end
end

class CreateGenresMigration < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
    end
  end
end

class CreateBooksGenresMigration < ActiveRecord::Migration
  def change
    create_table :books_genres, id: false do |t|
      t.references :book
      t.references :genre
    end
    add_index :books_genres, [:book_id,:genre_id], unique: true
  end
end

class AddIndicesMigration < ActiveRecord::Migration
  def change
  end
end

unless ActiveRecord::Base.connection.table_exists? 'authors'
  CreateAuthorsMigration.new.migrate(:up)
end
unless ActiveRecord::Base.connection.table_exists? 'books'
  CreateBooksMigration.new.migrate(:up)
end
unless ActiveRecord::Base.connection.table_exists? 'genres'
  CreateGenresMigration.new.migrate(:up)
end
unless ActiveRecord::Base.connection.table_exists? 'books_genres'
  CreateBooksGenresMigration.new.migrate(:up)
end
AddIndicesMigration.new.migrate(:up)

unless defined?(Author)
  class Author < ActiveRecord::Base
    has_many :books
  end

  class Book < ActiveRecord::Base
    belongs_to :author
    has_and_belongs_to_many :genres
  end

  class Genre < ActiveRecord::Base
    has_and_belongs_to_many :books
  end
end
