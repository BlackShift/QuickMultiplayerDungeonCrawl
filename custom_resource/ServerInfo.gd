class_name ServerInfo extends Resource

@export var name:String
@export var address:String:
	set(value):
		_cached_ip_resolver = IP.resolve_hostname_queue_item(get_hostname(),IP.TYPE_ANY)
		address = value
@export var used_slots:int
@export var server_ping:int

var last_local_ping:int = 9999
var _cached_ip:String
var _cached_ip_resolver:int = -1

func get_ip(type:IP.Type = IP.TYPE_ANY) -> String:
	if !_cached_ip:
		if IP.get_resolve_item_status(_cached_ip_resolver) == IP.RESOLVER_STATUS_DONE and \
			_cached_ip_resolver >= 0:
			_cached_ip = IP.get_resolve_item_address(_cached_ip_resolver)
			return _cached_ip
		_cached_ip = IP.resolve_hostname(get_hostname(),type)
	return _cached_ip

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
