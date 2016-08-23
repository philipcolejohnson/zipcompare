require 'date'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
