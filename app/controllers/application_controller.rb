class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_home_url

  def set_home_url
    @home_url = "http://localhost:3000/assets/";
  end
end
