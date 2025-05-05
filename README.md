# plugin-template.nvim

[![Integration][integration-badge]][integration-runs]

This plugin will toggle between syntaxes in order to more easily switch between two equivalent formats.

```js
// a
const myFunc = () => 'some return value';

// b
const myFunc = () => {
  return 'some return value'
};
```

## Installation

### LazyNvim

```lua
{
  'adaviloper/juggle',
  ft = { -- support for current files
    'javascript',
    'typescript',
    'php',
    'vue',
  },
  config = function ()
    require('juggle').setup({})
  end
}
```


## Usage

This plugin exposes a single command for you to bind to whichever keymap you prefer.

| Command | Description |
| --- | --- |
| `ToggleSyntax` | Toggle between two similar, supported syntaxes |
| `Extract <type>` | In visual mode, extract the selected text into a separate node of <type> |

### Extract Types
- `variable` : Extract selected text to a variable

## Supported Syntaxes

### Javascript

*Simple arrow style function to block arrow style*

```js
// a
const myFunc = () => 'some return value';

// b
const myFunc = () => {
  return 'some return value'
};
```


### PHP

*Array index access to property access*

```php
<?php
// a
$f = $myObject->foo;

// b
$f = $myObject['foo'];
```

### Typescript

*Simple arrow style function to block arrow style*

```ts
// a
const myFunc = (): string => 'some return value';

// b
const myFunc = (): string => {
  return 'some return value'
};
```


### Vue

Inherits the functionality from Javascript/Typescript based on the `<script>` tag's `lang` attribute.


## Testing

This uses [busted][busted], [luassert][luassert] (both through
[plenary.nvim][plenary]) and [matcher_combinators][matcher_combinators] to
define tests in `test/spec/` directory. These dependencies are required only to
run tests, that's why they are installed as git submodules.

Make sure your shell is in the `./test` directory or, if it is in the root directory,
replace `make` by `make -C ./test` in the commands below.

To init the dependencies run

```bash
$ make prepare
```

To run all tests just execute

```bash
$ make test
```

If you have [entr(1)][entr] installed you may use it to run all tests whenever a
file is changed using:

```bash
$ make watch
```

In both commands you myght specify a single spec to test/watch using:

```bash
$ make test SPEC=spec/my_awesome_plugin/my_cool_module_spec.lua
$ make watch SPEC=spec/my_awesome_plugin/my_cool_module_spec.lua
```

## Github actions

An Action will run all the tests and the linter on every commit on the main
branch and also on Pull Request. Tests will be run using 
[stable and nightly][neovim-test-versions] versions of Neovim.

[lua]: https://www.lua.org/
[entr]: https://eradman.com/entrproject/
[luarocks]: https://luarocks.org/
[busted]: https://olivinelabs.com/busted/
[luassert]: https://github.com/Olivine-Labs/luassert
[plenary]: https://github.com/nvim-lua/plenary.nvim
[matcher_combinators]: https://github.com/m00qek/matcher_combinators.lua
[integration-badge]: https://github.com/m00qek/plugin-template.nvim/actions/workflows/integration.yml/badge.svg
[integration-runs]: https://github.com/m00qek/plugin-template.nvim/actions/workflows/integration.yml
[neovim-test-versions]: .github/workflows/integration.yml#L17
[help]: doc/my-awesome-plugin.txt
