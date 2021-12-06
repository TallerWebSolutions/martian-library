# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true
    field :full_name, String, null: false

    delegate :full_name, to: :object
  end
end
