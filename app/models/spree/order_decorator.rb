module Spree
  module OrderDecorator
    def self.prepended(base)
      base.after_update :apply_promotions

    end

    private

    def apply_promotions
      ::PromotionService.new(self).apply
    end
  end
  Order.prepend(Spree::OrderDecorator)
end

