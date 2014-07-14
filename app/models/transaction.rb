class Transaction < ActiveRecord::Base
  belongs_to :company
  belongs_to :subscription
  
  attr_accessor :company_domain, :subscription

  def purchase(amount,credit_card)
    response = GATEWAY.purchase(amount, credit_card, purchase_options)
    self.update_attributes(transaction_id: response.params["transaction_id"],card_number: credit_card.display_number)    
    if response.success? 
       make_recurring(credit_card)
    end
   response.success?
  end
  
  def update_profile(profile_id)
	   response = GATEWAY.update_recurring(profile_id: profile_id,credit_card: credit_card)
  end
 
  private
  
  def purchase_options 
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "Ryan Bates",
        :address1 => "123 Main St.",
        :city     => "Chennai",
        :state    => "TN",
        :country  => "India",
        :zip      => "600083"
      }
    }
  end

  def make_recurring(credit_card)
    subscribe = Subscription.where("id = ?",self.subscription_id).first
    response_recurring=GATEWAY.recurring(subscribe.try(:amount), credit_card,
    :description => "Payment for #{subscribe.name}",
    :start_date => Date.tomorrow,
    :period => "Month",
    :frequency => subscribe.valid_log)
    self.update_attributes(profile_id: response_recurring.params["profile_id"])
    response_recurring.success?
  end
end