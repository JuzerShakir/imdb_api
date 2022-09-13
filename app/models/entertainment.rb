class Entertainment < ApplicationRecord
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :stars
    has_and_belongs_to_many :producers
    has_and_belongs_to_many :directors

    validates_presence_of :identifier
    validates_uniqueness_of :identifier, message: "must be unique"
end
