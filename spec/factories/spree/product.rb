FactoryBot.define do
  factory :product, class: Spree::Product do
    name { 'Test Product' }
    price { 100 }
    
    association :shipping_category, factory: :shipping_category
    stores { [association(:store)] }
    status { 'active' }
  end
end