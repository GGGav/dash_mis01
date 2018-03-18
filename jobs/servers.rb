# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '1m', :first_in => 0 do |job|
#   send_event('widget_id', { })
# end
#  Use this as http template
#         https://gist.github.com/charlesrg/f8246808b73f872d631e41336d1b05b7
#  Could use this as https template
#         https://gist.github.com/pszypowicz/bc07528ed7ae79bf49aa

#require 'net/http'
require 'net/https'
require 'json'

cert = File.read("./certs/aspire.crt")
key = File.read("./certs/aspire-nopw.key")

host = 'aspire.local'
port = '3010'
http = Net::HTTP.new(host, port)
http.use_ssl = true
http.cert = OpenSSL::X509::Certificate.new(cert)
http.key = OpenSSL::PKey::RSA.new(key)
http.ca_file = './certs/CA1.crt'
#Not secure is to leave it NONE, VERIFY_PEER is preffered.
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

server_uri = '/monitor/mis/server'
#  Returns an array of noServerSpecified
# [ {"name":"dkrhost01","uptime":1,"cpuUsage":0.28,"loadAverages":{"1min":0.38,"5min":0.08,"15min":0.57}},
#   {"name":"dkrhost02","uptime":2,"cpuUsage":0.36,"loadAverages":{"1min":0.62,"5min":0.92,"15min":0.35}},
#   {"name":"dkrhost03","uptime":2,"cpuUsage":0.56,"loadAverages":{"1min":0.24,"5min":0.72,"15min":0.45}} ]

SCHEDULER.every '5s', :first_in => 0 do |job|

  # http = Net::HTTP.new('192.168.0.240', '3000')
  # resp = http.request(Net::HTTP::Get.new("/monitor/mis/fileservers"))
  # next unless '200'.eql? resp.code

  resp = http.get(server_uri)
  next unless '200'.eql? resp.code
  server_data = JSON.parse(resp.body)
  # puts server_data.inspect

  server_data.each { |server|

    id_base = "mis01_" + server["name"]

    send_event(id_base + '_uptime', { value: server["uptime"]} )
    send_event(id_base + '_cpuusage', { value: server["cpuUsage"]} )
    send_event(id_base + '_loadavg_1min', { value: server["loadAverages"]["1min"]} )
    send_event(id_base + '_loadavg_5min', { value: server["loadAverages"]["5min"]} )
    send_event(id_base + '_loadavg_15min', { value: server["loadAverages"]["15min"]} )
  }
end
