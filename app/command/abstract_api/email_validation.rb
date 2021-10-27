module AbstractApi
    class EmailValidation
      include HTTParty
      require 'uri'
      require 'net/http'
  
      base_uri Rails.application.config_for(:abstract_api)["base_url"]
      API_KEY = Rails.application.config_for(:abstract_api)["apikey"]
  
      def self.run(email)
        response = check_email(email)
  
        return response.success? ? :ok : :not_ok, response.code, response.parsed_response
      end
  
      private
        def self.check_email(email)
            get(
                "/?api_key=#{API_KEY}&email=#{email}", 
            )
        end
    end
  end