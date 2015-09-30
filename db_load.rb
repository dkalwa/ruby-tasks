require 'csv'
require 'db_load'

authors = {}
CSV.open("data/authors.csv","r:utf-8") do |input|
  input.each do |author,*rest|
    author = author.gsub("_"," ")
    authors[author] = rest
  end
end
books = {}
CSV.open("data/books_1.csv","r:utf-8") do |input|
  input.each do |book,*rest|
    book = book.gsub("_"," ")
    books[book] = rest
  end
end

CSV.open("data/books.csv","r:utf-8") do |input|
  input.each do |author,book_title|
    next if author !~ /^http/
    author_name = author[author.rindex("/")+1..-1].gsub("_"," ")
    last_space = author_name.rindex(" ")
    surname = author_name[last_space+1..-1]
    name = author_name[0...last_space]
    book_title = book_title[book_title.rindex("/")+1..-1].gsub("_"," ")
    author = Author.where(name: name, surname: surname).first
    if author.nil?
      author = Author.create!(name: name, surname: surname,born: authors[author_name][0],died: authors[author_name][1],image_url: authors[author_name][2])
    end
    book = Book.where(title: book_title).first
    next if book
    print "."
    year = books[book_title][0]
    year = year.to_i if year
    Book.create(title: book_title, author: author, published: year, image_url: books[book_title][1])
  end
end
