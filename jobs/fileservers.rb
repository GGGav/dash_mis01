# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '1m', :first_in => 0 do |job|
#   send_event('widget_id', { })
# end

#  Use this as http template
#         https://gist.github.com/charlesrg/f8246808b73f872d631e41336d1b05b7
#  Could use this as https template
#         https://gist.github.com/pszypowicz/bc07528ed7ae79bf49aa

require 'net/http'
require 'json'

data = { fileserver1: 0, fileserver2: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|

  http = Net::HTTP.new('192.168.0.240', '3000')
  resp = http.request(Net::HTTP::Get.new("/monitor/mis/fileservers"))
  next unless '200'.eql? resp.code

  dataprev = data

  data = JSON.parse(resp.body)

  if data["fileserver1"] != dataprev["fileserver1"]
    send_event('mis01_fileserver_1', { value: data["fileserver1"]} )
  end
  if data["fileserver2"] != dataprev["fileserver2"]
    send_event('mis01_fileserver_2', { value: data["fileserver2"]} )
  end
end
