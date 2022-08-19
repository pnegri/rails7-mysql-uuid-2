require 'uuidtools'

module UUIDTools
  class UUID
    alias id raw

    # duck typing activerecord 3.1 dirty hack )
    def gsub(*)
      self
    end

    def quoted_id
      s = raw.unpack1('H*')
      "x'#{s}'"
    end

    def as_json(_options = nil)
      hexdigest.upcase
    end

    def to_param
      hexdigest.upcase
    end

    def to_liquid
      to_param
    end

    def to_json(_options = nil)
      "\"#{to_param}\""
    end

    def value_for_database
      raw
    end

    def self.serialize(value)
      case value
      when self
        value
      when String
        parse_string value
      end
    end

    def bytesize
      16
    end

    def shorten
      MysqlUUIDType::ShortUUIDTools.shorten(to_s)
    end

    def self.parse_string(str)
      return nil if str.length.zero?

      case str.length
      when 36
        parse str
      when 32
        parse_hexdigest str
      when 16
        parse_raw str
      else
        parse MysqlUUIDType::ShortUUIDTools.expand(str)
      end
    end
  end
end

class String
  def to_uuid
    UUIDTools::UUID.parse_string(self)
  end
end

module MysqlUUIDType
  module ShortUUIDTools
    DEFAULT_BASE62 = %w[
      0 1 2 3 4 5 6 7 8 9
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
      a b c d e f g h i j k l m n o p q r s t u v w x y z
    ].freeze

    def self.shorten(uuid, alphabet = DEFAULT_BASE62)
      return nil unless uuid && !uuid.empty?

      decimal_value = uuid.split('-').join.to_i(16)
      convert_decimal_to_alphabet(decimal_value, alphabet)
    end

    def self.convert_decimal_to_alphabet(decimal, alphabet = DEFAULT_BASE62)
      alphabet = alphabet.to_a
      radix = alphabet.length
      i = decimal.to_i
      out = []
      return alphabet[0] if i.zero?

      loop do
        break if i.zero?

        out.unshift(alphabet[i % radix])
        i /= radix
      end
      out.join
    end

    def self.convert_alphabet_to_decimal(word, alphabet = DEFAULT_BASE62)
      num = 0
      radix = alphabet.length
      word.chars.to_a.reverse.each_with_index do |char, index|
        num += alphabet.index(char) * (radix**index)
      end
      num
    end

    def self.encode(number, alphabet = DEFAULT_BASE62)
      convert_decimal_to_alphabet(number, alphabet)
    end

    def self.decode(word, alphabet = DEFAULT_BASE62)
      convert_alphabet_to_decimal(word, alphabet)
    end

    def self.expand(short_uuid, alphabet = DEFAULT_BASE62)
      return nil unless short_uuid && !short_uuid.empty?

      decimal_value = convert_alphabet_to_decimal(short_uuid, alphabet)
      uuid = decimal_value.to_s(16).rjust(32, '0')
      [
        uuid[0..7],
        uuid[8..11],
        uuid[12..15],
        uuid[16..19],
        uuid[20..31]
      ].join('-')
    end
  end
end

class UUID < ActiveModel::Type::Binary
  def type
    :uuid
  end

  def serialize(value)
    return if value.blank?

    ActiveRecord::Type::Binary::Data.new(
      UUIDTools::UUID.serialize(value).value_for_database
    )
  end

  def deserialize(value)
    return nil if value.nil?

    UUIDTools::UUID.serialize(value.to_s).shorten.to_s
  end

  def type_cast_for_schema(value)
    super
  end

  def cast(value)
    return if value.nil?

    UUIDTools::UUID.serialize(value).shorten.to_s
  end
end
