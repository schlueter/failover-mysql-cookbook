name 'failover-wordpress'

%w(wordpress percona-multi database nginx).each do |ckbk|
  depends ckbk
end
