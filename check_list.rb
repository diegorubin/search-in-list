# frozen_string_literal: true

require 'httparty'

def generate_entry
  entry = []
  11.times { entry << rand(10) }
  entry.join ''
end

puts 'loading entries'
entries = File.open('/tmp/entries_list').entries.each.collect(&:chop)
puts "list with #{entries.size} items"

loop do
  entry = generate_entry
  response = HTTParty.get('http://localhost:8080', headers: { 'X-Entry' => entry })

  isvalid = (response.code == (entries.include?(entry) ? 200 : 404))
  unless isvalid
    puts entry
    exit(0)
  end
end
