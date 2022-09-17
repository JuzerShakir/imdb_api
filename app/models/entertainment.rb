class Entertainment < ApplicationRecord
    # * Associations
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :stars
    has_and_belongs_to_many :producers
    has_and_belongs_to_many :directors

    # * validations
    validates_presence_of :identifier
    validates_uniqueness_of :identifier, message: "must be unique"

    private

    def set_relations(relational_data)
        with_models = %w(Genre Star Producer Director)

        relational_data.each_with_index { | relation, i |
            model = with_models[i]
            associated = self.instance_eval("#{model.downcase}s")

            relation.each { |record|
                instance = model.constantize.find_by(name: record)
                instance.nil? ? associated.create(name: record) : associated << instance
            }
        }
    end
end
