# frozen_string_literal: true

class User
  attr_accessor :email, :password, :first_name, :last_name, :street_address, :street_address2, :city,
                :country, :state, :zip, :phone

  def initialize(opt = {})
    default_opt = defaults.merge(opt)

    @email = default_opt[:email]
    @password = default_opt[:password]
    @first_name = default_opt[:first_name]
    @last_name = default_opt[:last_name]
    @street_address = default_opt[:street_address]
    @street_address2 = default_opt[:street_address2]
    @city = default_opt[:city]
    @country = default_opt[:country]
    @state = default_opt[:state]
    @zip = default_opt[:zip]
    @phone = default_opt[:phone]
  end

  private

  def defaults
    {
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      street_address: Faker::Address.street_name,
      street_address2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      country: 'United States of America',
      state: Faker::Address.state,
      zip: Faker::Address.zip,
      phone: Faker::PhoneNumber.cell_phone
    }
  end
end
