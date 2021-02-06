#!/bin/bash

#install tos
echo "Enter the URL of the tss download :"
read url
read -p "Is the installation clean install ?(y/n)" cleanInstall
if [ "$cleanInstall" = y ]
then
    mkdir /root/TosRunFiles
    cd /root/TosRunFiles
    wget "$url"
    sh tos-R*
    echo -e 'yes\nc\n'
    rm -rf /root/TosRunFiles
    #skip wizard + install license
    echo "Skip wizard and install license (y/n)?"
    read b
    if [ "$b" = "y" ]
    then
		psql -Upostgres securetrack -c  "update st_wiz set wizard_run='t'"
		psql -Upostgres securetrack -c "delete from st_licenses;" &&  psql -Upostgres securetrack -c "insert into st_licenses VALUES ('evaluation','AAFwzRiNvnD+6chiwCcv1zMTTqBizqHziQHozuDFbBZtnYgb+infXileqq9WqeT1vTR7WLR16Jf++6WrDi0B+C3VovuuzpRkEe9yvvoCjbCziRi8GVfOQ3iqQVnFhnw2Hx+wo8CAYnvDSGhbwzOAr1qsHrDd/5zdKUD/HpytR1vpICBa8efhL1xI0psiKjEOJhmPQz7CZf4zZ0y+aYsZw/h6FeYBrF6A2a9Uvgks6ULP7osGKrPGjGkfbLRtu3cRaGHXId7LmzjtahYvKDdItMsKVzHq8LtYYYyt0IA1hrXRWAN6naqxRz3NAXjTQG9FMdCKgwR/i7lvKxErUN5uhnoaxzg36eXmwjGcSgZH3QJxcMWvz+kWrPtQ3jdve6ONov7r9CtxcFIGbyaLDhtYec5G0KkpJ4riK+74SYoulSXsVVIbBbYryc/2bhSDWgBUhWqxx4Hf6GW43jVSkSJzkhz1N5Z8p4FhMmkWU7BQ5r9DOe3MmOCEcs2b8QLcQAJRtCOrS6pzAcbsAG1wuIpx0Nu6rjaz3ndALS788wQxigqU8zz1q8SgUTzEKk8xyD/9bN+6bjtzRdXAceCYytdxfMazuKm4lnDJOLZl5VsA6Ia5isDWSmQuI6CSCT6OsmVe3Q+jEqZn0jxv4R3Qz4US+0lXd3eskdRhKis83DTLN210RQ==');"
	fi
else
    echo 'For Upgrade process you need to give more details.'
    read -p "Is required to install liquibase ?(y/n)" liquibase
	if [ "$liquibase" = y ] 
	then
		read -p "Is it ugprade to master ?(y/n)" upgradeToMaster
        if [ "$upgradeToMaster" = y ]
        then
			mkdir /root/liquibase
		    cd /root/liquibase
		    wget --no-check-certificate https://jenkins-master-rnd.tufin.com/job/tss-trunk-branches/job/master/lastSuccessfulBuild/artifact/securechange/securechange-liquibase/build/distributions/securechange-liquibase-1.0-SNAPSHOT-zip-package.zip
            wget --no-check-certificate https://jenkins-master-rnd.tufin.com/job/tss-trunk-branches/job/master/lastSuccessfulBuild/artifact/securetrack/rest/securetrack-liquibase/build/distributions/securetrack-liquibase-1.0-SNAPSHOT-zip-package.zip
            unzip securetrack-liquibase-1.0-SNAPSHOT-zip-package.zip
			unzip securechange-liquibase-1.0-SNAPSHOT-zip-package.zip
			cd securetrack-liquibase-1.0-SNAPSHOT && sh liquibase.sh update
			cd ..
			cd securechange-liquibase-1.0-SNAPSHOT && sh liquibase.sh update
            cd ..
			cd /root
			rm -rf /root/liquibase
		else
		    mkdir /root/liquibase
			cd /root/liquibase	 
	        echo "Enter the securetrack-liquibase URL"
            read liquibase_ST
            echo "Enter the securechange-liquibase URL"
            read liquibase_SC
			wget --no-check-certificate $liquibase_ST
            wget --no-check-certificate $liquibase_SC
			unzip securetrack-liquibase-1.0-SNAPSHOT-zip-package.zip
            unzip securechange-liquibase-1.0-SNAPSHOT-zip-package.zip
			cd securetrack-liquibase-1.0-SNAPSHOT && sh liquibase.sh update
            cd ..
            cd securechange-liquibase-1.0-SNAPSHOT && sh liquibase.sh update
            cd ..
			cd /root
			rm -rf /root/liquibase
		fi
	else
	    echo Start the upgrade process now
	fi	
	mkdir /root/TosRunFiles
	cd /root/TosRunFiles
	wget "$url"
	sh tos-R*
	rm -rf /root/TosRunFiles
fi  
echo -e "\e[32mInstallation complete\e[0m"
