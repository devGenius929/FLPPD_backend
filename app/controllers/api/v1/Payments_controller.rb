class Api::V1::PaymentsController < Api::V1::BaseController
	include Swagger::Blocks

	skip_before_action :authenticate_request, only: [:create_plan]
	before_action :creditcard_filter, only: [:new_subscription]

	swagger_path '/plans' do
		operation :post do
			key :summary, 'Create plan'
			parameter do
				key :name, 'plan[amount]'
				key :in, :formData
				key :type, :string
				key :description, 'plan amount'
      end
			parameter do
				key :name, 'plan[trial_period_days]'
				key :in, :formData
				key :type, :string
				key :description, 'trial period days'
      end
			parameter do
				key :name, 'plan[name]'
				key :in, :formData
				key :type, :string
				key :description, 'plan name'
      end
			parameter do
				key :name, 'plan[amount]'
				key :in, :formData
				key :type, :string
				key :description, 'plan amount'
      end
			parameter do
				key :name, 'plan[interval]'
				key :in, :formData
				key :type, :string
				key :description, 'plan interval'
      end
			parameter do
				key :name, 'plan[id]'
				key :in, :formData
				key :type, :string
				key :description, 'plan id'
      end
      response 200 do
				key :description, 'Stripe Plan object https://stripe.com/docs/api#plan_object'
      end
		end
  end

	swagger_path '/subscriptions' do
    operation :post do
			key :summary, 'Create subscription'
			parameter do
				key :name, :plan_id
				key :in, :formData
				key :type, :string
				key :description, 'plan id'
      end
			response 200 do
				key :description, 'Stripe Subscription object https://stripe.com/docs/api#subscription_object'
			end
    end
		operation :delete do
			response 200 do
				schema do
					property :message do
						key :type, :string
					end
				end
			end
		end
  end

	swagger_path '/subscriptions/reactivate' do
		operation :put do
			response 200 do
				schema do
					property :message do
						key :type, :string
					end
				end
			end
		end
  end

	swagger_path '/users/{id}/creditcards' do
		operation :post do
			key :summary, 'create user card'
			parameter do
				key :name, :id
				key :paramType, :path
				key :in, :path
				key :type, :integer
				key :description, 'id'
      end
			parameter do
				key :name, 'creditcard[number]'
				key :in, :formData
				key :type, :string
				key :description, 'card number'
      end
			parameter do
				key :name, 'creditcard[exp_month]'
				key :in, :formData
				key :type, :string
				key :description, 'card exp_month'
      end
			parameter do
				key :name, 'creditcard[exp_year]'
				key :in, :formData
				key :type, :string
				key :description, 'card exp_year'
      end
			parameter do
				key :name, 'creditcard[cvc]'
				key :in, :formData
				key :type, :string
				key :description, 'card cvc'
			end
      response 200 do
				key :description, 'Stripe Card object https://stripe.com/docs/api#card_object'
			end
		end
	end

	def create_plan
		new_plan = params[:plan]
		new_plan[:trial_period_days] = 7 unless new_plan[:trial_period_days]
		plan = Stripe::Plan.create(
	      :amount => new_plan[:amount],
	      :interval => new_plan[:interval],
	      :name => new_plan[:name],
	      :currency => "usd",
	      :id => new_plan[:id],
	      :trial_period_days => new_plan[:trial_period_days]
	    )
		render json: plan
	end

	def new_subscription
		new_subscription = Stripe::Subscription.create(
		  :customer => current_user.customer_id,
		  :plan => params[:plan_id]
		)
		render json: new_subscription
	end

	def cancel_subscription
		subscription_id = current_user.subscriptions[0].id
		subscription = Stripe::Subscription.retrieve(subscription_id)
		if subscription.delete(:at_period_end => true)
			render json: { message: "Subscription canceled"}
		else
			render json: { message: "The subscription could not be canceled"}, status: :unprocessable_entity
		end
	end

	def reactivate_subscription
		subscription_id = current_user.subscriptions[0].id
		subscription = Stripe::Subscription.retrieve(subscription_id)
		if subscription.save
			render json: { message: "The subscription reactivated!", subscription: subscription }, status: :unprocessable_entity
		else
			render json: { message: "The subscription could not be reactivated"}, status: :unprocessable_entity
		end
	end

	def add_creditcard
		creditcard = params[:creditcard]
		newToken = Stripe::Token.create(
		  :card => {
		    :number => creditcard[:number],
		    :exp_month => creditcard[:exp_month],
		    :exp_year => creditcard[:exp_year],
		    :cvc =>  creditcard[:cvc]
		  },
		)
		user = User.find(params[:id])
		customer = Stripe::Customer.retrieve(user.customer_id)
		card = customer.sources.create({:source => newToken.id})
		render json: card
	end

end