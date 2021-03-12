require 'spec_helper'

describe('#Book') do
  describe('.all') do
    it("returns an empty array when there are no books") do
      expect(Book.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same book if it has the same attributes as another book") do
      book = Book.new({title: "The Talisman"})
      book2 = Book.new({title: "The Talisman"})
      expect(book).to(eq(book2))
    end
  end

  describe('#save') do
    it("saves an book") do
      book = Book.new({title: "The Talisman"})
      book.save
      book2 = Book.new({title: "Cujo"})
      book2.save
      expect(Book.all).to(eq([book, book2]))
    end
  end

  describe('.clear') do
    it("clears all books") do
      book = Book.new({title: "The Talisman"})
      book.save
      book2 = Book.new({title: "Cujo"})
      book2.save
      Book.clear
      expect(Book.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an book by id") do
      book = Book.new({title: "The Talisman"})
      book.save
      book2 = Book.new({title: "Cujo"})
      book2.save
      expect(Book.find(book.id)).to(eq(book))
    end
  end

  describe('#update') do
    it("updates an book by id") do
      book = Book.new({title: "The Talisman"})
      book.save
      book.update("Cujo")
      expect(book.title).to(eq("Cujo"))
    end
  end

  describe('#delete') do
    it("deletes an book by id") do
      book = Book.new({title: "The Talisman"})
      book.save
      book2 = Book.new({title: "Cujo"})
      book2.save
      book.delete
      expect(Book.all).to(eq([book2]))
    end
  end

  describe('#add_authors') do
    it("adds author and book id to authors_books JOIN table") do
      author = Author.new({name: "Stephen King"})
      author.save
      author2 = Author.new({name: "Peter Straub"})
      author2.save
      book = Book.new({title: "The Talisman"})
      book.save
      book.add_authors([author.id])
      book.add_authors([author.id])
      book.add_authors([author2.id])
      book.add_authors([author2.id])
      # binding.pry
      expect(book.authors).to(eq([author, author2]))
    end
  end
end
