class Api::V1::AuthenticationController < Api::ApplicationController
    skip_before_action :authenticate_request

    def send_email
        email = "uchan.mochan@gmail.com"
        otp = "543123"
        email_log = OtpMailer.email_otp(email, otp).deliver_later
        render json: email_log.as_json
    end

    def signup
        auth = Command::Authentication.sign_up(params)
        
        render json: auth.as_json, status: auth[:meta][:status]
    end
     
    def verify_email
        verify = Command::Authentication.verify_otp(params)

        render json: verify.as_json, status: verify[:meta][:status]   
    end

    def email_valid
        data = AbstractApi::EmailValidation.run("uchan.mochan@gmail.com")
        render json: data.as_json
    end
    
    
end
