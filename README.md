# Rightmove BLM

A simple parser for the _Rightmove_ `.blm` [Bulk Load Mass](https://www.rightmove.co.uk/ps/pdf/guides/RightmoveDatafeedFormatV3iOVS_1.6.pdf) file format.

Originally forked from the [BLM](https://github.com/robotmay/blm) gem by Robert May.

This library is not affiliated with or endorsed by _Rightmove Plc_ in any way.

## Usage

### Loading a BLM file

Load a BLM file by passing the `source` parameter to `RightmoveBLM::Document.new`:

```ruby
blm = RightmoveBLM::Document.new(source: File.read('example_data.blm'))
```

The returned `RightmoveBLM::Document` instance implements:

* `#header` - the header containing information about the document's structure.
* `#definition` - the field list contained in the document.
* `#data` - an array of `RightmoveBLM::Row` objects (use dot notation to access fields, e.g. `row.foo` to access the "foo" field).

`RightmoveBLM::Row` also implements `#to_h` which provides a _Hash_ of the row data.

#### Example

```ruby
blm.data.each do |row|
  puts row.address_1
  puts row.to_h
end
```

### Writing BLM data

An array of _hashes_ can be converted to a `RightmoveBLM::Document` object which can then be used to create an output string by calling `#to_blm`.

The keys from the first _hash_ in the provided _array_ are used to provide the field definition. All _hashes_ **must** contain the same keys.

```ruby
document = RightmoveBLM::Document.from_array_of_hashes([{ field1: 'foo', field2: 'bar' }, { field1: 'baz', field2: 'foobar' }])
File.write('my_data.blm', document.to_blm)
```
