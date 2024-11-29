FactoryBot.define do
  factory :order, class: Spree::Order do
    email { 'test@example.com' }
    state { 'complete' }
    completed_at { Time.current }
    currency { 'USD' }
    store_id { Spree::Store.default.id }

    after(:create) do |order|
      create(:line_item, order: order)
    end
  end

  factory :line_item, class: Spree::LineItem do
    order
    variant { create(:product).master }
    quantity { 2 }
    price { 100 }
  end
end