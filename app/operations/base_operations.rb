class BaseOperations
  # rubocop:disable all
    def self.prepare_for_delete(assoc, product, params)
      params = params.dup
      key = "#{assoc}_attributes".to_sym
      keeped_assoc_ids = params[key]&.map { |attribute| attribute[:id].to_i }
      ids_for_delete = product.send(assoc).ids - keeped_assoc_ids

      params[key] += ids_for_delete.map { |id| { id: id, _destroy: true } }
      params[key].each do |record_params|
        record_params.permit! if record_params[:_destroy]
      end
      params
    end
  # rubocop:enable all
end
