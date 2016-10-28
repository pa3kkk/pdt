Rails.application.routes.draw do
  root 'map#index'

  post 'map/distance'
  get 'map/close_place'
  get 'map/sports_list'
  get 'map/one_sport'
end
