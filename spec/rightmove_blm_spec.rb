# frozen_string_literal: true

RSpec.describe RightmoveBLM do
  context 'when reading a .blm file' do
    let(:blm_data) { fixture('example_data.blm') }
    let(:blm) { RightmoveBLM::Document.new(source: blm_data.read) }

    describe '#header' do
      subject(:header) { blm.header }

      it { is_expected.to be_a(Hash) }
      its([:version]) { is_expected.to eql '3' }
      its([:eof]) { is_expected.not_to be_nil }
      its([:eor]) { is_expected.not_to be_nil }
    end

    describe '#definition' do
      subject(:definition) { blm.definition }

      it { is_expected.to be_an Array }
      its(:size) { is_expected.to be >= 1 }
    end

    describe '#rows' do
      subject(:rows) { blm.rows }

      it { is_expected.to be_an Array }
      its(:size) { is_expected.to be >= 1 }
      it { is_expected.to respond_to(:each, :each_with_index) }
      it { is_expected.to all be_a RightmoveBLM::Row }

      it 'allows access to data values via methods' do
        rows.each { |row| expect(row.address_1).not_to be_nil }
      end

      it 'allows access to the @attributes hash directly' do
        rows.each { |row| expect(row.attributes).to be_a(Hash) }
      end
    end

    describe '#initialize' do
      context 'with invalid file structure' do # rubocop:disable RSpec/NestedGroups
        let(:blm_data) { fixture('blm_with_wrong_structure.blm') }

        it do
          expect { blm }.to raise_error RightmoveBLM::ParserError,
                                        '<#RightmoveBLM::Document>: Unable to process document ' \
                                        'with this structure: could not detect HEADER marker. '
        end
      end
    end
  end

  context 'when creating a .blm file' do
    subject(:document) { RightmoveBLM::Document.from_array_of_hashes(data) }

    let(:data) do
      [{ field1: 'row 1 field 1 data', field2: 'row 1 field 2 data', field3: 'row 1 field 3 data' },
       { field1: 'row 2 field 1 data', field2: 'row 2 field 2 data', field3: 'row 2 field 3 data' }]
    end

    its(:header) { is_expected.to include({ 'property count': '2', version: '3' }) }
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
        expect(loaded_document.rows.map(&:to_h)).to eql data
      end

      it 'has a field definition' do
        expect(loaded_document.definition).to eql %w[field1 field2 field3]
      end
    end
  end
end
