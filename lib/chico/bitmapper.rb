# Unpack an ico bitmap
module Chico
  class Bitmapper
    attr_reader :pixels

    def initialize(data, ico_direntry=nil)
        @data = data
      @ico_direntry = ico_direntry
    end

    def bitmap
      parse_dib
      @pixels = case @bits_per_pixel
                when 0..8 then bitmap8
                when 24 then bitmap24
                when 32 then bitmap32
                else raise "Unable to handle #{@bits_per_pixel} bits per pixel"
                end
    end

    # Returns a String with the pixels, 
    # rgba, one byte per channel
    def to_stream
      sio = StringIO.new
      @pixels.each {|p| sio.putc(p) }
      sio.pos = 0
      sio
    end

    def parse_dib
      @offset = @data[0, 4].unpack('V').first
      unless @offset == 40
        raise "Unknown BMP format" # can't handle an ICO where the dib isn't 40 bytes
      end

      @width = @ico_direntry[:width] || @data[4, 4].unpack('V').first
      @height = @ico_direntry[:height] || @data[8, 4].unpack('V').first
      @bits_per_pixel = @data[14, 2].unpack('v').first
      @image_size = @data[24, 4].unpack('V').first
      if @image_size == 0
        @image_size = @width * @height * @bits_per_pixel / 8
      end
    end

    def bitmap8
      # assemble the color palette
      color_count = 2 ** @bits_per_pixel
      raw_colors = (0...color_count).map {|i| @data[@offset + 4 * i, 4].unpack('CCCC') }
      #puts "raw colors: " + raw_colors.inspect
      # the RGBQUAD for each palette color is (blue, green, red, reserved)
      palette = raw_colors.map {|raw| raw.values_at(2, 1, 0) }
      # get the XorMap bits
      xor_data_bits = (0...@image_size).map {|i|
        @data[@offset + 4 * color_count + i].unpack('B8').first.split('').map(&:to_i)
      }.flatten
      # get the AndMap bits
      and_row_size = ((@width + 31) >> 5) << 2
      and_data_bits = (0...(and_row_size * @height)).map {|i|
        @data[@offset + 4 * color_count + @image_size].unpack('B8').first.split('').map(&:to_i)
      }.flatten
      get_pixel = ->(x, y) {
        if and_data_bits[(@height - y - 1) * and_row_size * 8 + x] == '1'
          [0, 0, 0, 0] # transparent
        else
          # use the xor value, made solid
          bits = xor_data_bits[@bits_per_pixel * ((@height - y - 1) * @width + x), @bits_per_pixel]
          palette[bits.reduce(0) {|acc, bit| 2 * acc + bit }] + [255]
        end
      }
      (0...@height).map { |y|
        (0...@width).map { |x|
          get_pixel.call(x, y)
        }
      }.flatten
    end

    def bitmap32
      (0...@height).to_a.reverse.map { |y|
        (0...@width).map { |x|
          pos = @offset + 4 * (y * @width + x)
          #puts "data[#{pos}] = #{@data[pos]}"
          @data[@offset + 4 * (y * @width + x), 4].unpack('CCCC').values_at(2, 1, 0, 3)
        }
      }.flatten
    end

    def bitmap24
      (0...@height-1).to_a.reverse.map { |y|
        (0...@width).map { |x|
          @data[@offset + 3 * (y * @width + x), 3].unpack('CCC').values_at(2, 1, 0) + [255]
        }
      }.flatten
    end

  end
end
