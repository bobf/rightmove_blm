# frozen_string_literal: true

RSpec.describe RightmoveBLM::Document do
  subject(:document) { described_class.new(**options) }

  let(:options) { { data: [] } }

  it { is_expected.to be_a described_class }

  describe '#inspect' do
    subject(:inspect) { document.inspect }

    context 'with name' do
      let(:options) { { data: [], name: 'my document.blm' } }

      it 'includes name in parser error' do
        expect { inspect }
          .to raise_error RightmoveBLM::ParserError,
                          '<#RightmoveBLM::Document document="my document.blm">: ' \
                          'Unable to parse document: could not detect start marker. '
      end
    end
  end
end
