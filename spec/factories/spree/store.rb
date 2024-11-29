FactoryBot.define do
  factory :store, class: Spree::Store do
    name { 'Test Store' }
    default { true }
    default_currency { 'USD' }
    mail_from_address { 'dd@example.com' }
    code { 'test_store' }
    url { 'http://teststore.com' }
  end
end