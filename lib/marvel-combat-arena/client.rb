require 'pry'
require 'json'
require 'uri'
require 'net/http'
require 'digest'
require_relative 'response'

module MarvelCombatArena
  class Client
    include MarvelCombatArena::Response
    attr_accessor :public_key, :private_key

    BASE_API_URL = 'https://gateway.marvel.com/'
    MAX_OFFSET = 1539

    def set_keys!(public_key:, private_key:)
      @public_key = public_key
      @private_key = private_key
    end

    def characters(random_subset: false)
      if random_subset
        get('v1/public/characters', rand(1539))
      else
        get('v1/public/characters')
      end
    end

    private

    def get(path, offset = 0)
      uri = URI([BASE_API_URL, path].join(''))
      params = {
        :ts => timestamp,
        :apikey => public_key,
        :hash => hash,
        :offset => offset
      }
      uri.query = URI.encode_www_form(params)

      prepare(Net::HTTP.get_response(uri))
    end

    def prepare(response)
      case response.code
      when '200' then MarvelCombatArena::Response.create(response.body)
      when '204' then MarvelCombatArena::Response::Error.new(
                      { 'code' => 304, 'status' => 'Not Modified' })
      else            MarvelCombatArena::Response::Error.new(response.body)
      end
    end

    def timestamp
      Time.now.to_s
    end

    def hash
      Digest::MD5.hexdigest(timestamp + private_key.to_s + public_key.to_s)
    end
  end
end
