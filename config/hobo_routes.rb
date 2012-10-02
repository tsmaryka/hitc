# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

Hitc::Application.routes.draw do


  # Lifecycle routes for controller "users"
  post 'users/signup(.:format)' => 'users#do_signup', :as => 'do_user_signup'
  get 'users/signup(.:format)' => 'users#signup', :as => 'user_signup'
  put 'users/:id/activate(.:format)' => 'users#do_activate', :as => 'do_user_activate'
  get 'users/:id/activate(.:format)' => 'users#activate', :as => 'user_activate'
  put 'users/:id/reset_password(.:format)' => 'users#do_reset_password', :as => 'do_user_reset_password'
  get 'users/:id/reset_password(.:format)' => 'users#reset_password', :as => 'user_reset_password'

  # Resource routes for controller "users"
  get 'users(.:format)' => 'users#index', :as => 'users'
  get 'users/new(.:format)', :as => 'new_user'
  get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
  get 'users/:id(.:format)' => 'users#show', :as => 'user', :constraints => { :id => %r([^/.?]+) }
  post 'users(.:format)' => 'users#create', :as => 'create_user'
  put 'users/:id(.:format)' => 'users#update', :as => 'update_user', :constraints => { :id => %r([^/.?]+) }
  delete 'users/:id(.:format)' => 'users#destroy', :as => 'destroy_user', :constraints => { :id => %r([^/.?]+) }

  # Show action routes for controller "users"
  get 'users/:id/account(.:format)' => 'users#account', :as => 'user_account'

  # User routes for controller "users"
  match 'login(.:format)' => 'users#login', :as => 'user_login'
  get 'logout(.:format)' => 'users#logout', :as => 'user_logout'
  match 'forgot_password(.:format)' => 'users#forgot_password', :as => 'user_forgot_password'


  # Resource routes for controller "consents"
  get 'consents(.:format)' => 'consents#index', :as => 'consents'
  get 'consents/new(.:format)', :as => 'new_consent'
  get 'consents/:id/edit(.:format)' => 'consents#edit', :as => 'edit_consent'
  get 'consents/:id(.:format)' => 'consents#show', :as => 'consent', :constraints => { :id => %r([^/.?]+) }
  post 'consents(.:format)' => 'consents#create', :as => 'create_consent'
  put 'consents/:id(.:format)' => 'consents#update', :as => 'update_consent', :constraints => { :id => %r([^/.?]+) }
  delete 'consents/:id(.:format)' => 'consents#destroy', :as => 'destroy_consent', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "consent_texts"
  get 'consent_texts(.:format)' => 'consent_texts#index', :as => 'consent_texts'
  get 'consent_texts/new(.:format)', :as => 'new_consent_text'
  get 'consent_texts/:id/edit(.:format)' => 'consent_texts#edit', :as => 'edit_consent_text'
  get 'consent_texts/:id(.:format)' => 'consent_texts#show', :as => 'consent_text', :constraints => { :id => %r([^/.?]+) }
  post 'consent_texts(.:format)' => 'consent_texts#create', :as => 'create_consent_text'
  put 'consent_texts/:id(.:format)' => 'consent_texts#update', :as => 'update_consent_text', :constraints => { :id => %r([^/.?]+) }
  delete 'consent_texts/:id(.:format)' => 'consent_texts#destroy', :as => 'destroy_consent_text', :constraints => { :id => %r([^/.?]+) }

  namespace :admin do


    # Resource routes for controller "admin/users"
    get 'users(.:format)' => 'users#index', :as => 'users'
    get 'users/new(.:format)', :as => 'new_user'
    get 'users/:id/edit(.:format)' => 'users#edit', :as => 'edit_user'
    get 'users/:id(.:format)' => 'users#show', :as => 'user', :constraints => { :id => %r([^/.?]+) }
    post 'users(.:format)' => 'users#create', :as => 'create_user'
    put 'users/:id(.:format)' => 'users#update', :as => 'update_user', :constraints => { :id => %r([^/.?]+) }
    delete 'users/:id(.:format)' => 'users#destroy', :as => 'destroy_user', :constraints => { :id => %r([^/.?]+) }

  end

end
