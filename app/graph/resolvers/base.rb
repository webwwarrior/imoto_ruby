module Resolvers
  class Base
    def formatted_hash(data, context)
      data.is_a?(Array) ? data.map { |records| format(records, context) } : format(data, context)
    end

    private

    def format(data, context)
      data.map do |key, value|
        if value.present? && value[0..6] == '#!file:'
          context[:attachments].present? ? [key, context[:attachments][value[7..-1]]] : [key, nil]
        else
          [key, value]
        end
      end.to_h
    end
  end
end
