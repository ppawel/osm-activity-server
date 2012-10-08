ActivityServer::Application.routes.draw do
  resources :activities
  match '/' => 'application#index'
end
