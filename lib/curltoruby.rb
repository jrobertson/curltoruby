#!usr/bin/env ruby

# file: curltoruby.rb

# description: Inspired by jhawthorn's curl-to-ruby. see https://jhawthorn.github.io/curl-to-ruby/


require 'lineparser'
require 'clipboard'


class CurlToRuby

  def initialize(s, debug: false)

    @debug = debug
    @h = parse(s)

  end

  def to_h()
    @h
  end

  def to_s()

    @s = build_code(@h)
    Clipboard.copy @s
    puts 'copied to clipboard'

    @s

  end

  private

  def build_code(h)

s1=<<EOF
require 'net/http'
require 'uri'

uri = URI.parse('#{h[:url]}')
EOF

    s2 = if @h[:header].grep(/Content-Type: application\/x-www-form-urlencoded/).any? then
<<EOF
request = Net::HTTP::Post.new(uri)
request.body = '#{h[:body]}'
request.content_type = "application/x-www-form-urlencoded; charset=UTF-8"
EOF
    else
      "request = Net::HTTP::Get.new(uri)"
    end

    headers = @h[:header].map do |x|
      key, value = x.split(/: +/,2)
      "request[\"%s\"] = \"%s\"" % [key, value.gsub(/"/,'\"')]
    end.join("\n")

s3=<<EOF
req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
# response.body
EOF

    s1 + s2 + "\n" + headers + "\n" + s3

  end

  def parse(raws)

    s = raws.gsub(/^\s+/,'').gsub(/(-H|--data-raw)/, "\n" + '\0')

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
