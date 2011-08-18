require 'chico/extractor'
require 'chico/bitmapper'
require 'chico/fetcher'

module Chico

  def self.extract_from_file(filepath, dest_dir, options={})
    ex = Chico::Extractor.new(IO.read(filepath))
    basename = File.basename(filepath, File.extname(filepath))
    ex.entries.each do |entry|
      ext = "#{entry[:width]}x#{entry[:height]}"
      content = ex.image_for(entry)
      File.open(File.join(dest_dir, "#{basename}.#{ext}.png"), 'wb') do |f|
        f.write content
      end
    end
  end
end
