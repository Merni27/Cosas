
#!/bin/bash
#Eliminar reglas y reiniciar el firewall
	iptables -F          
	#iptables -X		
	#iptables -Z		
	#iptables -F -t nat

#Configuración inicial
	iptables -P INPUT DROP       -> Por defecto vamos a aceptar solo el trafico que sale de debian1
	iptables -P FORWARD DROP
	#iptables -P OUTPUT ACCEPT    

#Permitir conexiones entre maquinas debianX de la intranet
	iptables -A FORWARD -i enp0s9 -p all -j ACCEPT
	iptables -A INPUT -i enp0s9 -p all -j ACCEPT
	iptables -A FORWARD -i enp0s10 -p all -j ACCEPT
	iptables -A INPUT -i enp0s10 -p all -j ACCEPT

#Conexión con internet y con el host
	iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
	iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#Permito todo tráfico de salida a internet
	iptables -t nat -A POSTROUTING -o enp0s3 -j SNAT --to 10.0.2.15

#Permitir trafico http (80) al servidor web debian2
	iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.57.2:80
	iptables -A FORWARD -p tcp --dport 80 -j ACCEPT

#Permitir trafico del HOST al servidor ssh
	iptables -A FORWARD -i enp0s8 -p tcp --dport 22 -d 192.168.59.1 -j ACCEPT
	
#Permitir que debian conteste ping de intranet y no de host
	iptables -A INPUT -i enp0s9 -p icmp --icmp-type echo-request -j ACCEPT
	iptables -A INPUT -i enp0s10 -p icmp --icmp-type echo-request -j ACCEPT

#Permitir el trafico al servidor ssh en debian5 de las maquinas debianX de la intranet 
	iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to 192.168.59.1:22
	iptables -A FORWARD -p tcp --dport 22 -d 192.168.59.1 -j ACCEPT

	iptables.sh-save -> /etc/iptables/rules.v4


