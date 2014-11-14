class Order < ActiveRecord::Base
  belongs_to :user

  scope :registered_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  scope :from_user_ids, ->(user_ids) { where user_id: user_ids }

  scope :unique_per_user, ->{ select(:user_id).distinct }

  scope :first_orders, -> do
    select(:user_id).distinct
    .joins(:user)
    .where('orders.id = (SELECT orders.id FROM orders WHERE orders.user_id = users.id ORDER BY orders.created_at ASC LIMIT 1)')
  end
end
