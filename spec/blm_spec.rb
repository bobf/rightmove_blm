# frozen_string_literal: true

RSpec.describe RightmoveBLM do
  context 'reading a .blm file' do
    let(:data) { fixture('example_data.blm') }
    let(:blm) { RightmoveBLM::Document.new(source: data.read) }

    it 'should parse settings from the header' do
      expect(blm.header).to be_a(Hash)
      expect(blm.header[:version]).to  eq("3")
      expect(blm.header[:eof]).to_not be_nil
      expect(blm.header[:eor]).to_not be_nil
    end

    it 'should parse the column definition' do
      expect(blm.definition).to be_a(Array)
      expect(blm.definition.size).to be >= 1
    end

    it 'should parse the data into an array of hashes' do
      expect(blm.data).to be_a(Array)
      expect(blm.data.size).to be >= 1
      expect(blm.data).to respond_to(:each, :each_with_index)
      blm.data.each { |row| expect(row).to be_a(RightmoveBLM::Row) }
    end

    it 'should allow access to data values via methods' do
      blm.data.each { |row| expect(row.address_1).to_not be_nil }
    end

    it 'should allow access to the @attributes hash directly' do
      blm.data.each { |row| expect(row.attributes).to be_a(Hash) }
    end
  end

  context 'creating a .blm file' do
    subject(:document) { RightmoveBLM::Document.from_array_of_hashes(data) }

    let(:data) do
      [{ field1: 'row 1 field 1 data', field2: 'row 1 field 2 data', field3: 'row 1 field 3 data' },
       { field1: 'row 2 field 1 data', field2: 'row 2 field 2 data', field3: 'row 2 field 3 data' }]
    end

    its(:header) { is_expected.to include({ 'property count': '2' }) }
    its(:header) { is_expected.to include({ version: '3' }) }
    its(:definition) { is_expected.to eql %i[field1 field2 field3] }

    describe '#to_blm' do
      let(:loaded_document) { RightmoveBLM::Document.new(source: subject.to_blm) }

      it 'has a property count' do
        expect(loaded_document.header[:'property count']).to eql '2'
      end

      it 'has a version' do
        expect(loaded_document.header[:version]).to eql '3'
      end

      it 'has a "generated date" timestamp' do
        expect(loaded_document.header[:'generated date']).to start_with Time.now.utc.strftime('%d-%b-%Y').upcase
      end

      it 'has property data' do
        expect(loaded_document.data.map(&:to_h)).to eql data
      end

      it 'has a field definition' do
        expect(loaded_document.definition).to eql %w[field1 field2 field3]
      end
    end
  end
end
