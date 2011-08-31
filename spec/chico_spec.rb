require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Chico" do
  path = File.expand_path("res/temp", File.dirname(__FILE__))
  it "Extracts ico bmps as pngs" do
    filepath = File.join(File.dirname(__FILE__), 'res', "msn.ico")
    ex = Chico::Extractor.new(IO.read(filepath))
    basename = File.basename(filepath, File.extname(filepath))
    ex.entries.each do |entry|
      ext = "#{entry[:width]}x#{entry[:height]}"
      content = ex.image_for(entry)
      if !File.directory? path
        Dir.mkdir(path)
      end
      File.open(File.join(File.dirname(__FILE__), 'res/temp', "#{basename}.#{ext}.png"), 'wb') do |f|
        f.write content
      end
    end
  end

  it "Extracts icon from website markup" do
    imageDir = Chico::extract_from_url('http://video.foxnews.com', path)
    imageDir.length.should == 1
  end
  it "Extracts icon from website default favicon" do
    imageDir = Chico::extract_from_url('http://microsoft.com', path)
    imageDir.length.should == 2
  end
end
