require 'test_helper'

module Pyper::WritePipes
  class AttributeValidationTest < Minitest::Should::TestCase
    context "initialize" do
      should "raise when required_attributes is something other than an Array" do
        error = assert_raises(ArgumentError) do
          AttributeValidation.new({})
        end

        expected = "Expected required_arguments to be an Array. Got Hash"
        assert_equal expected, error.message
      end
    end

    context "pipe" do
      setup do
        @required_attrs = [:foo, :bar]
        @pipe = AttributeValidation.new(@required_attrs)
      end

      should "raise when missing required attribute" do
        error1 = assert_raises(AttributeValidation::FailedValidation) do
          @pipe.pipe({})
        end
        assert_equal "Missing required attribute foo.", error1.message

        error2 = assert_raises(AttributeValidation::FailedValidation) do
          @pipe.pipe({ :foo => "bar" })
        end
        assert_equal "Missing required attribute bar.", error2.message

        # Nothing should be raised now.
        @pipe.pipe({ :foo => "bar", :bar => "foo" })
      end

      should "raise when required attribute is nil" do
        error1 = assert_raises(AttributeValidation::FailedValidation) do
          @pipe.pipe({ :foo => nil, :bar => "foo"})
        end
        assert_equal "Missing required attribute foo.", error1.message
      end

      should "return attributes hash when all is well" do
        attrs = { :foo => "bar", :bar => "foo" }
        assert_equal attrs, @pipe.pipe(attrs)
      end
    end

  end
end
