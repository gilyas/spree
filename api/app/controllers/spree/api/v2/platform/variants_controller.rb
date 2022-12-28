module Spree
  module Api
    module V2
      module Platform
        class VariantsController < ResourceController
          private

          def model_class
            Spree::Variant
          end

          def spree_permitted_attributes
            super + [:option_value_ids, :price, :currency]
          end

          def collection
            # if filtering on products, manually join on product translation to workaround mobility-ransack issue
            if params.key?(:filter) && params[:filter].keys.any? { |k| k.include? 'product' }
              @collection ||= scope.joins(:product).
                              joins("LEFT OUTER JOIN #{Product::Translation.table_name} #{Product.translation_table_alias}
                                           ON #{Product.translation_table_alias}.spree_product_id = #{Product.table_name}.id
                                           AND #{Product.translation_table_alias}.locale = '#{Mobility.locale}'").
                              ransack(params[:filter]).result
            else
              super
            end
          end
        end
      end
    end
  end
end
