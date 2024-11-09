# frozen_string_literal: true
require 'minitest/autorun'
require_relative '../homework1'
require 'minitest/reporters'


unless ENV['RM_INFO']
  Minitest::Reporters.use! [
                             Minitest::Reporters::SpecReporter.new,
                             Minitest::Reporters::JUnitReporter.new,
                             Minitest::Reporters::HtmlReporter.new(
                               reports_dir: 'reports/',
                               reports_filename: 'test_results.html',
                               clean: false,
                               add_timestamp: true
                             )
                           ]
end

class Homework_Test < Minitest::Test
  def setup
    @person = Person.new("Andrii", "Korotchuk", "2003-09-29")
  end

  def teardown
    # Clear the all_students list to prevent test state carryover
    Person.all_students.clear
    @person = nil
  end

  def test_initialize
    assert_equal("Andrii", @person.name)
    assert_equal("Korotchuk", @person.surname)
    assert_equal(Date.new(2003, 9, 29), @person.date_of_birth)
    assert_includes(Person.all_students, @person)
  end

  def test_calculate_age
    assert_equal 21, @person.calculate_age
  end

  def test_add_student
    Person.add_student(@person)
    assert_includes(Person.all_students, @person, "Added to the list")
  end

  def test_remove_student
    Person.add_student(@person)
    Person.remove_student(@person)
    refute_includes(Person.all_students, @person, "Removed")
  end

  def test_valid_date_of_birth
    assert_raises(ArgumentError) do
      Person.new("Andrii", "Korotchuk", "2048-09-29")
    end
  end

  def test_get_student_by_name
    Person.add_student(@person)
    student_list = Person.get_students_by_name("Andrii")
    assert_includes student_list, @person
  end

  def test_get_student_by_age
    Person.add_student(@person)
    student_list = Person.get_students_by_age(21)
    assert_includes student_list, @person
  end
end
