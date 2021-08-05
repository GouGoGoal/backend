#!/bin/bash
#将域名解析成IP的函数:Domain to IP
function DTI()
{
DNS='1.1.1.1'
echo `host -4 -t A -W 1 $1 $DNS|sed 1,3d|grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"|head -1`
}
#默认拦截本机所有DNS请求，但忽略以下名单，
Ignore_DNS=''

#获取当前的流媒体解锁IP，若不解锁某区域的流媒体注释掉即可
twip=`DTI unlock.tw.xtls.space`
hkip=`DTI unlock.hk.xtls.space`
jpip=`DTI unlock.jp.xtls.space`
usip=`DTI unlock.us.xtls.space`
thip=`DTI unlock.th.xtls.space`
#sgip=`DTI unlock.sg.xtls.space`
#cnip=`DTI unlock.cn.xtls.space`

#奈飞IP，就近解锁
#nfip=$sgip
#daznip=$jpip

#若查询不到则赋值为-，即忽略
if [ ! "$twip" ];then twip='-';fi
if [ ! "$hkip" ];then hkip='-';fi
if [ ! "$jpip" ];then jpip='-';fi
if [ ! "$usip" ];then usip='-';fi
if [ ! "$thip" ];then thip='-';fi
if [ ! "$sgip" ];then sgip='-';fi
if [ ! "$cnip" ];then cnip='-';fi
if [ ! "$nfip" ];then nfip='-';fi
if [ ! "$daznip" ];then daznip='-';fi

#定义刷新smartdns参数并重启的函数
flush_smartdns_conf() {
echo "
#绑定到本机
bind 127.0.0.1
#bind-tcp 127.0.0.1
#上游tcp查询，可以再添加所在地域的DNS
server-tcp 1.1.1.1:53
server-tcp 8.8.8.8:53
#台湾DNS
server-tcp 168.95.1.1:53
#香港DNS
server-tcp 202.14.67.4:53
#日本DNS
server-tcp 203.119.1.1:53
#韩国DNS
server-tcp 210.220.163.82:53
#俄罗斯DNS
server-tcp 77.88.8.8:53
#TCP查询超时30s
tcp-idle-time 30
#本地缓存条数
cache-size 1024
#域名预先获取功能
prefetch-domain yes
#过期缓存服务功能
serve-expired no
#测速模式选择，先ping，不通再tcping 80
speed-check-mode ping,tcp:80
#双栈IP优选
dualstack-ip-selection no
#dualstack-ip-selection-threshold 30
#完全不解析IPV6
force-AAAA-SOA yes
#日志级别 error
log-level error
#日志位置
log-file /var/log/smartdns.log
log-size 128k
log-num 1
#ban掉部分域名
conf-file /etc/ban.conf
#------------------------------------
#奈飞
#address /fast.com/$nfip
address /netflix.com/$nfip
#address /netflix.net/$nfip
#address /nflxext.com/$nfip
#address /nflximg.net/$nfip
#address /nflxso.net/$nfip
address /nflxvideo.net/$nfip
#------------------------------------
#香港TVB
address /mytvsuper.com/$hkip
address /tvb.com/$hkip
#香港Viu
address /viu.now.com/$hkip
address /ewcdn01.nowe.com/$hkip
address /ewcdn02.nowe.com/$hkip
address /viu.com/$hkip
address /viu.tv/$hkip
#------------------------------------
#台湾动画疯
address /gamer.com.tw/$twip
address /bahamut.com.tw/$twip
address /hinet.net/$twip
#台湾四季TV
address /4gtv.tv/$twip
#台湾LineTV
address /linetv.tw/$twip
#台湾Hami Video
address /hamivideo.hinet.net/$twip
#台湾KKTV
address /kktv.me/$twip
address /kktv.com.tw/$twip
#B站
address /bilibili.com/$twip
#address /hdslb.com/$twip
#------------------------------------
#泰国B站
address /biliintl.com/$thip
#------------------------------------
#日本AbemaTV
address /ameba.jp/$jpip
address /abema.io/$jpip
address /ameba.jp/$jpip
address /ds-linear-abematv.akamaized.net/$jpip
#TVer
address /tver.jp/$jpip
#niconico
address /nicovideo.jp/$jpip
address /dmc.nico/$jpip
address /nimg.jp/$jpip
address /nimg.jp/$jpip
address /socdm.com/$jpip
#hulu.jp
address /hulu.jp/$jpip
address /hjholdings.tv/$jpip
#DAZN
address /dazn.com/$daznip
address /indazn.com/$daznip
address /dazn-api.com/$daznip
address /dazndn.com/$daznip
#DMM
address /dmm.com/$jpip
address /dmm.co.jp/$jpip
address /dmm-extension.com/$jpip
#日本Paravi
address /paravi.jp/$jpip
#------------------------------------
#PornHub
#address /pornhub.com/$jpip
#address /phncdn.com/$jpip
#------------------------------------
#美国disneynow disney+
address /disneynow.com/$usip
address /disneyplus.com/$usip
address /go.com/$usip
#美国hulu
address /hulu.com/$usip
address /huluim.com/$usip
#美国HBO
address /hbo.com/$usip
address /hbomax.com/$usip
address /hbonow.com/$usip
#美国espn+
address /espn.com/$usip
address /espn.net/$usip
address /espncdn.com/$usip
address /bamgrid.com/$usip
#美国peaacock
address /peacocktv.com/$usip
">/etc/smartdns.conf
#重启服务
systemctl restart smartdns
}

if [ ! -f "/etc/smartdns.conf" ]; then 
	echo '当前无配置文件，已生成'
	flush_smartdns_conf
else
	#对比IP变化，有变化就刷新重启smartdns
	if [ "`grep -m 1 $twip /etc/smartdns.conf`" -a "`grep -m 1 $hkip /etc/smartdns.conf`" -a "`grep -m 1 $jpip /etc/smartdns.conf`" -a "`grep -m 1 $usip /etc/smartdns.conf`" -a "`grep -m 1 $thip /etc/smartdns.conf`" -a "`grep -m 1 $sgip /etc/smartdns.conf`" -a "`grep -m 1 $cnip /etc/smartdns.conf`" ];then
		echo 'IP无变化，退出脚本'
	else 
		echo 'IP有变化，已重新生成配置文件'
		flush_smartdns_conf
	fi     
fi
#监测smartdns服务状态，并监测iptables劫持
if [ "`systemctl status smartdns|grep running`" ];then
	#忽略对指定DNS的劫持
	if [ "$Ignore_DNS" != '' ];then 
		for i in $Ignore_DNS;do 
			if [ ! "`iptables -t nat -nL |grep -w ACCEPT|grep -w $i`" ];then
				iptables -t nat -I OUTPUT -d $i -j ACCEPT
			fi
		done
	fi

	if [ ! "`iptables -t nat -nL |grep DNAT|grep -w 127.0.0.1:53`" ];then
		iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
	fi
else iptables -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
fi

#NAT小鸡解锁作服务端，请自行更改映射出来的80公网IP端口
#natip=$cnip
#if [ "`iptables -t nat -nL|grep DNAT|grep -w $natip|grep dpt:80`" == "" ]; then
#		number=`iptables -t nat -nL --line-number|grep dpt:80|awk -F ' ' '{print $1}'|head -1`
#		if [ "$number" == "" ];then iptables -t nat -D OUTPUT $number;fi
#		iptables -t nat -A OUTPUT -p tcp -d $natip --dport 80 -j DNAT --to-destination $natip:10080
#fi
#NAT小鸡解锁作服务端，请自行更改映射出来的443公网IP端口
#if [ "`iptables -t nat -nL|grep DNAT|grep -w $natip|grep dpt:443`" == "" ]; then
#		number=`iptables -t nat -nL --line-number|grep dpt:443|awk -F ' ' '{print $1}'|head -1`
#		if [ "$number" == "" ];then iptables -t nat -D OUTPUT $number;fi
#		iptables -t nat -A OUTPUT -p tcp -d $natip --dport 443 -j DNAT --to-destination $natip:10443
#fi

