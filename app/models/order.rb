class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems

  # Use "request" for order confirmed temporarily
  validates :name, presence: true, on: :request
  validates :email, presence: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email"},
                    on: :request
  validates :mailing_address, presence: true, on: :request
  validates :cc_name, presence: true, on: :request
  validates :cc_number, presence: true,  
                        numericality: { only_integer: true }, 
                        on: :request
  validates :cc_exp_date, presence: true, on: :request   
  validates :billing_zip_code, presence: true, on: :request
  validate :cc_num_valid?, :cc_exp_date_valid? 
  
  def cc_num_valid?
    if cc_number.present? && (cc_number.to_s.length < 13 || cc_number.to_s.length > 19)
      errors.add(:cc_number, "length must between 13 to 19")
    end
  end

  def cc_exp_date_valid?
    if cc_exp_date.present? && Datetime.parse(cc_exp_date) < Date.today
      errors.add(:cc_exp_date, "can't be in the past")
    end
  end
end
