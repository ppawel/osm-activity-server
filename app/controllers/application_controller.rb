class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_access_control_headers

  # Needed for incoming cross domain AJAX requests.
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
