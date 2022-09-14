class Genre < ApplicationRecord
    include Entertainments::Relations::Validations
end
