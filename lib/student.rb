require 'pry'
require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize (id=nil, name, grade)
    @id, @name, @grade = id, name, grade

  end

  def save
    # FIRST ATTEMPT
    # sql = "SELECT students.name FROM students WHERE students.id = ?"
    # if !DB[:conn].execute(sql, @id).empty?
    if @id
      update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      db_execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE students.id = #{@id}"
    DB[:conn].execute(sql, @name, @grade)
  end

  def self.create (name, grade)
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, name, grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.find_by_name (name)
    sql = "SELECT * FROM students WHERE students.name = ?"
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)

  end

  def self.new_from_db (row)
    # sql = "SELECT * FROM students WHERE students.id = ?"
    # row = DB[:conn].execute(sql, attributes[0])
    # @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    student = self.new(row[0], row[1], row[2])

  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  #helper method
  def db_execute (sql, *params)
    DB[:conn].execute(sql, params)
  end
end
