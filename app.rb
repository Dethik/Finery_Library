require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
# require 'library_db'
require './lib/book'
require './lib/patron'
require './lib/author'
also_reload 'lib/**/*.rb'

DB = PG.connect({:dbname => 'library'})

get('/') do
  #Intro Welcome page with most recent 5 books
  erb(:welcome)
end

get('/books') do
  @books = Book.all
  erb(:books)
end

get('/books/new') do
  erb(:new_book)
end

post('/books') do
  title = params[:title]
  book = Book.new({:title => title})
  book.save
  # @books = Book.sort
  @books = Book.all
  erb(:books)
end

get('/books/:id') do
  @book = Book.find(params[:id].to_i)
  erb(:book)
end

get('/books/:id/edit') do
  @book = Book.find(params[:id].to_i)
  @authors = Author.all
  erb(:edit_book)
end

patch('/books/:id') do
  @book = Book.find(params[:id].to_i)
  updates = params[:title]
  @book.add_authors([params[:book_author].to_i])
  @book.update(updates)
  @books = Book.all
  erb(:books)
end

delete('/books/:id') do
  @book = Book.find(params[:id].to_i)
  @book.delete
  @books = Book.all
  erb(:books)
end

### PATRON SECTION ###

get('/welcome/new') do
  erb(:new_patron)
end

post('/') do
  name = params[:name]
  patron = Patron.new({:name => name})
  patron.save
  erb(:welcome)
end

### AUTHOR SECTION ###

get('/authors') do
  @authors = Author.all
  erb(:authors)
end

get('/authors/new') do
  erb(:new_author)
end

post('/authors') do
  name = params[:author_name]
  author = Author.new({:name => name})
  author.save
  @authors = Author.all
  erb(:authors)
end

get('/authors/:id') do
  @author = Author.find(params[:id].to_i)
  erb(:author)
end

get('/authors/:id/edit') do
  @author = Author.find(params[:id].to_i)
  erb(:edit_author)
end

patch('/authors/:id') do
  @author = Author.find(params[:id].to_i)
  updates = params[:author_name]
  @author.update(updates)
  @authors = Author.all
  erb(:author)
end

delete('/authors/:id') do
  @author = Author.find(params[:id].to_i)
  @author.delete
  @authors = Author.all
  erb(:authors)
end


