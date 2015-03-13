name 'failover-wordpress'

%w(wordpress mysql database).each do |ckbk|
  depends ckbk
end
