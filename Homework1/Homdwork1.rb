require 'date'

class Person
  @@students = []
  attr_accessor :name, :surname, :date_of_birth

  def initialize(name, surname, date_of_birth)
    @date_of_birth = validate_date(date_of_birth)
    @name = name
    @surname = surname
    self.class.add_student(self)
  end

  def calculate_age
    dob = @date_of_birth.is_a?(String) ? Date.parse(@date_of_birth) : @date_of_birth
    now = Date.today
    age = now.year - dob.year
    age -= 1 if now < dob.next_year(age)
    age
  end

  def self.add_student(person)
    unless @@students.any? { |student| student.name == person.name && student.surname == person.surname && student.date_of_birth == person.date_of_birth }
      @@students << person
    else
      puts "Duplicate student detected: [#{person.name}, #{person.surname}, #{person.date_of_birth}]"
    end
  end

  def self.remove_student(person)
    @@students.delete(person)
  end

  def self.get_students_by_name(name)
    p @@students.select {|student| student.name == name}
  end

  def self.get_students_by_age(age)
    p @@students.select {|student| student.date_of_birth >= age}
  end

  def self.all_students
    @@students
  end

  private

  def validate_date(date_of_birth)
    parsed_date = Date.parse(date_of_birth)
    raise ArgumentError, "Date of birth must be in the past" if parsed_date >= Date.today
    parsed_date
  end
end


person1 = Person.new("John", "Doe", "1999-01-01")
person2 = Person.new("Jane", "Doe", "1999-12-31")
Person.all_students.each do |person| puts ("Student [ #{person.name}, #{person.surname}, #{person.date_of_birth} ]") end
Person.remove_student(person2)

puts "After delete"
Person.all_students.each do |person| puts ("Student [ #{person.name}, #{person.surname}, #{person.date_of_birth} ]") end

puts "Add new students"
person3 = Person.new("Masha", " Pupkina", "2000-01-01")
person4 = Person.new("Alice", "Smith", "2001-02-02")
Person.all_students.each do |person| puts ("Student [ #{person.name}, #{person.surname}, #{person.date_of_birth} ]") end

puts "Get student by name"
Person.get_students_by_name "Masha"

puts "Get student by age"
Person.get_students_by_age 25

puts "Validate uniqueness"
Person.add_student(person1)
Person.all_students.each do |person| puts ("Student [ #{person.name}, #{person.surname}, #{person.date_of_birth} ]") end

puts "Validate date"
begin
  person3 = Person.new("Masha", "Pupkina", "2025-01-01")
  puts person3
rescue ArgumentError => e
  puts "Error: #{e.message}"
end