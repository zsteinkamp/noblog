# This file is used by Rack-based servers to start the application.
ENV['GEM_PATH'] = '/home/ddstnkmp/.gems'
require ::File.expand_path('../config/environment',  __FILE__)
run Noblog::Application
