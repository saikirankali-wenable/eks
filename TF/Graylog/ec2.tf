resource "aws_instance" "graylog_instance" {
    ami = "ami-03f65b8614a860c29"
    instance_type = "t2.medium"
    vpc_security_group_ids = [aws_security_group.graylog_sg.id]
    subnet_id = aws_subnet.graylog_public[*].id
    key_name = "graylog_key"
    

    root_block_device{
        volume_type = "gp3"  # additional storage required for storing logs
        volume_size = 40
        delete_on_termination = true 
    }


 user_data = <<-EOF
             #!/bin/bash

             sudo apt-get update 
             sudo apt-get install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen mongodb-server  --force-yes
             sudo systemctl restart mongodb
             sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
             sudo echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
             sudo wget https://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.deb -O /tmp/graylog.deb
             sudo dpkg --force-all -i /tmp/graylog.deb

             sudo apt-get update
             sudo apt-get install -y  elasticsearch  --force-yes
             sudo sed -i "/cluster.name:/a cluster.name: 'graylog'" /etc/elasticsearch/elasticsearch.yml
             sudo systemctl daemon-reload
             sudo systemctl enable elasticsearch.service
             sudo systemctl restart elasticsearch.service
             sudo apt-get update
             sudo apt-get install -y graylog-server --force-yes

             sudo systemctl daemon-reload
             sudo systemctl enable graylog-server.service
             sudo systemctl start graylog-server.service

             EOF

}
