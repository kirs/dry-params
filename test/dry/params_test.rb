require 'test_helper'

class Dry::ParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dry::Params::VERSION
  end

  def test_validate_strict_success
    dry_params = Dry::Params.new({
      "user" => {
        "email" => "shatrov@me.com",
        "age" => "21",
        "ids" => ["1", "2", "3"]
      }
    })

    validated = dry_params.fetch(:user).validate do
      key(:email) { |email| email.filled? }

      key(:age) do |age|
        age.int? & age.gt?(18)
      end

      key(:ids) do |v|
        v.array? do
          v.each(&:int?)
        end
      end
    end

    assert_equal validated, {:email=>"shatrov@me.com", :age=>21, :ids=>[1, 2, 3]}
  end

  def test_validate_filter_success
    dry_params = Dry::Params.new({
      "user" => {
        "email" => "shatrov@me.com",
        "age" => 9,
        "ids" => ["1", "2", "3"]
      }
    })

    validated = dry_params.fetch(:user).validate(mode: :filter) do
      key(:email) { |email| email.filled? }

      key(:age) do |age|
        age.int? & age.gt?(18)
      end

      key(:ids) do |v|
        v.array? do
          v.each(&:int?)
        end
      end
    end

    assert_equal validated, {:email=>"shatrov@me.com", :ids=>[1, 2, 3]}
  end

  def test_validate_strict_error
    dry_params = Dry::Params.new({
      "user" => {
        "email" => "shatrov@me.com",
        "age" => nil,
        "ids" => []
      }
    })

    error = assert_raises do
      dry_params.fetch(:user).validate do
        key(:email) { |email| email.filled? }

        key(:age) do |age|
          age.int? & age.gt?(18)
        end

        key(:ids) do |v|
          v.array? do
            v.each(&:int?)
          end
        end
      end
    end

    assert_instance_of Dry::Params::ValidationError, error
  end
end
