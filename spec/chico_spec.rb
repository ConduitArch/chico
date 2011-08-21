require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Chico" do
  it "Extracts ico bmps as pngs" do
    filepath = File.join(File.dirname(__FILE__), 'res', "msn.ico")
    ex = Chico::Extractor.new(IO.read(filepath))
    basename = File.basename(filepath, File.extname(filepath))
    ex.entries.each do |entry|
      ext = "#{entry[:width]}x#{entry[:height]}"
      content = ex.image_for(entry)
      if !File.directory? "res/temp"
        Dir.mkdir("res/temp")
      end
      File.open(File.join(File.dirname(__FILE__), 'res/temp', "#{basename}.#{ext}.png"), 'wb') do |f|
        f.write content
      end
    end
  end
end
