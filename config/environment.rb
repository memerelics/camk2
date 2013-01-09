# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

$secret = Hashie::Mash.new(YAML.load_file(File.expand_path('../../secret.yml', __FILE__)))

# Initialize the rails application
Camk2::Application.initialize!
