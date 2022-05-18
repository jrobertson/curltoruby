#!usr/bin/env ruby

# file: curltoruby.rb

# description: Inspired by jhawthorn's curl-to-ruby.
#              see https://jhawthorn.github.io/curl-to-ruby/


require 'lineparser'
require 'clipboard'


class CurlToRuby

  def initialize(s)
    @h = parse(s)
    @s = build_code(@h)
  end

  def to_h()
    @h
  end

  def to_s()

    Clipboard.copy @s
    puts 'copied to clipboard'
    @s

  end

  private

  def build_code(h)

s=<<EOF
require 'net/http'
require 'uri'

uri = URI.parse('#{h[:url]}')
request = Net::HTTP::Post.new(uri)
request.body = '#{h[:body]}'
request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
EOF

    headers = @h[:header].map do |x|
      key, value = x.split(/: +/,2)
      "request[\"%s\"] = \"%s\"" % [key, value.gsub(/"/,'\"')]
    end.join("\n")

s2=<<EOF
req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
EOF

    s + "\n" + headers + "\n" + s2

  end

  def parse(raws)

    s = raws.gsub(/^\s+/,'')

    patterns = [
      [:root, /(?<=curl ')([^']+)/, :url],
      [:all, /-H '([^']+)/, :header],
      [:all, /--data-raw '([^']+)/, :body]
    ]

    lp = LineParser.new patterns
    lp.parse s
    lp.to_h

  end

end
