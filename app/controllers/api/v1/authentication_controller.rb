class Api::V1::AuthenticationController < Api::ApplicationController
    skip_before_action :authenticate_request

    def signup
        auth = Services::Authentication.sign_up(params)
        render json: auth.as_json, status: auth[:meta][:status]
    end
     
    def verify_email
        verify = Services::Authentication.verify_otp(params)
        render json: verify.as_json, status: verify[:meta][:status]   
    end
    
end
