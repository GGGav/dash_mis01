# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '5s', :first_in => 0 do |job|
#   send_event('mis01_users', { value: (rand * 30).to_i})
# end

#  Use this as http template
#         https://gist.github.com/charlesrg/f8246808b73f872d631e41336d1b05b7
#  Could use this as https template
#         https://gist.github.com/pszypowicz/bc07528ed7ae79bf49aa

require 'net/http'
require 'json'

data = { registered: 0, pending: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|

  http = Net::HTTP.new('192.168.0.240', '3000')
  resp = http.request(Net::HTTP::Get.new("/monitor/mis/users"))
  next unless '200'.eql? resp.code

  dataprev = data

  data = JSON.parse(resp.body)

  if data["registered"] != dataprev["registered"]
    send_event('mis01_users_registered', { value: data["registered"]} )
  end
  if data["pending"] != dataprev["pending"]
    send_event('mis01_users_pending', { value: data["pending"]} )
  end
end
