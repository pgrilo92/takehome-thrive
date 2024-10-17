require 'json'

# Method to load JSON files
def load_json(file_path)
  JSON.parse(File.read(file_path))
rescue JSON::ParserError => e
  puts "Error loading JSON file #{file_path}: #{e.message}"
  exit
end

# Method to check for duplicate IDs
def check_for_duplicates(data, id_key)
  ids = data.map { |item| item[id_key] }
  duplicates = ids.select { |id| ids.count(id) > 1 }.uniq
  unless duplicates.empty?
    puts "Warning: Duplicate #{id_key}s found: #{duplicates.join(', ')}"
    exit
  end
end

# Method to process users and companies
def process_users_and_companies(users_file, companies_file, output_file)
  users = load_json(users_file)
  companies = load_json(companies_file)

  # Check for duplicate IDs in users and companies
  check_for_duplicates(users, 'id')
  check_for_duplicates(companies, 'id')

  companies_sorted = companies.sort_by { |company| company['id'] }

  File.open(output_file, 'w') do |file|
    companies_sorted.each do |company|
      file.puts "Company Id: #{company['id']}"
      file.puts "Company Name: #{company['name']}"
      
      users_emailed = []
      users_not_emailed = []
      
      users.select { |user| user['company_id'] == company['id'] && user['active_status'] }.sort_by { |user| user['last_name'] }.each do |user|
        new_token_balance = user['tokens'] + company['top_up']
        
        if company['email_status'] && user['email_status']
          users_emailed << "\t#{user['last_name']}, #{user['first_name']}, #{user['email']}\n\t  Previous Token Balance, #{user['tokens']}\n\t  New Token Balance #{new_token_balance}"
        else
          users_not_emailed << "\t#{user['last_name']}, #{user['first_name']}, #{user['email']}\n\t  Previous Token Balance, #{user['tokens']}\n\t  New Token Balance #{new_token_balance}"
        end
      end
      
      file.puts "Users Emailed:"
      users_emailed.each { |u| file.puts u }
      
      file.puts "Users Not Emailed:"
      users_not_emailed.each { |u| file.puts u }

      total_top_up = (users_emailed + users_not_emailed).map do |user|
        user.match(/New Token Balance (\d+)/)[1].to_i - user.match(/Previous Token Balance, (\d+)/)[1].to_i
      end.sum
      
      file.puts "\tTotal amount of top ups for #{company['name']}: #{total_top_up}"
      file.puts
    end
  end
end

# Main execution
if __FILE__ == $0
  if ARGV.length != 3
    puts "Usage: ruby challenge.rb users.json companies.json output.txt"
    exit
  end

  users_file = ARGV[0]
  companies_file = ARGV[1]
  output_file = ARGV[2]

  process_users_and_companies(users_file, companies_file, output_file)
end
