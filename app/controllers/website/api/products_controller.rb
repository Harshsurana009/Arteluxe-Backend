module Website
  module Api
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show]

      def index
        products = Product.all
        total_count = products.count

        render json: {
          products: BulkSerializer.new(
            object: products,
            serializer: Admin::Api::ProductSerializer
          ),
          total_count: total_count
        }
      end

      def show
        render json: @product, serializer: Admin::Api::ProductSerializer
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        slug = params[:name].parameterize
        category = Array(params[:category])
        description = params[:description].presence || 'No description available'
        data = params.permit(:name, :price, :sticker_price)
        data[:slug] = slug
        data[:category] = category
        data[:description] = description
        data
      end
    end
  end
end