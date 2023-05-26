# Rightmove BLM

A simple parser for the _Rightmove_ `.blm` [Bulk Load Mass](https://www.rightmove.co.uk/ps/pdf/guides/RightmoveDatafeedFormatV3iOVS_1.6.pdf) file format.

Originally forked from the [BLM](https://github.com/robotmay/blm) gem by Robert May.

This library is not affiliated with or endorsed by _Rightmove Plc_ in any way.

## Usage

### Loading a BLM file

#### RightmoveBLM::Document

Load a BLM file by passing the `source` parameter to `RightmoveBLM::Document.new`:

```ruby
blm = RightmoveBLM::Document.new(source: File.read('example_data.blm'))
```

`RightmoveBLM::Document.new` also receives an optional argument `name` which is recommended for all documents to assist in tracking errors when processing many documents, e.g.:

```ruby
blm = RightmoveBLM::Document.new(source: File.read('example_data.blm'), name: 'example_data.blm')
```

This name will be included in all parser error messages.

The returned `RightmoveBLM::Document` instance implements:

* `#header` - the header containing information about the document's structure.
* `#definition` - the field list contained in the document.
* `#rows` - an array of `RightmoveBLM::Row` objects.
* `#valid?` - `true` if no rows have errors, `false` if any rows have errors.
* `#errors` - all error messages for all invalid rows.
* `#version` - the version of the document format as a string (e.g. `'3'`).
* `#international?` - `true` if document meets the [Rightmove International](https://www.rightmove.co.uk/ps/pdf/guides/RightmoveDatafeedFormatV3iOVS_1.6.pdf) specification, `false` otherwise.

#### RightmoveBLM::Row

`RightmoveBLM::Row` implements:

* `#valid?` - `true` if no errors were encountered, false otherwise.
* `#errors` - an array of error strings (empty if no errors present).
* `#to_h` (or `#attributes`) - a hash of row attributes (`nil` if errors encountered).
* `#method_missing` - allows accessing row attributes by dot notation (e.g. `row.address_1`).

#### Example

```ruby
blm.data.select(&:valid?).each do |row|
  puts row.address_1
  puts row.to_h
end

blm.data.reject(&:valid?).each do |row|
  puts "Errors: #{row.errors.join(', ')}"
end
```

### Writing BLM data

An array of _hashes_ can be converted to a `RightmoveBLM::Document` object which can then be used to create an output string by calling `#to_blm`.

The keys from the first _hash_ in the provided _array_ are used to provide the field definition. All _hashes_ **must** contain the same keys.

```ruby
document = RightmoveBLM::Document.from_array_of_hashes([{ field1: 'foo', field2: 'bar' }, { field1: 'baz', field2: 'foobar' }])
File.write('my_data.blm', document.to_blm)
```
