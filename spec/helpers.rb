module Helpers
  def json( dataset )
    if !dataset #.empty?
      return no_data!
    else
      JSON.pretty_generate(JSON.load(dataset.to_json)) + "\n"
    end
  end
end