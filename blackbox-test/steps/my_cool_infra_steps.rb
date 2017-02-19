step "terraform has created a vpc" do
  vpc_id = TerraformHelper.outputs['vpc_id']['value']
  expect(vpc_id).to_not be_nil, "could not find vpc_id in terraform output"
end

step "terraform has created the webserver" do
  server_ip = TerraformHelper.outputs['server_public_eip']['value']
  expect(server_ip).to_not be_nil, "could not find server_ip in terraform output"
  @server_ip = server_ip.strip
end

step "the webserver should be listening on port :port within :seconds seconds" do |port, seconds|
  eventually(timeout: Integer(seconds)){
    `nc -z #{@server_ip} #{port}`
    expect($?).to be_success
  }
  @port = port
end

step "the homepage should return :text" do |text|
  out=`curl -s #{@server_ip}:#{@port}`
  expect($?).to eq(0), "failed curling server:\n #{out}"
  expect(out).to include(text)
end
