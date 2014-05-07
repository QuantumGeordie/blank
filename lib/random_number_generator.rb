module RandomNumberGenerator
  def self.generate_random_number(range = 10)
    rand(range).to_s
  end
end
