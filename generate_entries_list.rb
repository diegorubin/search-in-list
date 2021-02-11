# frozen_string_literal: true

total_entries = 60_000_000

def generate_entry
  entry = []
  11.times { entry << rand(10) }
  entry.join ''
end

f = File.open '/tmp/entries_list', 'w'
total_entries.times do
  f.puts generate_entry
end
f.close
