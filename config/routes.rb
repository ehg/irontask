Privydo::Application.routes.draw do

  get "home/index"

      resource :account, :controller => "users"
      resources :users, {:id => /.*/}
      resource :user_session, :as => "session"
      
      resources :tasks
      
      root :controller => "home", :action => "index"

      match '/users/username_available', :to => 'users#username_available'       

      if ["development", "test"].include? Rails.env
            mount Jasminerice::Engine => "/jasmine" 
      end
 
end
