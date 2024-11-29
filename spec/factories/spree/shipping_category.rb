FactoryBot.define do
  factory :shipping_category, class: Spree::ShippingCategory do
    name { 'Default' }
  end
end