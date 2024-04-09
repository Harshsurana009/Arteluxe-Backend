module Admin
  module Api
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]

      def index
        products = Product.all
        total_count = products.count

        render json: {
          products: BulkSerializer.new(
            object: products,
            serializer: ProductSerializer
          ),
          total_count: total_count
        }
      end

      def show
        render json: @product, serializer: ProductSerializer
      end

      def create
        ActiveRecord::Base.transaction do
          product = Product.new(product_params)

          if product.save
            add_attachments(product) if product_param_details[:image_id]
            render json: product, status: :created
          else
            render json: product.errors, status: :unprocessable_entity
          end
        end
      end

      def update
        if @product.update!(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy!
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        product_data = product_param_details
        data = {}
        data[:name] = product_data[:name]
        data[:slug] = product_data[:name].parameterize
        data[:price] = product_data[:new_price]
        data[:sticker_price] = product_data[:old_price]
        data[:category] = Array(product_data[:category])
        data[:description] = product_data[:description].presence || 'No description available'
        data
      end

      def product_param_details
        eval(params[:product_data])
      end

      def add_attachments(product)
        product.resource_attachments.create!(file_attachment_id: product_param_details[:image_id])
      end
    end
  end
end