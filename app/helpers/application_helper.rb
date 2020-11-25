module ApplicationHelper
  def format_money(money_integer)
    Money.new(money_integer.ceil, "USD").format
  end
end
