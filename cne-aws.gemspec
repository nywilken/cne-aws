Gem::Specification.new do |s|
  s.name  = 'cne-aws'
  s.version  = '0.0.2'
  s.date  = '2015-12-06'
  s.executables = ['cne-ec2', 'cne-cf']
  s.summary  = 'Query AWS resources via commandline'
  s.description = "Use AWS API to query AWS resources via command line"
  s.authors  = ['John Calanta']
  s.email = 'jp@callanta.net'
  s.files  = ['lib/cne_ec2.rb', 'lib/cne_cf.rb']
  s.homepage  = 'http://john.callanta.net'
  s.license  = 'MIT'
end
