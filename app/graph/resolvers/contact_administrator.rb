module Resolvers
  class ContactAdministrator
    def call(_object, inputs, _context)
      contact_request = ContactRequest.new(inputs.to_h)

      unless contact_request.save
        raise GraphQL::ExecutionError.new('Invalid input for Contact Request: ' \
                                          "#{contact_request.errors.full_messages.join(', ')}")
      end

      Admin::HelpRequest.perform_async(contact_request.sender_email, contact_request.body, contact_request.subject)

      { sender_email: contact_request.sender_email, body: contact_request.body }
    end
  end
end
