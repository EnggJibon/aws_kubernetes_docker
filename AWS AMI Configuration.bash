# AWS AMI Configuration Process 
# KMC Projects 
# 2021-09-29 

####### 1. Change locale.conf #######
 + Edit locale.conf and change
	- Command: sudo vi /etc/locale.conf 
		> LANG=ja_JP.utf8

-------------------------------------------------------------------------------------------------------------
		
####### 2. Change localtime #######
 + rename existing localtime file
	- Command: sudo mv /etc/localtime /etc/localtime.original
	
 + Create symlink to new time file
	- Command: sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	
-------------------------------------------------------------------------------------------------------------

####### 3. Create Groups, Users and Passwords #######
 + Create "karte" group for general user
    - sudo groupadd karte 

 + Create "karte" user If "karte" user if not exist
	+ Check karte user exist or not 
		- sudo cat /etc/passwd | grep karte
	+ Create "karte" user 
		- sudo adduser karte
	+ Delete "karte" user (Optional command: if needed)
		- sudo userdel karte 
	+ Create pssword for "karte" user (Optional command: if needed)
		- sudo passwd karte 
	
 + Create "glassfish" group for glassfish server
    - sudo groupadd karte 
	
-------------------------------------------------------------------------------------------------------------

####### 4. Installing new MySql 5.6 (5.6.42) #######

 + Download MySql from repository
	- Command: sudo yum localinstall https://dev.mysql.com/get/mysql80-community-release-el6-1.noarch.rpm -y

 + Disable MySql version 8.0
	- Command: sudo yum-config-manager --disable mysql80-community
	
 + Enable MySql version 5.6
	- Command: sudo yum-config-manager --enable mysql56-community
	
 + Install MySql Community Server package
	- Command: sudo yum install mysql-community-server -y
	
 + Start MySql Server service
	- Command: sudo systemctl start mysqld.service
	
 + Enable MySql service
	- Command: sudo systemctl enable mysqld.service
	
 + Check MySql installation status
	- Command: systemctl status mysqld.service

 + Configure MySql
	- Command: sudo mysql_secure_installation
	- Enter the following configuration as shown (below):
		> Set root password? [Y/n] Y
		> New password: root
		> Re-enter new password: root
		> Remove anonymous users? [Y/n] Y
		> Disallow root login remotely? [Y/n] Y
		> Remove test database and access to it? [Y/n] Y
		> Reload privilege tables now? [Y/n] Y
		
 + Log into MySql
	- Command: mysql -u root -p
		> Enter Password: root

 + Check Mysql status
	- Command: \s

 + Create karteapi user
	- Command: create user 'karteapi' identified by 'karteapi';
	
 + Create karteviewonly user
	- Command: create user 'karteviewonly' identified by 'karteviewonly';
	
 + Create karteapi user
	- Command: create user kartework01@localhost identified by 'kartework01'; 
	
 + Create Karte database
	- Command: create database karte;
	
 + Give karteapi user all access to karte database
	- Command: grant all on karte.* to 'karteapi';
	
 + Give karteviewonly user show view access only :
	- Command: grant SHOW VIEW ON karte.* to 'karteviewonly';
	
 + Give kartework01 user all access to karte database
	- Command: grant all on karte.* to kartework01@localhost with grant option;	
	
 * Swap /etc/my.cnf file with KMC my.cnf file if necessary
 
-------------------------------------------------------------------------------------------------------------

####### 5. Installing Apache 2.4 (2.4.34) #######

	- Command: sudo yum install httpd
		> Enter 'y' (yes) for all prompts when prompted
		
	- Start apache
		> Command: sudo service httpd start
		
	- Check apache status
		> Command: sudo service httpd status
		
	- Start apache
		> Command: sudo service httpd start
	
	- Check apache status
		> Command: sudo service httpd status

	*If apache cannot access opelog (in directory - /mnt/disk/kartedocs/karte/documents/)
	- Add apache user to karte group
		> Command: sudo usermod -aG karte apache
	
-------------------------------------------------------------------------------------------------------------

####### 6. Installing PHP 7.0 (7.0.33) #######	

 + Create a temporary directory for PHP repository installation
	- Command: mkdir -p /tmp/php/
	
 + Go to /tmp/php/ directory
	- Command: cd /tmp/php/
	
 + Download repository package
	- Command: wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	
 + Install repository package
	- Command: sudo amazon-linux-extras install epel (For Amazon Linux server)
	- Command: sudo rpm -Uvh remi-release-7.rpm // Not installed
	
 + Next, install PHP packages and dependencies
	- Command: sudo yum install --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-xml php-mcrypt
		> Enter 'y' (yes) for all prompts when prompted
		
 + Confirm PHPs installation and version
	- Command: php -v

-------------------------------------------------------------------------------------------------------------

####### 7. Installing JDK 1.8 (1.8.0_191) #######		

 + Create folder for JDK installation files
	- Command: mkdir -p /tmp/jdk/
	
 + Download JDK (jdk-8u191-linux-x64.tar.gz) file from Oracles website and copy JDK file to instance the using WinSCP
      - Command: wget https://download.oracle.com/otn/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz
 + Extract JDK files
	- Command: sudo tar xzf jdk-8u191-linux-x64.tar.gz
	
	
 + Install JDK package
	- Command: sudo alternatives --install /usr/bin/java java /tmp/jdk/jdk1.8.0_191/bin/java 2
	
 + Configure JDK 
	- Command: sudo alternatives --config java
		> If the JDK installation is the only entry in the list, press the 'Enter' key. If not, select it.
		> Which confirm there is not more than one JDK
 + Confirm JDKs installation and version
	- Command: java -version
 
-------------------------------------------------------------------------------------------------------------

####### 8. Installing Glassfish 4.1 #######		

 + Download Glassfish (version 4.1) from backlog - https://kmc-j.backlog.jp/file/KM/00_%E5%85%B1%E9%80%9A/01_Development_Environment/bin/
     - Command: sudo wget http://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip
  
 + Extract Glassfish
	- Command: sudo unzip glassfish4.1.zip 
	
 + Copy Glassfish to directory /mnt/disk1/
 
 + Change the owner/group of the glassfish folder
	- Command: sudo chown -R glassfish:karte /mnt/disk1/glassfish4
	
 + Copy mysql connector into glassfish folder
	- Download mysql-connector-java-5.1.23-bin.jar from backlog - https://kmc-j.backlog.jp/file/KM/00_%E5%85%B1%E9%80%9A/01_Development_Environment/bin/
	- Command: sudo wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.23/mysql-connector-java-5.1.23.jar
	- Copy the mysql connector to directory /mnt/disk1/glassfish4/glassfish/lib/
    
	
 + Copy glassfish.service and autoStart.service from AWS Karte Dev (using WinSCP) and copy both to /usr/lib/systemd/system/ directory.
	- Check glassfish.service and make sure that it includes these 3 lines (under '[Service]' heading) (Amazon Linux Requires these):
		> ExecStart = /usr/bin/java -jar /mnt/disk1/glassfish4/glassfish/lib/client/appserver-cli.jar start-domain
		> ExecStop = /usr/bin/java -jar /mnt/disk1/glassfish4/glassfish/lib/client/appserver-cli.jar stop-domain
		> ExecReload = /usr/bin/java -jar /mnt/disk1/glassfish4/glassfish/lib/client/appserver-cli.jar restart-domain
 + Tips: Not to do- Make a file executable(chmod  + x autoService.service)	
 + Reload the services (this must be done after adding a new service or modifying an existing service)
	- Command: sudo systemctl daemon-reload (It will run all sytem script that we kept /usr/lib/systemd/system/)
	
 + Start Glassfish service
	- Command: sudo systemctl start glassfish.service (or sudo serivce glassfish start)
	
 + Check Glassfish status
	- Command: sudo service glassfish status
 
 + Make all Glassfish files in /glassfish4/bin folder executable
	- Command: sudo chmod +x /mnt/disk1/glassfish4/bin/*
	
 + Change Glassfish admin password (required to access glassfish admin panel remotely)
	- Command: sudo ./asadmin change-admin-password
		> Enter admin user name [default: admin]>admin
		> Enter the admin password>		(Leave this blank and press the 'Enter' key)
		> Enter the new admin password>admin
		> Enter the new admin password again>admin

 + Enable Glassfish secure admin login
	- Command: sudo ./asadmin --host localhost --port 4848 enable-secure-admin (or sudo ./asadmin enable-secure-admin)
	
 + Restart Glassfish
	- Command: sudo service glassfish restart
 
 + Log into Glassfish admin panel (web browser)
	- Example link: https://ec2-13-230-43-35.ap-northeast-1.compute.amazonaws.com:4848 (address will likely be different when setting up a new instance, so just include the port number - ':4848' - with the instance address).
		> Enter 'User Name' and 'Password': admin (for both)

 + Set JDBC Connection Pools (Run the following command "asadmin")
	+ Create "karte-connection-pool"
		- create-jdbc-connection-pool --datasourceclassname com.mysql.jdbc.jdbc2.optional.MysqlDataSource --restype javax.sql.DataSource --property User=karteapi:Password=karteapi:databaseName=karte:serverName=localhost:portNumber=3306:characterEncoding=UTF-8:useUnicode=true karte-connection-pool
	+ Create "karte-viewonly-pool"
		- create-jdbc-connection-pool --datasourceclassname com.mysql.jdbc.jdbc2.optional.MysqlDataSource --restype javax.sql.DataSource --property User=karteviewonly:Password=karteviewonly:databaseName=karte:serverName=localhost:portNumber=3306:driverClass=com.mysql.jdbc.Driver karte-viewonly-pool

 + Check connection pool list to confirm pool has created successfully
	- list-jdbc-connection-pools		
		
 + Check connection with Database of connection pool through PING (Run the following command "asadmin") 
	+ Check "karte-connection-pool"
		- ping-connection-pool karte-connection-pool
	+ Check "karte-viewonly-pool"
		- ping-connection-pool karte-viewonly-pool
		
 + (Optional)Delete Connection pool (Run the following command "asadmin") 
	+ Optional command: if needed
		- delete-jdbc-connection-pool karte-connection-pool 
		- delete-jdbc-connection-pool karte-viewonly-pool

 + Set JDBC Resources (Run the following command "asadmin") 
	+ Create "karte-jndi" Resource
		- create-jdbc-resource --connectionpoolid Karte-connection-pool karte-jndi
	+ Create "karte-viewonly" Resource
		- create-jdbc-resource --connectionpoolid karte-viewonly-pool karte_viewonly
	
 + Set JVM settings
	- On Glassfish admin panel, under 'Configurations' > 'server-config' > 'JVM Settings'; click 'JVM Options' tab.
	- Change, add, or comfirm these options:
		> -client ->- server (change '-client' to '-server')
		> -Xmx512m
		> -Xms512m
		> -XX:PermSize=64m
		> -XX:MaxPermSize=64m
		> -XX:SurvivorRatio=8
		> -XX:NewRatio=2
		
 + Change Maximum History Files logger setting
	- On Glassfish admin panel, under 'Configurations' > 'server-config' > 'Logger Settings'; 'General' tab
		> Maximum History Files: 100
		
 + Restart Glassfish server (through Glassfish admin panel or Linux CLI -> sudo service glassfish restart)
	
 + Configure api properties
	- Create applicationconfig folder
		> Command: sudo mkdir /mnt/disk1/glassfish4/glassfish/domains/domain1/applicationconfig
	- Create new file 
		> Command: sudo touch /mnt/disk1/glassfish4/glassfish/domains/domain1/applicationconfig/karteapi.properties
	- Copy content (below) into karteapi.properties file
		# To change this license header, choose License Headers in Project Properties.
		# To change this template file, choose Tools | Templates
		# and open the template in the editor.

		documentDirectory=/mnt/disk1/kartedocs/karte/documents
		smtp_host=smtp.kmc-j.com
		smtp_port=587
		smtp_user=mkarte-admin@kmc-j.com
		smtp_password=vGuYZc07
		base_url=https://m-cloud.kmcweb.net/kmc

 + Make karteapi.properties file executable
	- Command: sudo chmod +x /mnt/disk1/glassfish4/glassfish/domains/domain1/applicationconfig/karteapi.properties

 + Return to Glassfish admin panel to deploy karteapi.war file
	- Click on applications (in the left of the Glassfish admin panel)
	- Click the 'Deploy...' button
	- Choose 'Location:' by selecting either option (Packaged File to Be Uploaded or Local Packaged File...) to upload karteapi.war file
		> Change 'Type:' (under 'Location:' section) to 'Enterprise Application'
	- Click the 'OK' button
	
 + Check to see if the instance can be reached
	- e.g. http://ec2-3-112-75-23.ap-northeast-1.compute.amazonaws.com/kmc/ws/karte/api/test (address will likely be different when setting up a new instance, so just include '/kmc/ws/karte/api/test' - with the instance address)
		> result = {"error":true,"errorCode":"E105","errorMessage":"アクセス権がありません。"} 
		
-------------------------------------------------------------------------------------------------------------

####### 9. Modify httpd.conf file #######	 

 + Add timeout setting by copying code (below) into httpd.conf file
	- Command: sudo vi /etc/httpd/conf/httpd.conf
		# Set timeout
		Timeout 3600
	
	- Add htaccess for Smart Phone Web setting by copying the code (below) into httpd.conf file
		# Allow .htaccess for Smart Phone Web		
		<Directory "/var/www/html/kmc/sp-karte">
			AllowOverride FileInfo
		</Directory>
		
	- Restart apache
		> Command: sudo service httpd restart

-------------------------------------------------------------------------------------------------------------	

####### 10. Add (reverse)proxy settings #######	 	

 + Create new proxy config file
	- Command: sudo touch /etc/httpd/conf.d/httpd-proxy.conf
 + Add proxy settings by copying code (below) into httpd-proxy.conf file
	<Proxy *>
      Require all granted
	</Proxy>

	<IfModule proxy_module>
	<IfModule proxy_http_module>

	# Set proxy pass
	ProxyPass /kmc/ws/ http://127.0.0.1:8080/
	ProxyPassReverse /kmc/ws/ http://127.0.0.1:8080/

	</IfModule>
	</IfModule>
 
 + Restart httpd service
	- Command: sudo service httpd restart
	
 + Check address to see if proxy configuration is working
	- e.g. http://ec2-13-230-43-35.ap-northeast-1.compute.amazonaws.com/kmc/ws/ (should display glassfish landing page)(address will likely be different when setting up a new instance, so just include '/kmc/ws/' - with the instance address)
 
------------------------------------------------------------------------------------------------------------- 

####### 11. Copy script folder from AWS Karte Dev (/home directory) #######

 + User WinSCP to copy the home directory and all other home content to new instance
 
 + Make home folder scripts executable (should contain scripts: httpdStart.sh, and autoScript.sh)
	- Command: sudo chmod +x /home/script/*.sh
	
 + Add httpdStart script to crontab (for httpd to automatically start after reboot)
	- Command: sudo vim /etc/crontab
		> Add this line to the end of the file: @reboot root /home/script/httpdStart.sh

------------------------------------------------------------------------------------------------------------- 

####### 12. Make kartedeploywork directory #######		

 + Change directory
	- Command: sudo cd /mnt/disk1
	
 + Make directory in /mnt/disk1/
	- Command: sudo mkdir /mnt/disk1/kartedeploywork (Also can create with WinSCP)
	
 + Create all folders inside of kartedeploywork folder (also copy deploy scripts)
    - sudo mkdir apps backup customize db grant logs sp-karte tablet war web
	
 + Confirm folder group and owner
    - sudo chown -R ec2-user:karte /mnt/disk1/kartedeploywork/*
 
 + Make executable deploy shell script including execute_db scripts
	- Command: sudo chmod +x /mnt/disk1/kartedeploywork/*.sh
	
------------------------------------------------------------------------------------------------------------- 

####### 13. Make kartedocs directory #######		
 
 + Change directory
	- Command: sudo cd /mnt/disk1

 + Make directory in /mnt/disk1/
	- Command: sudo mkdir /mnt/disk1/kartedocs (Also can create with WinSCP)
	
 + Create all folders inside of kartedocs folder (also copy deploy scripts)
    - sudo mkdir karte

 + Create all folders inside of kartedocs folder (also copy deploy scripts)
    - sudo mkdir documents
	
 + Create all folders inside of kartedocs folder (also copy deploy scripts)
    - sudo mkdir opelog csv issue image excel module prodImport log data_import doc template format guide img work video report
 
 + Confirm folder group and owner
    - sudo chown -R glassfish:karte /mnt/disk1/kartedocs/karte/documents/*
------------------------------------------------------------------------------------------------------------- 

####### 14. Add folder /var/www/html/ directory #######	

 + Make directory
	- Command: sudo mkdir /var/www/html/

------------------------------------------------------------------------------------------------------------- 

####### 15. Setting up Karte database (db scripts) #######	

	+ Copy all Master (git) db scripts (from local 'apps/M-Karte/db' folder) to instance using WinSCP. *Make sure to include view, triggers, and procs folder
	+ Deploy/apply all scripts
		
------------------------------------------------------------------------------------------------------------- 

####### 16. Setup Karte backup and S3 upload (with cron) #######	

 + Check /mnt/disk1/kartedeploywork directory for karteBackup.sh file 
	- If karteBackup.sh file does not exist, copy the file from backlog (or K-drive) to /mnt/disk1/kartedeploywork
	
 + Once karteBackup.sh is in the right directory, set the file to be executable:
	- Command: sudo chmod +x /mnt/disk1/kartedeploywork/karteBackup.sh

 + Next, add karteBackup.sh cronjob (daily auto backup)
	- Command: sudo vim /etc/crontab
		> Add this line to the end of the file: 0 0 * * * ec2-user /mnt/disk1/kartedeploywork/karteBackup.sh
	
------------------------------------------------------------------------------------------------------------- 


