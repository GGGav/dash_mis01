# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '5s', :first_in => 0 do |job|
#   send_event('mis01_users', { value: (rand * 30).to_i})
# end

resp = { registered: 0, pending: 0}

SCHEDULER.every '5s', :first_in => 0 do |job|
  respprev = resp
  resp = { registered: 30, loggedIn: (rand * 2).to_i, pending: (rand * 2).to_i}
  if resp[:registered] != respprev[:registered]
    send_event('mis01_users_registered', { value: resp[:registered]} )
  end
  if resp[:pending] != respprev[:pending]
    send_event('mis01_users_pending', { value: resp[:pending]} )
  end
end
