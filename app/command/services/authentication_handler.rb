module Services
    class AuthenticationHandler
        EMAIL_OTP_HARDCODED = [
            "uchan.mochan@gmail.com", #contributor 
            "rezayantinpd@gmail.com" #user
          ]
        OTP_HARDCODED = "1234567"

        def self.sign_up(params)
            email_validation = AbstractApi::EmailValidation.run(params[:email])

            if :ok
                user = User.find_by(email: params[:email])

                if !user.present?
                    email_id = Array.new(12){[*"0".."9"].sample}.join    
                    user = User.create(email: params[:email], email_id: email_id, role:params[:role])
                    puts "Not Present"
                    puts user.as_json
                    code = 201
                else
                    code = 200
                end
                unless EMAIL_OTP_HARDCODED.include? params[:email]
                    otp = Array.new(7){[*"0".."9"].sample}.join
                    hashed_password = BCrypt::Password.create(otp)
                    user.update_attributes(otp: hashed_password, otp_expired: Time.now + 5.minutes)
                    emaillog = OtpMailer.email_otp(params[:email], otp).deliver_later
                end
                Handler::Res.call(code, "Waiting for OTP", user)
            else
                Handler::Res.call(400, "Email not valid", user)
            end
        end

        def self.verify_otp(params)
            user = User.find_by_email_id(params[:email_id])
            
            unless EMAIL_OTP_HARDCODED.include? params[:email]
                result = BCrypt::Password.new(user[:otp]) == params[:otp] && user.email_id == params[:email_id] && Time.now <= user[:otp_expired]
            else
                result = params[:otp] == OTP_HARDCODED
            end
            
            if result
                user.update(otp_expired: Time.now)
                auth = AuthenticateUser.call(user.email)

                data = {
                        user: user.as_json, 
                        token: auth.result
                    }
                
                Handler::Res.call(200, "This user has been verified", data)
            else
                Handler::Res.call(401, "Incorrect code, please try again.", data)
            end
        end
        
        
    end
end