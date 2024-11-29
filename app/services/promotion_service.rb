class PromotionService
  def initialize(order)
    @order = order
  end

  def apply
    applicable_promotions.each do |promotion|
      if promotion_applicable?(promotion)
        apply_promotion(promotion)
      else
        remove_promotion(promotion)
      end
    end
  end

  private

  def applicable_promotions
    Promotion.all
  end

  def promotion_applicable?(promotion)
    conditions = JSON.parse(promotion.conditions)

    evaluate_conditions(conditions)
  end

  def evaluate_conditions(conditions)
    conditions['line_items'].all? do |condition|
      @order.line_items.any? do |line_item|
        line_item.product_id == condition['product_id'].to_i &&
        line_item.quantity >= condition['quantity'].to_i
      end
    end
  end

  def apply_promotion(promotion)
    conditions = JSON.parse(promotion.conditions)

    # Example: Add a free product
    if conditions['reward'] == 'free_product'
      free_product = Spree::Product.find(conditions['free_product_id'].to_i)
      return unless free_product

      free_variant = free_product.master
      return unless free_variant

      existing_item = @order.line_items.find_by(variant: free_variant, price: 0)
      if existing_item
        existing_item.quantity += 1
        existing_item.save
      else
        @order.line_items.create!(
          variant: free_variant,
          quantity: 1,
          price: 0,
          promo_total: 0,
          order: @order
        )
      end
    end

    # # Example: Apply discount
    # if conditions['reward'] == 'discount'
    #   discount_amount = conditions['discount_amount'].to_f
    #   @order.adjustments.create!(
    #     amount: -discount_amount,
    #     label: "Promotion: #{promotion.name}",
    #     adjustable: @order
    #   )
    # end
  end
  
  def remove_promotion(promotion)
    conditions = JSON.parse(promotion.conditions)

    if conditions['reward'] == 'free_product'
      free_product = Spree::Product.find(conditions['free_product_id'].to_i)
      return unless free_product

      free_variant = free_product.master
      return unless free_variant

      existing_item = @order.line_items.find_by(variant: free_variant, price: 0)
      if existing_item
        existing_item.destroy!
      end
    end
  end
end
