[![Build Status](https://travis-ci.org/funbox/smppex.svg?branch=master)](https://travis-ci.org/funbox/smppex)
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](http://hexdocs.pm/smppex)
[![Version](https://img.shields.io/hexpm/v/smppex.svg)](https://hex.pm/packages/smppex)
[![Coverage Status](https://coveralls.io/repos/github/funbox/smppex/badge.svg?branch=master&1504538909)](https://coveralls.io/github/funbox/smppex?branch=master)
[![Inline docs](http://inch-ci.org/github/funbox/smppex.svg?branch=master)](http://inch-ci.org/github/funbox/smppex)

<a href="https://funbox.ru">
  <img src="http://funbox.ru/badges/sponsored_by_funbox_compact.svg" alt="Sponsored by FunBox" width=250 />
</a>

# Smppex

SMPP 3.4 protocol and framework implementation in [Elixir](http://elixir-lang.org)

See [Examples](https://hexdocs.pm/smppex/SMPPEX.html)

## Documentation

API documentation is available at http://hexdocs.pm/smppex

## Live Demo

There is a simple online demonstrational MC (SMPP server) at http://smppex.rubybox.ru

## Installation

The package can be installed as:

  1. Add `smppex` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:smppex, "~> 2.0"}]
  end
  ```

  2. Ensure `smppex` is started before your application:

  ```elixir
  def application do
    [applications: [:smppex]]
  end
  ```

## LICENSE

This software is licensed under [MIT License](LICENSE).
