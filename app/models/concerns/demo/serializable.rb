# Allows welcome items, terminal commands, and themes to load from JSON data

module Demo::Serializable
  extend ActiveSupport::Concern

  module ClassMethods
    def json_source(path)
      @json_path = Rails.root.join(path)
    end

    def all
      @all ||= load_from_json
    end

    private

    def load_from_json
      data = JSON.parse(File.read(@json_path), symbolize_names: true)
      data.map { |attributes| new(**attributes) }
    end
  end
end
