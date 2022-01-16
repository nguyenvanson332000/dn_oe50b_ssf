class SoccerFieldSerializer < ActiveModel::Serializer
  attributes :id, :field_name, :type_field, :description, :price, :status
end
