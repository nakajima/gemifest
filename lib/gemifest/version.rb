module Gemifest
  class Gem
    class Version
      def initialize(line)
        @line = line
      end

      def digits
        to_s.split('.').map { |d| d.to_i }
      end

      def ==(other)
        digits == other.digits
      end

      def >(other)
        compare_with(other, returns=true) do |this, that|
          this > that
        end
      end

      def <(other)
        compare_with(other, returns=true) do |this, that|
          this < that
        end
      end

      def >=(other)
        compare_with(other, returns=false) do |this, that|
          this < that
        end
      end

      def <=(other)
        compare_with(other, returns=false) do |this, that|
          this > that
        end
      end

      def to_s
        @line.scan(/\(?([\d\.]+)[\),]?/).first.to_s
      end

      private

      def compare_with(other, result)
        digits.each_with_index do |num, i|
          return result if yield(num, other.digits[i])
        end ; not result
      end
    end
  end
end
