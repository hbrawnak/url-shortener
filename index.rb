require 'sinatra'
require 'base64'
require 'pstore'

get '/:url' do
	original = ShortURL.read(params[:url])

	if original
		redirect original
	else
		"Sorry URL not found."
	end

end

get '/' do
	"Enter your URL"
end
 
post '/' do
	url = generate_short_url(params[:url])

	"Short URL is: localhost:4567/#{url}\n"
end

def generate_short_url(original)
	ShortURL.save(Base64.encode64(original)[0..6], original)

	Base64.encode64(original)[0..6]
end

class ShortURL 
	def self.save(encoded, original)
		store.transaction { |t| store[encoded] = original }
	end

	def self.read(encoded)
		store.transaction { store[encoded] }
	end

	def self.store
		@store ||= PStore.new("shortened_urls.db")
	end
end

