# frozen_string_literal: true

module Admin
  module Api
    class ImagesController < ApplicationController
      def create
        image = Image.create!(image_params)
        if image
          render json: image, serializer: ImageSerializer, status: :created
          # success_json(I18n.t('messages.image_created'),
          #              ImageSerializer.new(image))
        end
      end

      private

      def image_params
        params.permit(:image)
      end
    end
  end
end
