require 'test_helper'

module Pyper::WritePipes
  class AttributeValidationTest < Minitest::Should::TestCase
    context "pipe" do
      setup do
        @opts = {
          :presence => [:foo, :bar],
          :inclusion => { :bar => ["qux", "bazqux"] }
        }
        @pipe = AttributeValidation.new(@opts)
      end

      should "raise when missing required attribute" do
        error1 = assert_raises(AttributeValidation::Failure) do
          @pipe.pipe({})
        end
        assert_equal "Missing required attribute foo.", error1.message

        error2 = assert_raises(AttributeValidation::Failure) do
          @pipe.pipe({ :foo => "bar" })
        end
        assert_equal "Missing required attribute bar.", error2.message

        # Nothing should be raised now.
        @pipe.pipe({ :foo => "bar", :bar => "qux" })
      end

      should "raise when required attribute is nil" do
        error1 = assert_raises(AttributeValidation::Failure) do
          @pipe.pipe({ :foo => nil, :bar => "qux"})
        end
        assert_equal "Missing required attribute foo.", error1.message
      end

      should "raise when attribute value is invalid" do
        error1 = assert_raises(AttributeValidation::Failure) do
          @pipe.pipe({ :foo => "bar", :bar => "foo"})
        end
        assert_equal "Invalid value for attribute bar.", error1.message
      end

      should "return attributes hash when all is well" do
        attrs = { :foo => "bar", :bar => "bazqux" }
        assert_equal attrs, @pipe.pipe(attrs)
      end
    end
  end
end
