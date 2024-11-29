class Promotion < Spree::Base

  validates :name, presence: true
  validates :conditions, presence: true
end
