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

data = { provisioned: 0, active: 0, loggedIn: 0, outofdate: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|

  http = Net::HTTP.new('192.168.0.240', '3000')
  resp = http.request(Net::HTTP::Get.new("/monitor/mis/terminals"))
  next unless '200'.eql? resp.code

  dataprev = data

  data = JSON.parse(resp.body)

  if data["provisioned"] != dataprev["provisioned"]
    send_event('mis01_terminals_deployed', { value: data["provisioned"]} )
  end
  if data["active"] != dataprev["active"]
    send_event('mis01_terminals_active', { value: data["active"]} )
  end
  if data["loggedIn"] != dataprev["loggedIn"]
    send_event('mis01_terminals_loggedIn', { value: data["loggedIn"]} )
  end
  if data["outOfDate"] != dataprev["outOfDate"]
    send_event('mis01_terminals_outofdate', { value: data["outOfDate"]} )
  end
end
