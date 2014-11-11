class CohortsController < ApplicationController

  def index
    @weeks = weeks
    @cohorts = cohorts
  end

  private

  def cohorts
    Cohort.all_by_week(@weeks)
  end

  def weeks
    params[:weeks] ? params[:weeks].to_i : 8
  end
end
