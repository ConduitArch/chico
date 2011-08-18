module Chico
  # Extracts icons images (bmp / png) from an .ico file
  class Extractor
    attr_reader :entries

    def initialize(bin)
      @sio = StringIO.new(bin, 'rb')
      @entries = []
      parse_icondir
    end

    def num_images
      @entries.size
    end

    # Returns the sizes of the images packed in this icon, as width, height pairs,
    # sorted from smallest to largest width
    def image_sizes
      @entries.map {|e| [e[:width], e[:height]] }.sort
    end

    # Add support for retrieving images by their size, e.g. 32x32, 16x16, etc.
    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^(\d+)x(\d+)$/
        image_by_size $1, $2
      else
        super
      end
    end

    def largest
      w, h = image_sizes.last
      self.send "#{w}x#{h}".to_sym
    end

    def smallest
      w, h = image_sizes.first
      self.send "#{w}x#{h}".to_sym
    end

    def image_for(entry)
      extract_image(entry)
    end

    private

    def parse_icondir
      unless [read(2), read(2)] == [0, 1]
        raise "Not a valid icon"
      end
      count = read 2 # number of icons in this file
      count.times { parse_icondirentry }
    end

    ICONDIRENTRY_KEYS = [:width, 1, :height, 1, :colors, 1, :reserved, 1, :planes, 2, :bit_count, 2, :size, 4, :offset, 4].freeze

    def parse_icondirentry
      entry = {}
      ICONDIRENTRY_KEYS.each_slice(2) {|pair| entry[pair[0]] = read(pair[1]) }
      [:width, :height, :colors].each {|key| entry[key] = 256 if entry[key] == 0 }
      @entries << entry
    end

    # Extract the first image of the given size, or returns nil if no such image is found
    def image_by_size(width, height)
      if entry = @entries.find {|e| e[:width] == width && e[:height] == height }
        extract_image entry
      end
    end

    # Extract the image file that corresponds to the given icondirentry
    def extract_image(entry)
      @sio.pos = entry[:offset]
      raw = @sio.read(entry[:size])
      if png?(raw)
        raw
      else
        bmp = Bitmapper.new(raw, entry)
        bmp.bitmap
        ChunkyPNG::Image.from_rgba_stream(entry[:width], entry[:height], bmp.to_stream)
      end
    end

    # detect a png header
    def png?(raw)
      raw.slice(0, 8).unpack('H*').first == "89504e470d0a1a0a"
    end

    # Read len bytes from @sio and unpack them
    def read(len)
      format = case len
        when 1 then 'C'
        when 2 then 'S'
        when 4 then 'L'
       end

      @sio.read(len).unpack(format).first
    end

  end
end
