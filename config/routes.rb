Rails.application.routes.draw do
  get 'index' => 'economic_indicator#index'
  get 'show' => 'economic_indicator#show'
  get 'table' => 'economic_indicator#table'

end
