Rails.application.routes.draw do

  devise_for :customer,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    root to: 'homes#top'
    resources :items, except: [:destroy]
    resources :customers, except: [:new, :create, :destroy]
    resources :orders, only: [:show, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :order_details, only: [:update]
  end
  
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    resources :addresses, except: [:new, :show]
    resources :cards, only: [:new, :create]
    resources :cart_items, except: [:new, :show, :edit] do
      collection do
        delete 'destroy_all'
      end
    end
    resources :items, only: [:index, :show]
    get "items/genre_search/:id", to: "items#genre_search",as: 'items_genre_search'
    post 'orders/check' => 'orders#check'
    get 'orders/check_view' => 'orders#check_view'
    get 'orders/success' => 'orders/success'
    resources :orders, except: [:edit, :update, :destroy]
    patch 'customers/'=> 'customers#update'
    resources :customers, only: [] do
      collection do
        get :show
        get :edit
        patch :leave
        get :erasure
        get :creditcard
      end
    end
  end
      get '/search', to: 'searchs#search'
      resources :contacts, only: [:new, :create]
      post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
      post 'contacts/back', to: 'contacts#back', as: 'back'
      get 'done', to: 'contacts#done', as: 'done'
end
