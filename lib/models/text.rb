class Text

  # Setup Twilio account information.
  client   = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
  @account = client.account

  # Send text message to provided number with a given message.
  def self.send(number, message)
    number = number.strip
    number = number.gsub('-', '')
    number = number.gsub(' ', '')
    number = number.gsub('(', '')
    number = number.gsub(')', '')

    @account.sms.messages.create({:from => ENV['twilio_phone_number'],
                                  :to => "1#{number}",
                                  :body => "#{message}"})
  end

  # Schedule text for later processing.
  def self.schedule_text(phone, date, time, message)
    db = SQLite3::Database.open("sweep.db")
    db.execute("INSERT INTO text VALUES(?, ?, ?, ?)",[phone, date, time, message])
  end

  # Process text from database when time is right.
  def self.send_scheduled(date, time)
    db = SQLite3::Database.open("sweep.db")

    numbers_to_text = db.execute("SELECT phone, message
                          FROM text
                          WHERE date = '#{date}' AND time = '#{time}'")

    numbers_to_text.each {|phone_msg| send(phone_msg.first, phone_msg.last)}
  end

end