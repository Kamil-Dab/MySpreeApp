FactoryBot.define do
  factory :promotion, class: 'Promotion' do
    sequence(:name) { |n| "Test #{n}" }
    description { "ddd" }
    conditions { { 'line_items' => ["test"] } }
  end
end
