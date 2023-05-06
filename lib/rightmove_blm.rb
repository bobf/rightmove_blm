# frozen_string_literal: true

require 'rightmove_blm/document'
require 'rightmove_blm/row'

require 'time'

# Rightmove BLM (Bulk Load Mass) data format parsing tools.
# https://www.rightmove.co.uk/ps/pdf/guides/RightmoveDatafeedFormatV3iOVS_1.6.pdf
module RightmoveBLM
  class Error < StandardError; end
  class ParserError < Error; end
end
