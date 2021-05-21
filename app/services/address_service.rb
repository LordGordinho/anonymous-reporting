class AddressService
    include HTTParty

    def initialize( params = {} )
        @long = params[:long]
        @lat = params[:lat]
    end

    def call
        res =  HTTParty.get "http://www.mapquestapi.com/geocoding/v1/reverse?key=#{geocoding_key}&location=#{@lat},#{@long}"
        JSON.parse(res.body)    
    end

    private

    def geocoding_key
        ENV['GEOCODING_KEY']
    end
end