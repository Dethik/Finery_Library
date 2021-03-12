class Book
  attr_reader :id
  attr_accessor :title

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def self.all
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i
      books.push(Book.new({title: title, id: id}))
    end
    books
  end

  def ==(book_to_compare)
    self.title() == book_to_compare.title()
  end

  def save
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.clear
    DB.exec("DELETE FROM books *;")
  end

  def self.find(id)
    book = DB.exec("SELECT * FROM books WHERE id = #{id};").first()
    title = book.fetch("title")
    id = book.fetch("id").to_i
    Book.new({title: title, id: id})
  end

  def update(title)
    @title = title
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def add_authors(author_ids)
    author_ids.each do |author_id|
      if !DB.exec("SELECT * FROM authors_books WHERE author_id = #{author_id};").first
        DB.exec("INSERT INTO authors_books (author_id, book_id) VALUES (#{author_id}, #{@id});")
      end
    end
  end

  def authors
    returned_author_ids = DB.exec("SELECT * FROM authors_books WHERE book_id = #{@id};")
    authors = []
    returned_author_ids.each() do |id_set|
      author_id = id_set.fetch("author_id").to_i
      author_name = DB.exec("SELECT name FROM authors WHERE id = #{author_id};").first.fetch("name")
      authors.push(Author.new({name: author_name, id: author_id}))
    end
    authors
  end
end
