class Genre < ApplicationRecord
    has_and_belongs_to_many :entertainments
    validates_uniqueness_of :name
    validates_presence_of :name
end
