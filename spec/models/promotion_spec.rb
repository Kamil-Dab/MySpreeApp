require 'rails_helper'

RSpec.describe Promotion, type: :model do
  it 'is valid with valid attributes' do
    promotion = Promotion.new(name: 'Test Promotion', conditions: { 'line_items' => [] })
    expect(promotion).to be_valid
  end

  it 'is invalid without a name' do
    promotion = Promotion.new(conditions: { 'line_items' => [] })
    expect(promotion).not_to be_valid
  end

  it 'is invalid without conditions' do
    promotion = Promotion.new(name: 'Test Promotion')
    expect(promotion).not_to be_valid
  end
end
