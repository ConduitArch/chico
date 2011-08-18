require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Chico" do
  describe "Bitmapper" do

    describe "#parse_dib" do
      before(:all) do
        class Chico::Bitmapper
          attr_reader :offset, :width, :height, :bits_per_pixel, :image_size
        end
        raw16 = load_res_file('microsoft.16x16.raw')
        @bitmapper16 = Chico::Bitmapper.new(raw16)
        @bitmapper16.parse_dib
        raw32 = load_res_file('microsoft.32x32.raw')
        @bitmapper32 = Chico::Bitmapper.new(raw32)
        @bitmapper32.parse_dib
      end

      it "reads the correct dib offset" do
        @bitmapper16.offset.should == 40
        @bitmapper32.offset.should == 40
      end

      it "extracts the correct width" do
        @bitmapper16.width.should == 16
        @bitmapper32.width.should == 32
      end

      it "extracts the correct height" do
        @bitmapper16.height.should == 16
        @bitmapper32.height.should == 32
      end
    end
  end
end
