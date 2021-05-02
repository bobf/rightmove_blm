# frozen_string_literal: true

module RightmoveBLM
  # A row in a BLM document.
  class Row
    attr_accessor :attributes

    def initialize(hash)
      @attributes = hash
    end

    def to_h
      @attributes
    end

    def method_missing(method, *_arguments)
      return @attributes[method] unless @attributes[method].nil?
    end

    def respond_to_missing?(method, _ = false)
      !@attributes[method].nil?
    end
  end
end
