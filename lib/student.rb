require_relative "../config/environment.rb"

# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = '')
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)
  end

  def save
    if id == nil
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
    else
      sql = <<-SQL
        UPDATE students
        SET name = ?, grade = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
    end

    self.id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]

    self

  end

  def self.create(name, grade)

    new_student = Student.new(name, grade)
    new_student.save

  end

  def self.new_from_db(row)
    new_student = create(row[1], row[2])
    new_student.id = row[0]
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = name
    SQL
    new_from_db(DB[:conn].execute(sql)[0])
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
