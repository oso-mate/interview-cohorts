class User < ActiveRecord::Base

  scope :registered_between, ->(start_date, end_date) { where created_at: start_date..end_date }

  def self.latest
    User.order("created_at DESC").first
  end
end
