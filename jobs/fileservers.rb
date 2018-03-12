# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '1m', :first_in => 0 do |job|
#   send_event('widget_id', { })
# end

resp = { fileserver1: 0, fileserver2: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|
  respprev = resp
  resp = { fileserver1: (rand * 2).to_i, fileserver2: (rand * 2).to_i}
  if resp[:fileserver1] != respprev[:fileserver1]
    send_event('mis01_fileserver_1', { value: resp[:fileserver1]} )
  end
  if resp[:fileserver2] != respprev[:fileserver2]
    send_event('mis01_fileserver_2', { value: resp[:fileserver2]} )
  end
end
