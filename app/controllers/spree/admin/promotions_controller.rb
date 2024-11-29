class Spree::Admin::PromotionsController < Spree::Admin::BaseController
      before_action :set_promotion, only: [:edit, :update, :destroy]

      def index
        @promotions = Promotion.all
      end

      def new
        @promotion = Promotion.new
      end

      def create
        @promotion = Promotion.new(promotion_params)
        if @promotion.save
          redirect_to admin_promotions_path, notice: 'Promotion created successfully.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @promotion.update(promotion_params)
          redirect_to admin_promotions_path, notice: 'Promotion updated successfully.'
        else
          render :edit
        end
      end

      def destroy
        @promotion.destroy
        redirect_to admin_promotions_path, notice: 'Promotion deleted successfully.'
      end

      private

      def set_promotion
        @promotion = Promotion.find(params[:id])
      end

      def promotion_params
        params.require(:promotion).permit(:name, :description, :conditions)
      end
end
