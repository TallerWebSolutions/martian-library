# frozen_string_literal: true

module Mutations
  class AddItemMutation < Mutations::BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :image_url, String, required: false

    field :item, Types::ItemType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(title:, description: nil, image_url: nil)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
              'You need to authenticate to perform this action'
      end

      item = Item.new(
        title: title,
        description: description,
        image_url: image_url,
        user: context[:current_user]
      )

      if item.save
        { item: item }
      else
        { errors: item.errors }
      end
    end
  end
end
