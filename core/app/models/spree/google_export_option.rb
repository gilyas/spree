module Spree
  class GoogleExportOption < Base
    belongs_to :spree_store

    validates :spree_store_id, presence: true

    def export
      Spree::Dependencies.export.constantize.new.call(self)
    end

    def true_keys
      keys = []

      attributes.each do |key, value|
        if value.instance_of?(TrueClass)
          keys.append(key.to_sym)
        end
      end

      keys
    end
  end
end
