desc "Deliver awaiting messages"
task :deliver => :environment do
  Message.awaiting.each { |message| message.deliver! }
end
