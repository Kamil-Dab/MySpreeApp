module Spree
  module Promotion
    module Actions
      class AddFreeProduct < Spree::Promotion::Actions::Base
        def perform(order)
          free_variant = Spree::Variant.find_by(id: preferred_free_variant_id)
          return unless free_variant

          order.contents.add(free_variant, preferred_free_quantity, promotions: [self.promotion])
        end

        def preferred_free_variant_id
          preferred[:free_variant_id]
        end

        def preferred_free_quantity
          preferred[:free_quantity] || 1
        end

        def self.description
          "Dodaje darmowy produkt do zamówienia"
        end
      end
    end
  end
end
