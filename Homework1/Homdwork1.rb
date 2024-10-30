require 'date'

class Person
  @@students = []
  attr_accessor :name, :surname, :date_of_birth

  def initialize(name, surname, date_of_birth)
    @name = name
    @surname = surname
    @date_of_birth = date_of_birth
    @@students << self
    self.class.add_student(self)
  end

  def calculate_age
    dob = Date.parse(@date_of_birth) unless @date_of_birth.is_a?(Date)
    now = Date.today
    age = now.year - dob.year
    age -= 1 if now < dob.next_year(age)
    age
  end

  def self.add_student(person)
    @@students << person
  end

  def self.remove_student(person)
    @@students.delete(person)
  end

  def self.get_students_by_name(name)
    @@students.select {|student| student.name == name}
  end

  def self.get_students_by_age(age)
    @@students.select {|student| student.date_of_birth >= age}
  end

  def self.all_students
    @@students
  end
end

p = Person.new("Joe", "Dou", "2003-09-29")
p2 = Person.new("Alice", "Smith", "2001-01-11")
p3 = Person.new("Masha", "Pupkina", "2001-01-01")
p4 = Person.new("Iryna", "Serhienko", "2007-07-07")



Person.class_variable_get(:@@students)
