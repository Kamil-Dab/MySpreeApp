module Spree
  module Api
    module CartControllerDecorator
      def self.prepended(base)
        base.after_action :apply_promotions, only: %i[add_item remove_line_item]

      end

      private

      def apply_promotions
        order = self.spree_current_order
        return unless order.persisted?

        ::PromotionService.new(order).apply
        order.update_totals
        order.save
      end
    end
    V2::Storefront::CartController.prepend(Spree::Api::CartControllerDecorator)
  end
end

