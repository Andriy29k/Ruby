require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

Capybara.default_driver = :selenium_chrome

RSpec.describe 'SauceDemo End-to-End Tests' do
  before(:each) do
    @session = Capybara::Session.new(:selenium_chrome)
    @base_url = 'https://www.saucedemo.com'
    @session.visit @base_url
  end

  describe 'User Authentication Tests' do
    let(:password) { 'secret_sauce' }

    shared_examples 'login tests' do |user, pass, expected_message|
      it "logs in or shows an error for #{user}" do
        authenticate(user, pass)
        if expected_message
          verify_error_message(expected_message)
        else
          expect(@session).to have_selector('[data-test="title"]', text: 'Products')
        end
      end
    end

    context 'when testing various user accounts' do
      include_examples 'login tests', 'error_user', 'incorrect_password', "Epic sadface: Username and password do not match any user in this service"
      include_examples 'login tests', 'locked_out_user', 'secret_sauce', "Epic sadface: Sorry, this user has been locked out."
      include_examples 'login tests', 'standard_user', 'secret_sauce', nil
    end
  end

  describe 'Cart Functionality Tests' do
    it 'adds multiple items to cart after logging in' do
      authenticate('standard_user', 'secret_sauce')
      add_to_cart('sauce-labs-backpack')
      add_to_cart('sauce-labs-fleece-jacket')
      expect(@session).to have_selector('[data-test="shopping-cart-badge"]', text: '2')
    end
  end

  def authenticate(username, password)
    @session.fill_in 'user-name', with: username
    @session.fill_in 'password', with: password
    @session.click_button('Login')
  end

  def verify_error_message(expected_message)
    expect(@session).to have_selector('[data-test="error"]', text: expected_message)
  end

  def add_to_cart(item_name)
    add_button = @session.find("[data-test='add-to-cart-#{item_name}']")
    add_button.click if add_button
  end

  after(:each) do
    @session.visit @base_url
  end
end
