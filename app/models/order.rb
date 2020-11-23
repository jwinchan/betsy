class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems

  validate :orderitem_num?
  validates :name, presence: true, on: :create,
  validates :email, presence: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email"},
                    on: :create
  validates :mailing_address, presence: true, on: :create,
  validates :cc_name, presence: true, on: :create,
  validates :cc_number, presence: true,  
                        numericality: { only_integer: true }, 
                        on: :create,
                        cc_num_valid?
  validates :cc_exp_date, presence: true, 
                          on: :create,  
                          cc_exp_date_valid?  
  validates :billing_zip_code, presence: true, on: :create,

  def orderitem_num?
    if orderitems.size <= 0 
      errors.add(:cc_number, "orderitems in an order must greater than 0")
    end
  end
  
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
