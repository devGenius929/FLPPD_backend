class WelcomeController < ApplicationController

  def index
    redirect_to "http://www.flppdapp.com"
  end

  def confirm_email
    unless params[:code].match(/^[a-zA-Z\d\$\.]{60}$/)
      @message = 'Invalid code'
      render
    end
    user = User.find_by(activation_digest: params[:code])
    unless user
      @message = 'User not found'
      render
    end
    user.update_attribute(:activated, true)
    @message = 'Thank you! Email confirmed!'
  end
end
