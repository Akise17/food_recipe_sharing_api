class OtpMailer < ApplicationMailer
    def email_otp(email, otp)
        @otp = otp
        puts "#{email}::#{otp}"
        mail(
        from: "Recipe Sharing<ahmad.fauzan1603@gmail.com>",
        to: email,
        subject: "[No Reply] One Time Password (OTP)"
        )
    end
end
