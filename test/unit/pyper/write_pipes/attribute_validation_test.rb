require 'test_helper'

module Pyper::WritePipes
  class AttributeValidationTest < Minitest::Should::TestCase
    context "pipe" do
      context "with required attributes" do
        setup do
          @opts = { :required => [:foo, :bar] }
          @pipe = AttributeValidation.new(@opts)
        end

        should "raise when missing required attribute" do
          error_1 = assert_raises(AttributeValidation::Failure) do
            @pipe.pipe({})
          end
          assert_equal "Missing required attribute foo.", error_1.message

          error_2 = assert_raises(AttributeValidation::Failure) do
            @pipe.pipe({ :foo => "bar" })
          end
          assert_equal "Missing required attribute bar.", error_2.message

          # Nothing should be raised now.
          @pipe.pipe({ :foo => "bar", :bar => "qux" })
        end

        should "raise when required attribute is nil" do
          error = assert_raises(AttributeValidation::Failure) do
            @pipe.pipe({ :foo => nil, :bar => "qux"})
          end
          assert_equal "Missing required attribute foo.", error.message
        end
      end

      context "with allowed attributes" do
        setup do
          @opts = { :allowed => [:foo, :bar] }
          @pipe = AttributeValidation.new(@opts)
        end

        should "raise when attribute is not included in the whitelist" do
          error = assert_raises(AttributeValidation::Failure) do
            @pipe.pipe({ :foo => "foo", :bar => "bar", :baz => "baz" })
          end
          assert_equal "Attribute baz is not allowed.", error.message

          # Nothing should be raised now.
          @pipe.pipe({ :foo => "foo", :bar => "bar" })
        end

        should "allow all attributes when allowed option is not set" do
          pipe = AttributeValidation.new

          # Nothing should be raised now.
          pipe.pipe({ :foo => "foo", :bar => "bar", :baz => "baz" })
        end
      end


      context "with restricted attributes" do
        setup do
          @opts = {
            :restricted => {
              :bar => lambda { |value| ["qux", "bazqux"].include?(value) }
            }
          }
          @pipe = AttributeValidation.new(@opts)
        end

        should "raise when lambda returns false" do
          error = assert_raises(AttributeValidation::Failure) do
            @pipe.pipe({ :bar => "foo"})
          end
          assert_equal "Invalid value for attribute bar.", error.message

          # Nothing should be raised now.
          @pipe.pipe({ :bar => "qux" })
          @pipe.pipe({ :bar => "bazqux" })
        end
      end

      should "return attributes hash when all is well" do
        opts = {
          :allowed => [:foo, :bar],
          :required => [:foo],
          :restricted => {
            :bar => lambda { |value| ["bar", "foobar"].include?(value) }
          }
        }
        pipe = AttributeValidation.new(opts)
        attributes = { :foo => "bar", :bar => "foobar" }
        assert_equal attributes, pipe.pipe(attributes)
      end
    end
  end
end
