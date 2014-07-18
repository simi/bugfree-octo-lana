require 'mailer'
require 'sqlite3'
require 'net/smtp'

class Mailer::Model < Struct.new(:name, :age, :email)
  class MissingAttributes < Exception; end
  class EmailAlreadyRegistered < Exception; end

  def self.connection
    @@connection ||= SQLite3::Database.new("mailer.db")
  end

  def save
    save_to_database
    send_emails
  end

  private

  def connection
    self.class.connection
  end

  def client_text
    "Super! Jsme moc rádi, že ses k nám připojil. I nadále sleduj naše webové stránky a buďte v obraze.\n\nSpolečně to dokážeme!\n\nTeam Street Happening of Karlín"
  end

  def send_emails
    send_email('happening@ddmpraha.cz', self.email, 'Registrace karlinhappening.cz', client_text)
    send_email('info@pepajs.cz', 'happening@ddmpraha.cz', 'Nová registrace', host_text)
  end

  def host_text
    "Jméno a příjmení: #{self.name}" +
    "Věk: #{self.age}" +
    "Email: #{self.email}"
  end

  def send_email(from, to, subject, body)
    message = <<MESSAGE_END
From: <#{from}>
To: <#{to}>
Subject: #{subject}

#{body}
MESSAGE_END

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, from, to
    end
  end

  def save_to_database
    begin
      connection.execute("INSERT INTO mailers (name, age, email) VALUES (?, ?, ?)", [self.name, self.age, self.email])
    rescue SQLite3::ConstraintException => e
      case e.message
      when /is not unique/ then raise EmailAlreadyRegistered
      else raise MissingAttributes
      end
    end
  end
end
