require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Chico" do
  describe "Fetcher" do
    describe "#fetch" do
      it "founds website with default favicon" do
        fetcher = Chico::Fetcher.new('http://microsoft.com/')
        fetcher.fetch().length.should > 0
        fetcher.searched_icon.should == "/favicon.ico"
      end
      it "founds favicon for website without default favicon" do
        fetcher = Chico::Fetcher.new('http://video.foxnews.com')
        fetcher.fetch().length.should > 0
        fetcher.searched_icon.should == '/images/foxnews/favicon.ico'
      end
    end
    describe "#make_relative" do
      it "returns the relative part from full url" do
        Chico::Fetcher.make_relative('http://video.foxnews.com/icon.ico').should == '/icon.ico'
      end
      it "returns the param from relative url" do
        Chico::Fetcher.make_relative('/icon.ico').should == '/icon.ico'
      end
    end
  end
end
