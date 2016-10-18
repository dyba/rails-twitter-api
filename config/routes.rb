Rails.application.routes.draw do
  get '/search', to: 'tweetboard#search'
end
