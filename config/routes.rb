Privydo::Application.routes.draw do

      resource :account, :controller => "users"
      resources :users
      resource :user_session, :as => "session"
      
      resources :tasks
      
      root :controller => "user_sessions", :action => "new"
      
      if ["development", "test"].include? Rails.env
            mount Jasminerice::Engine => "/jasmine" 
      end
 
end
