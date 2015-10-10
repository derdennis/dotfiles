#! /usr/bin/env ruby

# via:
# http://blog.simonszu.de/2013/10/fever-hoher-mobildatentraffic/

require 'digest/md5'
require 'net/http'
require 'uri'

USER = "dennis@instant-thinking.de"
PASS = "tewh4rogh5ke"
FEVER_URI = "http://fever.instant-thinking.de" # Without trailing slash please

get_feeds = URI.parse(FEVER_URI + "/?api&feeds")
apikey = Digest::MD5.hexdigest(USER + ":" + PASS)
body = {'api_key' => apikey, 'mark' => 'group', 'as' => 'read', 'id' => '-1', 'before' => Time.now.to_i}

response = Net::HTTP.post_form(get_feeds, body)
