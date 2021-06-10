#!/bin/bash
#git地址，-b 是分支
#giturl='-b backend https://github.com/backend/backend'

#检测是否是root
if [ "`id -u`" != 0 ];then echo '请使用root用户执行脚本';exit;fi
#安装必要的工具组件和关闭CentOS自带的防火墙，关闭selinux
if [ ! -f "/etc/redhat-release" ];then
	apt update
    apt install git curl -y
else 
    yum install git curl -y
	systemctl stop firewalld
	systemctl disable firewalld
	setenforce 0
	echo 'SELINUX=disabled'>/etc/selinux/config
fi
#若上述安装失败，请自行查找原因
if [ "$?" != '0' ];then
	echo 'SB：git curl安装失败，请手动安装成功后再次执行'
	exit
fi
#如果机器首次执行，存在/backend，则跳过git步骤
if [ ! -d "/backend" ];then
	mkdir /backend
	git clone $giturl /backend
	cd /backend
	chmod +x backend
	mv backend.service /etc/systemd/system/
	mv backend@.service /etc/systemd/system/
else 
	cd /backend
fi

#将crontab默认shell改成bash
sed -i "s|SHELL=/bin/sh|SHELL=/bin/bash|g" /etc/crontab

#先循环一次，将带有-的参数进行配置
for i in $*
do
	if [ "${i:0:1}" == '-' ];then 
		i=${i:1}
		A=`echo $i|awk -F '=' '{print $1}'`
		case $A in 
		bbr)
			sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf 
			sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
			echo '#开启BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr'>>/etc/sysctl.conf
			sysctl -p
			;;
		conf)
			B=`echo $i|awk -F '=' '{print $2}'`
			rm -f $B.yml
			cp example.yml $B.yml
			conf=$B.yml
			;;
		task)
			if [ ! "`grep 清理 /etc/crontab`" ];then
				echo '#每天05:55清理日志日志'>>/etc/crontab
				echo '0 6 * * * root find /var/ -name "*.log.*" -exec rm -rf {} \;'>>/etc/crontab
				echo '#每天06:00点重启服务'>>/etc/crontab
				echo "0 6 * * * root for i in \`systemctl |grep -E \"backend\"|grep service|awk '{print \$1}'\`;do systemctl restart \$i;done" >>/etc/crontab
			fi
			;;
		esac
	fi
done

#如果没有指定-conf，则默认为systemctl status backend
if [ ! "$conf" ];then 
	rm -f backend.yml
	cp example.yml backend.yml
	conf=backend.yml
fi

#再循环一次，将不带-的参数的配置进行替换
for i in $*
do
	if [ "${i:0:1}" == "-" ];then continue;fi
	A=`echo $i|awk -F ':' '{print $1}'`
	ii=`echo $i|sed 's/:/: /'`
	sed -i "s|$A.*|$ii|g" $conf
done
if [ "$conf" == 'backend.yml' ];then 
	systemctl daemon-reload
	systemctl enable backend
	systemctl restart backend
	echo '部署完毕，等待5秒将显示服务状态'
	sleep 5
	systemctl status backend
else 
	conf=`echo $conf|awk -F '.' '{print $1}'`
	systemctl daemon-reload
	systemctl enable backend@$conf
	systemctl restart backend@$conf
	echo '部署完毕，等待5秒将显示服务状态'
	sleep 5
	systemctl status backend@$conf
fi





