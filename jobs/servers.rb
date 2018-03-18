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

server1_uri = '/monitor/mis/server?server=server1'

# server1_data = {"name":"server1","uptime":0,"cpuUsage":0.00, :loadAverages=>:{:"1min"=>0.00,:"5min"=>0.00,:"15min"=>0.00}}
server1_data = { "name" => "server1", "uptime" => 0,  "cpuUsage" => 0.00, "loadAverages" => { "1min": 0.00, "5min": 0.00, "15min": 0.00} }

SCHEDULER.every '5s', :first_in => 0 do |job|

  # http = Net::HTTP.new('192.168.0.240', '3000')
  # resp = http.request(Net::HTTP::Get.new("/monitor/mis/fileservers"))
  # next unless '200'.eql? resp.code

  server1_dataprev = server1_data
  resp = http.get(server1_uri)
  next unless '200'.eql? resp.code
  server1_data = JSON.parse(resp.body)

  if server1_data["uptime"] != server1_dataprev["uptime"]
    send_event('mis01_dkrhost01_uptime', { value: server1_data["uptime"]} )
  end
  if server1_data["cpuUsage"] != server1_dataprev["cpuUsage"]
    send_event('mis01_dkrhost01_cpuusage', { value: server1_data["cpuUsage"]} )
  end
  if server1_data["loadAverages"]["1min"] != server1_dataprev["loadAverages"]["1min"]
    send_event('mis01_dkrhost01_loadavg_1min', { value: server1_data["loadAverages"]["1min"]} )
  end
  if server1_data["loadAverages"]["5min"] != server1_dataprev["loadAverages"]["5min"]
    send_event('mis01_dkrhost01_loadavg_5min', { value: server1_data["loadAverages"]["5min"]} )
  end
  if server1_data["loadAverages"]["15min"] != server1_dataprev["loadAverages"]["15min"]
    send_event('mis01_dkrhost01_loadavg_15min', { value: server1_data["loadAverages"]["15min"]} )
  end
end
