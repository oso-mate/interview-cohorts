Rails.application.routes.draw do
  root to: 'visitors#index'

  get "/cohorts(/:weeks)" => "cohorts#index"
end
