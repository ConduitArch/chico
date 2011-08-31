require 'gogetter'
require 'nokogiri'
module Chico

  # How it works:
  # When given a domain w/o a path, try to find /favicon.ico
  # If not found (or given a path), load the home page and search for one of:
  # * <link rel="shortcut icon" href="http://example.com/myicon.ico" />
  # * <link rel="icon" type="image/vnd.microsoft.icon" href="http://example.com/image.ico" />
  # * <link rel="icon" type="image/png" href="http://example.com/image.png" />
  # * <link rel="icon" type="image/gif" href="http://example.com/image.gif" />
  # If given a path, and the above didn't work, retry on the domain's index page
  class Fetcher
    attr_reader :url, :searched_icon

    def initialize(url)
      @url = url
      @uri = GoGetter.parse_url @url
    end

    def fetch(uri=@uri)
      if @uri.path == '/'
        fetch_default || fetch_link_on_page(@url)
      else
        # try to find a favicon for the specific path first
        if path = fetch_link_on_page(@url)
          fetch_icon path
        else
        # if failed, try again with the root path

        end
      end
    end

    private

    def fetch_default
      fetch_icon '/favicon.ico'
    end

    def fetch_icon(path)
      uri = @uri.clone
      uri.path = path
      res = GoGetter.get uri
      if res.is_a? Net::HTTPOK
        @searched_icon = uri.path
        @raw = res.body
      end
    end

    ICON_XPATHS = [
      "link[@rel='shortcut icon']",
      "link[@rel='icon']"
    ]
    def fetch_link_on_page(url)
      icon_url = find_link_on_page url
      icon_url = Fetcher.make_relative(icon_url)
      if !icon_url.to_s.empty?
        fetch_icon icon_url
      end
    end

    def find_link_on_page(url)
      res = GoGetter.get url
      if res.is_a? Net::HTTPOK
        doc = Nokogiri res.body
        ICON_XPATHS.each do |xpath|
          if link = doc.at(xpath)
            return link[:href]
          end
        end
        return ""
      end
    end

    def self.make_relative(url)
      URI.parse(url).path
    end

  end
end