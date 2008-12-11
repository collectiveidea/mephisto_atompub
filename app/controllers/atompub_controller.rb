class AtompubController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter :login_required
  layout nil
  session :off
  
private

    # Fix mephisto to store current user when authenticating with basic auth
    def basic_auth_required
      user = super
      self.current_user = user if User === user
    end
  
end