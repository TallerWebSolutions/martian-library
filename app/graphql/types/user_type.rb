# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true

    def full_name
      [object.first_name, object.last_name].compact.join(' ')
    end
  end
end
