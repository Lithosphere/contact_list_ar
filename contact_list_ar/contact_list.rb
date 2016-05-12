require 'active_record'
require_relative 'lib/contact'
require_relative 'lib/number'
require 'colorize'
require 'pry'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contacts',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
  )
puts 'CONNECTED'

class ContactList

  def initialize
    puts "Here is a list of available commands: "
    puts "new             - Create a new contact"
    puts "list            - List all contacts"
    puts "find            - shows a contact"
    puts "search          - Search contacts"
    puts "update          - Updates a contact"
    puts "destroy         - Deletes a contact"
  end

end

case
when ARGV.empty?
  ContactList.new
when ARGV[0] == "list"
  a = Contact.all
  a.each do |contact|
    puts "name: ".colorize(:red) + contact.name
    puts "email: ".colorize(:red) + contact.email
    contact.numbers.each do |number|
      puts "phone number: ".colorize(:red) + number.phone_number
      puts "phone type: ".colorize(:red) + number.phone_type
    end
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  end
when ARGV[0] == "new"
  puts "What is your name?"
  name = STDIN.gets.chomp
  puts "What is your email address?"
  email = STDIN.gets.chomp
  contact = Contact.create(name: name, email: email)
  puts "Did you have a phone number you wanted to add?"
  answer = STDIN.gets.chomp
  if answer == "yes"
    loop do
      puts "What is your phone number?"
      number = STDIN.gets.chomp
      puts "What type of phone is this for?"
      type = STDIN.gets.chomp
      Number.create(contact_id: contact.id, phone_number: number, phone_type: type)
      puts "Did you have any other numbers to add?"
      answer2 = STDIN.gets.chomp
      if answer2 == "no"
        break
      end
    end
  end
  puts "Your registry has been saved."
when ARGV[0] == "find"
  a = Contact.find(ARGV[1])
  puts "name: ".colorize(:red) + a.name + " email: ".colorize(:red) + a.email
  a.numbers.each do |number|
    puts "phone number: ".colorize(:red) + number.phone_number + " phone type: ".colorize(:red) + number.phone_type
  end
when ARGV[0] == "search"
  a = Contact.where("name LIKE ?",  "%#{ARGV[1]}%")
  a.each do |contact|
    puts "name: ".colorize(:red) + contact.name
    puts "email: ".colorize(:red) + contact.email
    contact.numbers.each do |number|
      puts "phone number: ".colorize(:red) + number.phone_number
      puts "phone type: ".colorize(:red) + number.phone_type
    end
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  end
when ARGV[0] == "update"
  a = Contact.find(ARGV[1])
  puts "What did you want the new name to be?"
  name = STDIN.gets.chomp
  puts "What did you want the new email to be?"
  email = STDIN.gets.chomp
  a.update(name: name, email: email)
  puts "You have updated the record."
when ARGV[0] == "destroy"
  a = Contact.find(ARGV[1])
  puts a.numbers
  a.numbers.destroy_all
  a.destroy
  end