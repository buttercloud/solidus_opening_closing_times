namespace :opening_closing_times do
  task :update, [:store_id, :file_path_to_json] do |task, args|
    # {
    #    "sunday":[
    #       {
    #          "start_hour":"19",
    #          "start_min":"30",
    #          "end_hour":"20",
    #          "end_min":"30"
    #       },
    #       {
    #          "start_hour":"16",
    #          "start_min":"45",
    #          "end_hour":"18",
    #          "end_min":"30"
    #       }
    #    ]
    # }

    store = Spree::Store.find_by(id: args[:store_id])

    if store
      if args[:file_path_to_json]
        path = Pathname.new(args[:file_path_to_json])

        file = File.read(path)
        data = JSON.parse(file)

        store.opening_closing_times_and_days = data

        if store.save
          puts "Updated store successfully!"
        else
          puts "# ERROR: #{store.errors.full_messages}"
        end
      else
        raise "JSON not provided."
      end
    else
      raise "Store: #{args[:store_id]} not found!"
    end
  end
end