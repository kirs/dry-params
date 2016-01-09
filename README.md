# Dry::Params

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dry/params`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

```ruby
class UsersController < ApplicationController
  def user_params
    dry_params.fetch(:user).validate
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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dry-params.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
