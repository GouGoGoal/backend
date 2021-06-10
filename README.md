```
#参数分为两种，带- 和不带-的
#带-的不涉及对接信息，都是非必须参数
-conf=0 #指定参数文件名，后续通过 systemctl status backend@0 管理服务，不填则用 systemctl status backend 来管理
-bbr #开启BBR，若内核不支持则不生效，因此不建议使用CentOS7系统
-task #添加定时重启后端，定时清理日志等计划任务

#不带-的，修改后端的配置文件，全部参数请查看example.conf
PanelType:SSpanel
NodeType:V2ray
ApiHost:http://127.0.0.1:667
ApiKey:123
CertMode:none
CertFile:/backend/cert.pem
KeyFile:/backend/key.pem
更多信息请参阅XRayR使用文档


用例：
bash setup.sh -conf=node1 NodeID:1 PanelType:V2board NodeType:Trojan ApiHost:https://backend.com  ApiKey:api.backend.com CertMode:none  CertFile:/backend/cert.pem KeyFile:/backend/key.pem -task -bbr
```