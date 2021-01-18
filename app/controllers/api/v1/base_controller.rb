class Api::V1::BaseController < ApplicationController
  
  include Pundit
  include ActiveHashRelation

  #authentication user for any request inherited from BaseController
  before_action :authenticate_request
  

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized!

  #end auth

  before_action :destroy_session


  ## Return user with Token specified in Authorization from Request Headers
  def current_user
    AuthorizeApiRequest.call(request.headers).result
  end

  ## Filter to check if the user who make the request has a subscription
  def subscription_filter
    if !current_user.subscribed?
      render json: { error: "User not subscribed"  }, status: :unauthorized 
    elsif !current_user.subscribtion_active?
      render json: { error: "Subcription Expired!"  }, status: :unauthorized 
    end
  end


  ## Filter to check if the user who make the request has a credit card
  def creditcard_filter
    if !current_user.creditcard?
      render json: { error: "You need register at least one creditcard"  }, status: :unauthorized 
    end
  end
  
  ## Close Session
  def destroy_session
    request.session_options[:skip] = true
  end
  
  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  def unauthorized!
    render json: { error: 'not authorized' }, status: :forbidden
  end

  def invalid_resource!(errors = [])
    api_error(status: 422, errors: errors)
  end

  def not_found!
    #return api_error(status: 404, errors: 'Not found')
    render json: { error: errors }, status: :not_found
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: jsonapi_format(errors).to_json, status: status
  end
  
  private
  #ember specific :/ need to be refactored to mobile apps 
  def jsonapi_format(errors)
    return errors if errors.is_a? String
    errors_hash = {}
    errors.messages.each do |attribute, error|
      array_hash = []
      error.each do |e|
        array_hash << {attribute: attribute, message: e}
      end
      errors_hash.merge!({ attribute => array_hash })
    end

    return errors_hash
  end
  
  #Auth user with token in request, this method is called in all the api
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers)

    #render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    render json: { error: @current_user.errors }, status: :unauthorized unless @current_user.result
  end



end
