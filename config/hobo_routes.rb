# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

Hitc::Application.routes.draw do


  # Lifecycle routes for controller "users"
  post 'users/signup(.:format)' => 'users#do_signup', :as => 'do_user_signup'
  get 'users/signup(.:format)' => 'users#signup', :as => 'user_signup'
  post 'users/signup_researcher(.:format)' => 'users#do_signup_researcher', :as => 'do_user_signup_researcher'
  get 'users/signup_researcher(.:format)' => 'users#signup_researcher', :as => 'user_signup_researcher'
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


  # Lifecycle routes for controller "study_invitations"
  put 'study_invitations/:id/accept_invitation(.:format)' => 'study_invitations#do_accept_invitation', :as => 'do_study_invitation_accept_invitation'
  get 'study_invitations/:id/accept_invitation(.:format)' => 'study_invitations#accept_invitation', :as => 'study_invitation_accept_invitation'

  # Resource routes for controller "study_invitations"
  get 'study_invitations(.:format)' => 'study_invitations#index', :as => 'study_invitations'
  get 'study_invitations/new(.:format)', :as => 'new_study_invitation'
  get 'study_invitations/:id/edit(.:format)' => 'study_invitations#edit', :as => 'edit_study_invitation'
  get 'study_invitations/:id(.:format)' => 'study_invitations#show', :as => 'study_invitation', :constraints => { :id => %r([^/.?]+) }
  post 'study_invitations(.:format)' => 'study_invitations#create', :as => 'create_study_invitation'
  put 'study_invitations/:id(.:format)' => 'study_invitations#update', :as => 'update_study_invitation', :constraints => { :id => %r([^/.?]+) }
  delete 'study_invitations/:id(.:format)' => 'study_invitations#destroy', :as => 'destroy_study_invitation', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "consent_texts"
  get 'consent_texts(.:format)' => 'consent_texts#index', :as => 'consent_texts'
  get 'consent_texts/new(.:format)', :as => 'new_consent_text'
  get 'consent_texts/:id/edit(.:format)' => 'consent_texts#edit', :as => 'edit_consent_text'
  get 'consent_texts/:id(.:format)' => 'consent_texts#show', :as => 'consent_text', :constraints => { :id => %r([^/.?]+) }
  post 'consent_texts(.:format)' => 'consent_texts#create', :as => 'create_consent_text'
  put 'consent_texts/:id(.:format)' => 'consent_texts#update', :as => 'update_consent_text', :constraints => { :id => %r([^/.?]+) }
  delete 'consent_texts/:id(.:format)' => 'consent_texts#destroy', :as => 'destroy_consent_text', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "study_enrollments"
  get 'study_enrollments(.:format)' => 'study_enrollments#index', :as => 'study_enrollments'
  get 'study_enrollments/new(.:format)', :as => 'new_study_enrollment'
  get 'study_enrollments/:id/edit(.:format)' => 'study_enrollments#edit', :as => 'edit_study_enrollment'
  get 'study_enrollments/:id(.:format)' => 'study_enrollments#show', :as => 'study_enrollment', :constraints => { :id => %r([^/.?]+) }
  post 'study_enrollments(.:format)' => 'study_enrollments#create', :as => 'create_study_enrollment'
  put 'study_enrollments/:id(.:format)' => 'study_enrollments#update', :as => 'update_study_enrollment', :constraints => { :id => %r([^/.?]+) }
  delete 'study_enrollments/:id(.:format)' => 'study_enrollments#destroy', :as => 'destroy_study_enrollment', :constraints => { :id => %r([^/.?]+) }


  # Lifecycle routes for controller "researchers"
  put 'researchers/:id/approve(.:format)' => 'researchers#do_approve', :as => 'do_researcher_approve'
  get 'researchers/:id/approve(.:format)' => 'researchers#approve', :as => 'researcher_approve'

  # Resource routes for controller "researchers"
  get 'researchers(.:format)' => 'researchers#index', :as => 'researchers'
  get 'researchers/new(.:format)', :as => 'new_researcher'
  get 'researchers/:id/edit(.:format)' => 'researchers#edit', :as => 'edit_researcher'
  get 'researchers/:id(.:format)' => 'researchers#show', :as => 'researcher', :constraints => { :id => %r([^/.?]+) }
  post 'researchers(.:format)' => 'researchers#create', :as => 'create_researcher'
  put 'researchers/:id(.:format)' => 'researchers#update', :as => 'update_researcher', :constraints => { :id => %r([^/.?]+) }
  delete 'researchers/:id(.:format)' => 'researchers#destroy', :as => 'destroy_researcher', :constraints => { :id => %r([^/.?]+) }


  # Lifecycle routes for controller "studies"
  put 'studies/:id/add_consent(.:format)' => 'studies#do_add_consent', :as => 'do_study_add_consent'
  get 'studies/:id/add_consent(.:format)' => 'studies#add_consent', :as => 'study_add_consent'

  # Resource routes for controller "studies"
  get 'studies(.:format)' => 'studies#index', :as => 'studies'
  get 'studies/new(.:format)', :as => 'new_study'
  get 'studies/:id/edit(.:format)' => 'studies#edit', :as => 'edit_study'
  get 'studies/:id(.:format)' => 'studies#show', :as => 'study', :constraints => { :id => %r([^/.?]+) }
  post 'studies(.:format)' => 'studies#create', :as => 'create_study'
  put 'studies/:id(.:format)' => 'studies#update', :as => 'update_study', :constraints => { :id => %r([^/.?]+) }
  delete 'studies/:id(.:format)' => 'studies#destroy', :as => 'destroy_study', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "managers"
  post 'managers(.:format)' => 'managers#create', :as => 'create_manager'
  put 'managers/:id(.:format)' => 'managers#update', :as => 'update_manager', :constraints => { :id => %r([^/.?]+) }
  delete 'managers/:id(.:format)' => 'managers#destroy', :as => 'destroy_manager', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "consents"
  get 'consents/new(.:format)', :as => 'new_consent'
  get 'consents/:id/edit(.:format)' => 'consents#edit', :as => 'edit_consent'
  get 'consents/:id(.:format)' => 'consents#show', :as => 'consent', :constraints => { :id => %r([^/.?]+) }
  post 'consents(.:format)' => 'consents#create', :as => 'create_consent'
  put 'consents/:id(.:format)' => 'consents#update', :as => 'update_consent', :constraints => { :id => %r([^/.?]+) }
  delete 'consents/:id(.:format)' => 'consents#destroy', :as => 'destroy_consent', :constraints => { :id => %r([^/.?]+) }


  # Index action routes for controller "community_members"
  get 'community_members/complete_name(.:format)', :as => 'complete_name_community_members'

  # Resource routes for controller "community_members"
  get 'community_members(.:format)' => 'community_members#index', :as => 'community_members'
  get 'community_members/new(.:format)', :as => 'new_community_member'
  get 'community_members/:id/edit(.:format)' => 'community_members#edit', :as => 'edit_community_member'
  get 'community_members/:id(.:format)' => 'community_members#show', :as => 'community_member', :constraints => { :id => %r([^/.?]+) }
  post 'community_members(.:format)' => 'community_members#create', :as => 'create_community_member'
  put 'community_members/:id(.:format)' => 'community_members#update', :as => 'update_community_member', :constraints => { :id => %r([^/.?]+) }
  delete 'community_members/:id(.:format)' => 'community_members#destroy', :as => 'destroy_community_member', :constraints => { :id => %r([^/.?]+) }


  # Resource routes for controller "test_modules"
  get 'test_modules(.:format)' => 'test_modules#index', :as => 'test_modules'
  get 'test_modules/new(.:format)', :as => 'new_test_module'
  get 'test_modules/:id/edit(.:format)' => 'test_modules#edit', :as => 'edit_test_module'
  get 'test_modules/:id(.:format)' => 'test_modules#show', :as => 'test_module', :constraints => { :id => %r([^/.?]+) }
  post 'test_modules(.:format)' => 'test_modules#create', :as => 'create_test_module'
  put 'test_modules/:id(.:format)' => 'test_modules#update', :as => 'update_test_module', :constraints => { :id => %r([^/.?]+) }
  delete 'test_modules/:id(.:format)' => 'test_modules#destroy', :as => 'destroy_test_module', :constraints => { :id => %r([^/.?]+) }

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
