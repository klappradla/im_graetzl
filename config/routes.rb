Rails.application.routes.draw do

  get 'errors/not_found'
  get 'errors/internal_server_error'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  match "/clicked-room" => "sync#room", via: [:get, :post]
  get 'reports' => 'reports#index'
  get 'reports/mailchimp'
  get 'sitemap.xml' => redirect('https://s3.eu-central-1.amazonaws.com/im-graetzl-production/sitemaps/sitemap.xml.gz')
  get '/search' => 'search#index'

  ActiveAdmin.routes(self)

  devise_scope :user do
    resource :password,
      path: 'users/passwort',
      controller: 'users/passwords',
      path_names: { new: 'neu' }
    resource :confirmation,
      only: [:new, :create, :show],
      path: 'users/bestaetigung',
      controller: 'users/confirmations',
      path_names: { new: 'neu' }
    resource :registration,
      only: [:new, :create, :destroy],
      path: 'users',
      controller: 'users/registrations',
      path_names: { new: 'registrierung' } do
        post :set_address
        get :graetzls
      end

    post 'users/notification_settings/toggle_website_notification', to: 'notification_settings#toggle_website_notification', as: :user_toggle_website_notification
    post 'users/notification_settings/change_mail_notification', to: 'notification_settings#change_mail_notification', as: :user_change_mail_notification
  end

  devise_for :users, skip: [:passwords, :confirmations, :registrations],
    controllers: {
      sessions: 'users/sessions',
    },
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
    }

  resources :users, only: [:show, :update]

  resource :user, only: [:edit], path_names: { edit: 'einstellungen' } do
    get 'locations'
    get 'raumteiler', action: 'rooms', as: 'rooms'
    get 'groups'
    get 'zuckerl', action: 'zuckerls', as: 'zuckerls'
  end

  concern :graetzl_before_new do
    collection do
      post 'new', as: :before_new
    end
  end

  resources :activities, only: [:index]
  resources :meetings, path: 'treffen', except: [:show]
  resources :zuckerls, only: [:index]
  resources :rooms, only: [:index]
  resources :posts, only: [:index]

  resources :locations do
    concerns :graetzl_before_new
    resources :zuckerls, path: 'zuckerl', except: [:index, :show]
  end

  resources :room_demands, path: 'wien/raumteiler/raumsuche', except: [:index] do
    post 'toggle', on: :member
  end
  resources :room_offers, path: 'wien/raumteiler/raum', except: [:index] do
    get 'select', on: :collection
    post 'toggle', on: :member
  end
  resources :room_calls, path: 'wien/raumteiler/open-calls', except: [:index] do
    get 'submission', on: :member
    post 'add_submission', on: :member
  end


  resources :groups, except: [:index] do
    resources :discussions, only: [:index, :show, :create, :edit, :update, :destroy] do
      post :toggle_following, on: :member
    end
    resources :discussion_posts, only: [:create, :update, :destroy]
    post 'request_join', on: :member
    post 'accept_request', on: :member
    post 'reject_request', on: :member
    post 'remove_user', on: :member
    get 'compose_mail', on: :member
    post 'send_mail', on: :member
  end

  get 'wien/raumteiler/raumsuche' => redirect('/wien/raumteiler')
  get 'wien/raumteiler/raum' => redirect('/wien/raumteiler')
  get 'raumteiler' => redirect('/wien/raumteiler')
  get 'dieselgasse' => redirect('/wien/raumteiler/open-calls/raumteiler-hub-dieselgasse')
  get 'mixit' => redirect('/wien/raumteiler/open-calls/raumteiler-hub-mix-it')
  get 'raumteilerfestival', to: 'landing_pages#raumteiler_festival_2018'
  get 'raumteilerfestival/info', to: 'landing_pages#raumteiler_festival_2018_infos'

  resource :wien, controller: 'wien', only: [:show] do
    get 'visit_graetzl'
    get 'treffen', action: 'meetings', as: 'meetings'
    get 'locations'
    get 'raumteiler', action: 'rooms', as: 'rooms'
    get 'zuckerl', action: 'zuckerls', as: 'zuckerls'
  end

  resources :districts, path: 'wien', only: [:show] do
    get 'graetzls', on: :member
    get 'treffen', action: 'meetings', as: 'meetings', on: :member
    get 'locations', on: :member
    get 'raumteiler', action: 'rooms', as: 'rooms', on: :member
    get 'zuckerl', action: 'zuckerls', as: 'zuckerls', on: :member
  end

  get 'lp/raumteiler-guide', to: 'static_pages#lp_raumteilerguide'
  get 'lp/raumteiler-guide-danke', to: 'static_pages#lp_raumteilerguide_success'
  get 'info', to: 'static_pages#help'
  get 'info/raumteiler', to: 'static_pages#raumteiler'
  get 'info/anbieter-und-locations', to: 'static_pages#location'
  get 'info/events-und-workshops', to: 'static_pages#meetings'
  get 'info/agb', to: 'static_pages#agb'
  get 'info/datenschutz', to: 'static_pages#datenschutz'
  get 'info/impressum', to: 'static_pages#impressum'
  get 'info/infos-zum-graetzlzuckerl', to: 'static_pages#zuckerl'
  get 'info/fragen-und-antworten', to: 'static_pages#faq'
  get 'info/infos-zur-graetzlmarie', to: 'static_pages#graetzlmarie'
  get 'info/code-of-conduct', to: 'static_pages#code-of-conduct'
  get '/robots.txt' => 'static_pages#robots'

  root 'static_pages#home'

  resources :notifications, only: [:index] do
    post :mark_as_seen, on: :collection
  end

  resources :going_tos, only: [:create, :destroy]

  resources :zuckerls, path: 'zuckerl', only: [:new] do
    resource :billing_address, only: [:show, :create, :update]
  end

  resources :comments, only: [:create, :destroy]

  resources :location_posts, only: [:create, :destroy] do
    post :comments, action: :comment
  end
  resources :admin_posts, path: 'ideen', only: [:show, :destroy]

  namespace :api do
    resources :meetings, only: [:index]
  end

  resources :graetzls, path: '', only: [:show] do
    get 'treffen', action: 'meetings', as: 'meetings', on: :member
    get 'locations', on: :member
    get 'raumteiler', action: 'rooms', as: 'rooms', on: :member
    get 'zuckerl', action: 'zuckerls', as: 'zuckerls', on: :member
    get 'ideen', action: 'posts', as: 'posts', on: :member
    resources :meetings, path: 'treffen', only: [:show]
    resources :locations, only: [:show]
    resources :users, only: [:show]
    resources :user_posts, path: 'ideen', only: [:new, :show, :create, :destroy]
  end

end
