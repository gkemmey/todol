gem "rails", "~> 7.0.4", ">= 7.0.4.3"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "propshaft"
gem "puma", "~> 5.0"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
