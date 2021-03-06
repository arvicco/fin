Gem::Specification.new do |gem|
  gem.name = "fin"
  gem.version = File.open('VERSION').read.strip # = ::Fin::VERSION # - conflicts with Bundler
  gem.summary = "Domain models and container structures for market data feeds"
  gem.description = "Provides basis for developing effective market data feed handlers"
  gem.authors = ["arvicco"]
  gem.email = "arvitallian@gmail.com"
  gem.homepage = "http://github.com/arvicco/fin"
  gem.platform = Gem::Platform::RUBY
  gem.date = Time.now.strftime "%Y-%m-%d"

  # Files setup
  versioned = `git ls-files -z`.split("\0")
  gem.files = Dir['{bin,lib,man,spec,features,tasks}/**/*', 'Rakefile', 'README*', 'LICENSE*',
                  'VERSION*', 'CHANGELOG*', 'HISTORY*', 'ROADMAP*', '.gitignore'] & versioned
  gem.executables = (Dir['bin/**/*'] & versioned).map { |file| File.basename(file) }
  gem.test_files = Dir['spec/**/*'] & versioned
  gem.require_paths = ["lib"]

  # RDoc setup
  gem.has_rdoc = true
  gem.rdoc_options.concat %W{--charset UTF-8 --main README.rdoc --title order_book}
  gem.extra_rdoc_files = ["LICENSE", "HISTORY", "README.rdoc"]

  # Dependencies
  gem.add_development_dependency("rspec", [">= 2.5.0"])
  gem.add_development_dependency("cucumber", [">= 0"])
  gem.add_dependency("bundler", [">= 1.0.0"])
end
