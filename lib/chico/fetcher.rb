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
    attr_reader :url

    def initialize(url)
      @url = url
      @uri = GoGetter.parse_url @url
    end

    def fetch(uri=@uri)
      if @uri.path == '/'
        fetch_default || find_link_on_page(@url)
      else
        # try to find a favicon for the specific path first
        if path = find_link_on_page @url
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
      if res.is_a? HTTPOK
        @raw = res.body
      end
    end

    ICON_XPATHS = [
      "//head/link[@rel='shortcut icon']",
      "//head/link[@rel='icon'][@type='image/vnd.microsoft.icon']",
      "//head/link[@rel='icon'][@type='image/png']",
      "//head/link[@rel='icon'][@type='image/gif']",
    ]

    def find_link_on_page(url)
      res = GoGetter.get url
      if res.is_a? HTTPOK
        doc = Nokogiri res.body
        ICON_XPATHS.each do |xpath|
          if link = doc.at xpath
            return link[:href]
          end
        end
      end
    end

  end
end