class Spree::Api::PromotionsController < Spree::Api::V2::ResourceController
      before_action :set_promotion, only: [:show, :update, :destroy]

      def index
        @promotions = Promotion.all
        render json: @promotions
      end

      def show
        render json: @promotion
      end

      def new
        @promotion = Promotion.new
      end

      def create
        @promotion = Promotion.new(promotion_params)
        if @promotion.save
          render json: @promotion, status: :created
        else
          render json: @promotion.errors, status: :unprocessable_entity
        end
      end


      def update
        if @promotion.update(promotion_params)
          render json: @promotion
        else
          render json: @promotion.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @promotion.destroy
        head :no_content
      end

      private

      def set_promotion
        @promotion = Promotion.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Couldn't find Promotion" }, status: :not_found
      end

      def promotion_params
        params.require(:promotion).permit(:name, :description, conditions: { line_items: [] })
      end
end
