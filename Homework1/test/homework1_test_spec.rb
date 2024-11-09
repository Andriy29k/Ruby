# frozen_string_literal: true

require 'minitest/reporters'
require 'rspec'
require_relative '../homework1.rb'

Minitest::Reporters.use! [
                           Minitest::Reporters::SpecReporter.new,
                           Minitest::Reporters::HtmlReporter.new,
                           Minitest::Reporters::JUnitReporter.new
                         ]

RSpec.describe Person do
  before(:each) do
    Person.class_variable_set(:@@students, [])
  end

  describe '#initialize' do
    it "creates a new person with correct data" do
      person = Person.new("Andrii", "Korotchuk", "2003-09-29")
      expect(person.name).to eq("Andrii")
      expect(person.surname).to eq("Korotchuk")
      expect(person.date_of_birth).to eq(Date.new(2003,9,29))
    end

    it "raises an error if date of birth is in the future" do
      expect { Person.new("Masha", "Pupkina", "2048-01-01") }
        .to raise_error(ArgumentError, "Date of birth must be in the past")
    end
  end

  describe '#calculate_age' do
    it 'calculates age of person' do
      person = Person.new("Andrii", "Korotchuk", "2003-09-29")
      expect(person.calculate_age).to eq(Date.today.year - 2003)
    end
  end

  describe '.add_student' do
    it 'adds a new student to the @@students list if they are unique' do
      person = Person.new("Andrii", "Korotchuk", "2003-09-29")
      Person.add_student(person)
      expect(Person.all_students).to include(person)
    end

    it 'does not add a duplicate person' do
      person1 = Person.new("Andrii", "Korotchuk", "2003-09-29")
      Person.add_student(person1)
      Person.add_student(person1) # Додаємо ще раз ту ж особу
      expect(Person.all_students.count).to eq(1) # Перевірка, що дубліката немає
    end
  end

  describe '.remove_student' do
    it 'removes a student from the list' do
      person = Person.new("John", "Doe", "1999-01-01")
      Person.add_student(person)
      Person.remove_student(person)
      expect(Person.all_students).not_to include(person)
    end
  end

  describe '.get_students_by_name' do
    it 'returns students with the specified name' do
      person1 = Person.new("John", "Doe", "1999-01-01")
      person2 = Person.new("Jane", "Doe", "1999-12-31")
      Person.add_student(person1)
      Person.add_student(person2)
      expect(Person.get_students_by_name("John")).to include(person1)
      expect(Person.get_students_by_name("John")).not_to include(person2)
    end
  end

  describe '.get_students_by_age' do
    it 'returns students older than or exactly the specified age' do
      person1 = Person.new("John", "Doe", "2000-01-01")
      Person.add_student(person1)
      expect(Person.get_students_by_age(24)).to include(person1)
    end
  end

  describe 'uniqueness validation' do
    it 'does not add a student if they already exist' do
      person1 = Person.new("John", "Doe", "1999-01-01")
      Person.add_student(person1)
      expect { Person.add_student(person1) }
        .to output("Duplicate student detected: [John, Doe, 1999-01-01]\n").to_stdout
      expect(Person.all_students.count).to eq(1)
    end
  end
end
