namespace :imports do
  desc "Import restaurant data from a JSON file. Usage: rake imports:process[path/to/file.json]"
  task :process, [ :file_path ] => :environment do |_task, args|
    file_path = args[:file_path]

    raise ArgumentError, "file_path is required" if file_path.blank?

    result = File.open(file_path) do |file|
      ImportRestaurantDataService.call(file)
    end

    puts result
  rescue Errno::ENOENT, ArgumentError, JSON::ParserError, JSON::Schema::ValidationError => error
    puts error.message
  end
end
