TwitterSearchAndFollow::Application.routes.draw do
  root to: 'search#show', as: 'search'

  controller :auth do
    get 'auth'     => :auth
    get 'callback' => :callback
  end

end
