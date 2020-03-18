# Transliterator

The Transliterator module provides the ability to transliterate UTF-8 strings into pure ASCII so that they can be safely displayed in URL slugs or file names.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cadmium_transliterator:
       github: cadmiumcr/transliterator
   ```

2. Run `shards install`

## Usage

```crystal
require "cadmium_transliterator"
```

```crystal
transliterator = Cadmium.transliterator

transliterator.transliterate("Привет")
# => "Privet"

transliterator.transliterate("你好朋友")
# => "Ni Hao Peng You"

# With the string extension

"މިއަދަކީ ހދ ރީތި ދވހކވ".transliterate
# => "mi'adhakee hdh reethi dhvhkv"

"こんにちは、友人".transliterate
# => konnichiwa, You Ren
```

## Contributing

1. Fork it (<https://github.com/cadmiumcr/transliterator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
