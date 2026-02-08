Rails.application.routes.draw do
  Rails.logger.debug { "Loading routes…" }
  start = Time.current

  paths = [
    "config/routes/shared/**/*.rb",
    "config/routes/#{Rails.env}/**/*.rb"
  ]

  paths.each do |pattern|
    Dir[Rails.root.join(pattern)].sort.each do |path|
      relative_path = Pathname.new(path).relative_path_from(Rails.root)
      Rails.logger.debug { "  ✓ Loading routes from #{relative_path}" }

      name = relative_path.sub("config/routes/", "").sub(".rb", "")
      draw name
    rescue => exception
      Rails.logger.error { "  ✗ Error loading routes from #{relative_path}" }
      raise exception
    end
  end

  # defines the root path route
  root "application#root"

  Rails.logger.debug { "Loading complete in #{(Time.current - start).round(2)}s" }
end
