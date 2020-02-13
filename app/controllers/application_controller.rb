class ApplicationController < ActionController::Base
    before_action :protect

    def protect
      @ips = ENV['IPOK'].split(',')
      unless @ips.include? request.remote_ip
         render action: "unauth"
      end
    end
    
    def unauth
        render "pages/unauth"
    end
end
