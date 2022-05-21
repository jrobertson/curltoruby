Gem::Specification.new do |s|
  s.name = 'curltoruby'
  s.version = '0.1.2'
  s.summary = 'Inspired by jhawthorn\'s curl-to-ruby. see https://jhawthorn.github.io/curl-to-ruby/'
  s.authors = ['James Robertson']
  s.files = Dir["lib/curltoruby.rb"]
  s.add_runtime_dependency('lineparser', '~> 0.2', '>=0.2.0')
  s.add_runtime_dependency('clipboard', '~> 1.3', '>=1.3.6')
  s.signing_key = '../privatekeys/curltoruby.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/curltoruby'
end
