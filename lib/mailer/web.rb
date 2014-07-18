require 'mailer'
require 'mailer/model'
require 'sinatra/base'

class Mailer::Web < Sinatra::Base
  post '/happening' do
    params.delete_if{|k,v| v == ""} # delete blanks values
    model = Mailer::Model.new(params[:name], params[:age], params[:email])
    begin
      model.save
    rescue Mailer::Model::MissingAttributes
      halt 400
    rescue Mailer::Model::EmailAlreadyRegistered
      halt 409
    rescue Exception
      halt 500
    end
    status 204
  end
end
