class Cohort

  attr_accessor :start_date, :end_date, :date, :registered_users, :orders

  def self.all_by_week(weeks)
    [].tap do |cohorts|
      weeks.times do |week|
        week_start_date = week_start_date(latest_user_date, week)
        week_end_date = week_end_date(latest_user_date, week)
        cohort = Cohort.new(week_start_date, week_end_date, week)

        cohorts.push cohort
      end
    end
  end

  def initialize(start_date, end_date, week)
    @start_date = start_date
    @end_date = end_date
    @date = "#{start_date.strftime("%m/%d")} - #{end_date.strftime("%m/%d")}"

    @registered_users = users.length
    @orders = { orderers: [], first_timers: [] }

    begin
      orderers = 0
      first_timers = 0

      users_by_day.each do |date, users|
        user_ids = users.map(&:id)
        date = date.gsub("_", "-").to_date

        week_start_date = Cohort.week_start_date(date, week)
        week_end_date = Cohort.week_end_date(date, week)

        first_timers += Order.registered_between(week_start_date, week_end_date).from_user_ids(user_ids).unique_per_user.count
      end

      week_start_date = Cohort.week_start_date(@start_date, week)
      week_end_date = Cohort.week_end_date(@end_date, week)
      orderers += Order.registered_between(week_start_date, week_end_date).unique_per_user.count

      @orders[:orderers].unshift orderers
      @orders[:first_timers].unshift first_timers

      week -= 1
    end while week >= 0
  end

  private

  def self.latest_user_date
    @latest_user_date ||= User.latest.created_at
  end

  def self.week_end_date(date, week)
    date.end_of_day - (week * 7).days
  end

  def self.week_start_date(date, week)
    date.beginning_of_day - (week * 7 + 6).days
  end

  def users
    @users ||= User.registered_between(start_date, end_date)
  end

  def users_by_day
    @users_by_day ||= users.group_by { |user| user.created_at.strftime("%Y_%m_%d") }
  end

end