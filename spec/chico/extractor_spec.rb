require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Chico" do
  describe "Extractor" do

    describe "#initialize" do
      it "parses the icondir entries" do
        ex = Chico::Extractor.new(load_icon_file('microsoft'))
        ex.should have_exactly(2).entries
        ex.entries[0][:width].should == 32
        ex.entries[1][:width].should == 16
      end
    end

    describe "#num_images" do
      it "returns the number of images contained in the ico file" do
        ex = Chico::Extractor.new(load_icon_file('microsoft'))
        ex.num_images.should == 2
      end
    end

    describe "#image_sizes" do
      it "returns a sorted list of contained image width,height pairs" do
        ex = Chico::Extractor.new(load_icon_file('microsoft'))
        ex.image_sizes.should eql([[16,16],[32,32]])
      end
    end


  end
end