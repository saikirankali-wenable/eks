resource "aws_instance" "graylog_instance" {
    ami = "ami-03f65b8614a860c29"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.graylog_sg.id]
    subnet_id = "aws_subnet.graylog_public.id"
    key_name = "graylog_key"

    root_block_device {
      volume_type = "gp3"
      volume_size = 50
      delete_on_termination = true
      
    }




 user_data = <<-EOF
             #!/bin/bash

             export DEBIAN_FRONTEND=noninteractive
             echo"3 prerequisites for installing graylog"
              
             echo "Updating system packages..."
             apt-get update
             apt-get install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen
              
             # Installing mongodb and it's deps
             echo "Installing mongodb and it's deps"
             wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
             echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
             apt-get update
             apt-get install -y mongodb-org
             systemctl enable mongod.service
             systemctl restart mongod

             # Install elastic search
             echo "Installing elastic search...."
             wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O myKey
             apt-key add myKey
             echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
             apt-get update
             apt-get install elasticsearch-oss
             tee -a /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOT
             cluster.name: graylog
             action.auto_create_index: false
             EOT
              
             echo "systemctl enable & restart ES"
             systemctl daemon-reload
             systemctl enable elasticsearch
             systemctl restart elasticsearch

             # Setup graylog
             echo "Install & Setup graylog"
             wget https://packages.graylog2.org/repo/packages/graylog-4.2-repository_latest.deb
             dpkg -i graylog-4.2-repository_latest.deb
             apt-get update
             apt-get install graylog-server
              
             EOF



}