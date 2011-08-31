require 'chico/extractor'
require 'chico/bitmapper'
require 'chico/fetcher'
require 'uri'

module Chico

  def self.extract_from_file(filepath, dest_dir, options={})
    ex = Extractor.new(IO.read(filepath))
    basename = File.basename(filepath, File.extname(filepath))
    ex.entries.each do |entry|
      ext = "#{entry[:width]}x#{entry[:height]}"
      content = ex.image_for(entry)
      File.open(File.join(dest_dir, "#{basename}.#{ext}.png"), 'wb') do |f|
        f.write content
      end
    end
  end

  def self.extract_from_url(url, dest_dir, options={})
    fetcher = Fetcher.new(url)
    ex = Extractor.new(fetcher.fetch)
    write_to_files(ex, dest_dir, URI.parse(url).host)
  end

  private
    def self.write_to_files(extractor, dest_dir, basename)
      extractor.entries.each do |entry|
        ext = "#{entry[:width]}x#{entry[:height]}"
        content = extractor.image_for(entry)
        File.open(File.join(dest_dir, "#{basename}.#{ext}.png"), 'wb') do |f|
          f.write content
        end
      end
    end
end
