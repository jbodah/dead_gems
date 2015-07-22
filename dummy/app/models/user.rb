class User
  # Superficial example
  def time
    Timecop.freeze do
      return Time.now
    end
  end
end
