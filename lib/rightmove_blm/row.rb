# frozen_string_literal: true

module RightmoveBLM
  # A row in a BLM document.
  class Row
    attr_reader :index

    def self.from_attributes(attributes, index:)
      new(index: index, data: nil, separator: nil, definition: attributes.keys, attributes: attributes)
    end

    def initialize(index:, data:, separator:, definition:, attributes: nil)
      @index = index
      @data = data
      @separator = separator
      @definition = definition
      @attributes = attributes
      @fields = attributes.keys unless attributes.nil?
    end

    def to_h
      attributes
    end

    def valid?
      return false unless field_size_valid?

      true
    end

    def errors
      return [] if valid?

      errors = []
      errors << field_size_mismatch_message unless field_size_valid?
      errors
    end

    def attributes
      return nil unless valid?

      @attributes ||= fields.each_with_index.to_h do |field, field_index|
        [definition[field_index].to_sym, field.strip]
      end
    end

    private

    attr_reader :data, :separator, :definition

    def field_size_mismatch_message
      "Field size mismatch in row #{index}. Expected: #{definition.size} fields, found: #{fields.size}"
    end

    def fields
      @fields ||= data.split(separator)
    end

    def field_size_valid?
      definition.size >= fields.size
    end

    def method_missing(method, *_arguments)
      return super if attributes.nil?
      return attributes[method] unless attributes[method].nil?

      super
    end

    def respond_to_missing?(method, _ = false)
      !attributes[method].nil?
    end
  end
end
