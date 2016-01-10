# Dry::Params

`Dry::Params` brings all features of [`Dry::Validation`](https://github.com/dryrb/dry-validation)
into your Rails controller and provides an API to validate request params with `Dry::Validation`

[Read more about *why* dry-validation is better then Rails Strong Params](http://solnic.eu/2015/12/07/introducing-dry-validation.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry-params'
```

And add dry-params helper to your controller:

```ruby
# app/controllers/application_controller
class ApplicationController < ActionController::Base
  # ...
  include Dry::Params::ActionControllerHelper
end
```

## Usage

Describe request parameters validation rules in controller just like with Strong Parameters:

```ruby
class UsersController < ApplicationController
  def user_params
    dry_params.fetch(:user).validate do
      key(:name) { |f| f.filled? }
      key(:age) { |f| f.int? }
      key(:account_id) { |f| f.int? }
      key(:group_ids) { |f| f.array? do
        v.each(&:int?)
      end
    end
  end
end
```

These rules describe a hash:

```json
{
  "users" =>
    {
      "name" => "Kir",
      "age" => "21",
      "account_id" => "1",
      "group_ids" => ["1", "3", "5"]
    }
}
```

`Dry::Params#validate` will return the following coerced and validated hash:

```ruby
{
  name: "Kir",
  age: 21,
  account_id: 1,
  group_ids: [1, 3, 5]
}
```

[Read more about dry-validation rules](https://github.com/dryrb/dry-validation/wiki/Basic)

Dry::Params provides two validation modes: `strict` and `filter`.

## Strict validation

This is a default validation mode.
It checks request params to *strictly* satisfy dry-validation rules.
If params do not satisfy, Dry::Params::ValidationError will be raised.

## Filter validation

Filter validation returns hash with only keys that pass validation rules.

```
dry_params.fetch(:user).validate do
  key(:name) { |f| f.filled? }
  key(:age) { |f| f.int? }
  key(:account_id) { |f| f.int? }
  key(:group_ids) { |f| f.array? do
    v.each(&:int?)
      end
  end
end
```

If user passes the following request parameters:

```json
{
  "users" =>
    {
      "name" => "Kir",
      "age" => "not-an-age",
      "account_id" => "fff",
      "group_ids" => "not-an-array"
    }
}
```

`validate` will return a hash with only one valid key: `name`.

```ruby
{
  name: "Kir",
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dry-params.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
