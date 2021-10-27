module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    before_action :authenticate_request
    attr_reader :current_api_user
    rescue_from Timeout::Error, :with => :rescue_from_timeout

    protected

    def rescue_from_timeout(exception)
      render json: {message: {header: "Mohon Maaf", text: "Mohon maaf, ada terjadi kendala sistem. Mohon dicoba ulang sebentar lagi."}}, status: 408
    end

    
    private
    
    def authenticate_request
      @auth = AuthorizeApiRequest.call(request.headers)
      @current_api_user = @auth.result

      render json: {  
        status: 401, error: @auth.errors, message: "This is not a authorized request." 
      }, status: :unauthorized unless @current_api_user
    end
  end
end 