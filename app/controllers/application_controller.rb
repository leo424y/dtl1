class ApplicationController < ActionController::Base
    before_action :protect

    def protect
      @ips = ['::1', '111.235.245.215'] #And so on ...]
      if @ips.include? request.remote_ip
         render action: "unauth"
      end
    end
    
    def unauth
        render "pages/unauth"
    end
end
