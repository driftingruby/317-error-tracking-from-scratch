Rails.application.routes.draw do
  resource :record_exceptions, only: :create
  root to: 'welcome#index'
end
