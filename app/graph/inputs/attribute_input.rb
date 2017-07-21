AttributeInput = GraphQL::InputObjectType.define do
  name 'AttributeInput'
  description 'Attribute Information'

  argument :id,       !types.ID
  argument :data,     types[HashType]
  argument :quantity, !types.String
  argument :document, types.String, 'This field should have the following representation ' \
                                    '"#!file:some_name", where "some_name" could be for example, ' \
                                    'document1, document2  etc.' \
                                    'Then you have to attach files like here: ' \
                                    'http://take.ms/lhXVR'
end
