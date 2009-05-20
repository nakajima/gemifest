# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gemifest}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2009-05-19}
  s.default_executable = %q{gemifest}
  s.email = %q{patnakajima@gmail.com}
  s.executables = ["gemifest"]
  s.files = [
    "bin/gemifest",
    "lib/gemifest",
    "lib/gemifest/gem.rb",
    "lib/gemifest/version.rb",
    "lib/gemifest/installer.rb",
    "lib/gemifest.rb"
  ]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Install your gems from a .gems file}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colored>, [">= 0"])
    else
      s.add_dependency(%q<colored>, [">= 0"])
    end
  else
    s.add_dependency(%q<colored>, [">= 0"])
  end
end
