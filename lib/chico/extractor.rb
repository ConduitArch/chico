module Chico
  # Extracts icons images (bmp / png) from an .ico file
  class Extractor

    def initialize(str)
      @sio = StringIO.new(str, 'rb')
      @entries = []
      parse_icondir
    end

    private

    def parse_icondir
      unless [read(2), read(2)] == [0, 1]
        raise "Not a valid icon"
      end
      keys = [:width, 1, :height, 1, :colors, 1, :reserved, 1, :planes, 2, :bit_count, 2, :size, 4, :offset, 4]
      count = read 2 # number of icons in this file
      count.times do # read the icon list
        entry = {}
        keys.each_slice(2) {|pair| entry[pair[0]] = read(pair[1]) }
        [:width, :height, :colors].each {|key| entry[key] = 256 if entry[key] == 0 }
        @entries << entry
      end
    end

    def parse_entries

    end

    # detect a png header
    def is_png?
      pos0 = @sio.pos
      val = @sio.read(8).unpack('H*').first
      @sio.pos = pos0
      val == "89504e470d0a1a0a"
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