name 'failover-wordpress'

%w(wordpress percona-multi database).each do |ckbk|
  depends ckbk
end
