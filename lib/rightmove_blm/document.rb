# frozen_string_literal: true

module RightmoveBLM
  # A BLM document including its header, definition, and data content.
  class Document
    def self.from_array_of_hashes(array)
      date = Time.now.utc.strftime('%d-%b-%Y %H:%M').upcase
      header = { version: '3', eof: '^', eor: '~', "property count": array.size.to_s, "generated date": date }
      new(header: header, definition: array.first.keys.map(&:to_sym), data: array)
    end

    def initialize(source: nil, header: nil, definition: nil, data: nil)
      @source = source
      @header = header
      @definition = definition
      @data = data&.map { |row| Row.new(row) }
    end

    def to_blm
      [
        header_string,
        definition_string,
        data_string
      ].join("\n")
    end

    def header
      @header ||= contents(:header).each_line.map do |line|
        next nil if line.empty?

        key, _, value = line.partition(' : ')
        next nil if value.nil?

        [key.downcase.to_sym, value.tr("'", '').strip]
      end.compact.to_h
    end

    def definition
      @definition ||= contents(:definition).split(header[:eor]).first.split(header[:eof]).map do |field|
        next nil if field.empty?

        field.downcase.strip
      end.compact
    end

    def data
      @data ||= contents.split(header[:eor]).map do |line|
        row(line)
      end
    end

    private

    def contents(section = :data)
      marker = "##{section.to_s.upcase}#"
      start = @source.index(marker) + marker.size
      finish = @source.index('#', start) - 1
      @source[start..finish].strip
    end

    def row(line)
      entry = {}
      line.split(header[:eof]).each_with_index do |field, index|
        entry[definition[index].to_sym] = field.strip
      end
      Row.new(entry)
    end

    def generated_date
      header[:'generated date'] || Time.now.utc.strftime('%d-%b-%Y %H:%M').upcase
    end

    def header_string
      ['#HEADER#', "VERSION : #{header[:version]}", "EOF : '|'", "EOR : '~'",
       "Property Count : #{data.size}", "Generated Date : #{generated_date}", '']
    end

    def definition_string
      ['#DEFINITION#', "#{definition.join('|')}|~", '']
    end

    def data_string
      ['#DATA#', *data.map { |row| "#{row.attributes.values.join('|')}~" }, '#END#']
    end
  end
end
