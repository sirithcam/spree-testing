class User
  attr_accessor :email, :password

  def initialize
    @email = Faker::Internet.unique.safe_email
    @password = Faker::Internet.password
  end
end
