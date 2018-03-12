# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '1m', :first_in => 0 do |job|
#   send_event('widget_id', { })
# end

resp = { provisioned: 0, active: 0, outofdate: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|
  respprev = resp
  resp = { provisioned: 40, active: 35 + (rand * 6).to_i, outofdate: (rand * 3).to_i}
  if resp[:provisioned] != respprev[:provisioned]
    send_event('mis01_terminals_provisioned', { value: resp[:provisioned]} )
  end
  if resp[:active] != respprev[:active]
    send_event('mis01_terminals_active', { value: resp[:active]} )
  end
  if resp[:outofdate] != respprev[:outofdate]
    send_event('mis01_terminals_outofdate', { value: resp[:outofdate]} )
  end
end
