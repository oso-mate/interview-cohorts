class Order < ActiveRecord::Base
  belongs_to :user

  scope :registered_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  scope :from_user_ids, ->(user_ids) { where user_id: user_ids }

  scope :unique_per_user, ->{ select(:user_id).distinct }

  def self.latest
    Order.order("created_at DESC").first
  end
end
