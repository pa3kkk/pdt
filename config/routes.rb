Rails.application.routes.draw do
  root 'map#index'

  post 'map/distance'
  get 'map/close_place'
  get 'map/sports_list'
end
