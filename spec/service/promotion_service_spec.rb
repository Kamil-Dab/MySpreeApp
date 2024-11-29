require 'rails_helper'

RSpec.describe PromotionService do
  let(:order) { create(:order) }

  let(:promotion_service) { described_class.new(order) }
  let(:promotion) { create(:promotion, conditions: conditions.to_json) }

  describe '#apply' do
    context 'when promotion is applicable' do
      let(:conditions) do
        {
          'line_items' => [
            { 'product_id' => order.line_items.first.product_id, 'quantity' => order.line_items.first.quantity }
          ],
          'reward' => 'free_product',
          'free_product_id' => create(:product).id
        }
      end

      before do
        allow(Promotion).to receive(:all).and_return([promotion])
        allow(Spree::LineItem).to receive(:find_by).and_return(true)
        promotion_service.apply
      end

      it 'applies the promotion' do
        expect(order.line_items.where(price: 0).count).to eq(1)
      end
    end

    context 'when promotion is not applicable' do
      let(:conditions) do
        {
          'line_items' => [
            { 'product_id' => 999, 'quantity' => 1 }
          ],
          'reward' => 'free_product',
          'free_product_id' => create(:product).id
        }
      end

      before do
        allow(Promotion).to receive(:all).and_return([promotion])
        promotion_service.apply
      end

      it 'does not apply the promotion' do
        expect(order.line_items.where(price: 0).count).to eq(0)
      end
    end
  end

  describe '#remove_promotion' do
    let(:conditions) do
      {
        'line_items' => [
          { 'product_id' => order.line_items.first.product_id, 'quantity' => 1 }
        ],
        'reward' => 'free_product',
        'free_product_id' => create(:product).id
      }
    end

    before do
      allow(Promotion).to receive(:all).and_return([promotion])
      promotion_service.apply
      promotion_service.send(:remove_promotion, promotion)
    end

    it 'removes the promotion' do
      expect(order.line_items.where(price: 0).count).to eq(0)
    end
  end
end
