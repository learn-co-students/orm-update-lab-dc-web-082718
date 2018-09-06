require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students ( 
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM STUDENTS")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    #creates an instance w/ corresponding attribute values
    # sql = "SELECT * FROM students WHERE id = ?"
    # result = DB[:conn].execute(sql, id)
    # Student.new(id, result[1], result[2])
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
    #returns an instance of student that matches name from DB
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
  end







end
