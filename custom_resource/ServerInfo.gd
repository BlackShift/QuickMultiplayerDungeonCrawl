class_name ServerInfo extends Resource

@export var name:String
@export var address:String
@export var used_slots:int
@export var server_ping:int

var last_local_ping:int = 9999


func get_ip(type:IP.Type = IP.TYPE_IPV4) -> String:
	return  IP.resolve_hostname(get_hostname(),type)

func get_hostname() -> String:
	var split := address.split(":",true,1)
	return split[0]

func get_port() -> int:
	var split := address.split(":",true,1)
	return split[1].to_int()

static func compare_adress(a:ServerInfo,ip:String,port:int) -> bool:
	var matches:bool = true
	if a.get_ip(IP.TYPE_ANY) != ip:
		matches = false
	if a.get_port() != port:
		matches = false
	return matches
