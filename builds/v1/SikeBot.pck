GDPC                �	                                                                         P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn��      1      t���\���hM{���    T   res://.godot/exported/133200997/export-92f93b24126de25f8b8804731f421411-Example.scn `�      S      �PZ��:�i+���!�;�    X   res://.godot/exported/133200997/export-c9c19e80cc69005c6d7e347b60e9153f-default_env.res ��      �	      C��>8[��� �    X   res://.godot/exported/133200997/export-e17866073d83b6c9cbf994962ff51aa1-ChatMessage.scn �      �      �!��uS�h�+cѷ�    ,   res://.godot/global_script_class_cache.cfg  ��      x�      �Cl%0�@nVK�\�B�    D   res://.godot/imported/icon.png-5ad2e6e2e39e89ee29d5171fb300a340.ctex��      P      >��b�|Go�b��    D   res://.godot/imported/icon.png-b5cf707f4ba91fefa5df60a746e02900.ctex u      �       ���x�1�p�:�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �{     �       ���B3X�0���o8       res://addons/gift/gift.gd         �       �~�0���J�{O��        res://addons/gift/gift_node.gd  �      0q      9�6�,��-���]G	*    $   res://addons/gift/icon.png.import   �u      �       �EA�����h��ְ    $   res://addons/gift/util/cmd_data.gd          Q      ��9mYOa�BZ�G1y��    $   res://addons/gift/util/cmd_info.gd  `      �       )w���ޓE�d����    (   res://addons/gift/util/sender_data.gd   0      �       �κN@����F�Z�       res://example/Button.gd �v      	      �߳�]ۍ���A�F        res://example/ChatContainer.gd  �w      C      ��P�Fؼ��w�       res://example/ChatMessage.gd             ml:n�OKH�$a��C��    $   res://example/ChatMessage.tscn.remap��      h       `���|��������H        res://example/Example.tscn.remap��      d       =P[~�ɓ��ՇnؗQ9       res://example/Gift.gd   ��      �      ��I�o(F�Ƀ�p�o�       res://example/LineEdit.gd   ��      �       AN��_�$h����    $   res://example/default_env.tres.remap@�      h       �ׯ��y�����A�j�6        res://example/icon.png.import   �      �       �C��()��(n?[uKq�       res://filter.gd `�      �      =��a�֎^�_\g�6�       res://icon.svg  x     �      C��=U���^Qu��U3       res://icon.svg.import   �      �       E��Z��t9#5�K��1       res://main.gd   ��      �      |wQZGefW���
j��       res://main.tscn.remap    �      a       �J�Sw� ������       res://project.binary�|     /      �(��R�*<�2T��J�Z    extends RefCounted
class_name CommandData

var func_ref : Callable
var permission_level : int
var max_args : int
var min_args : int
var where : int

func _init(f_ref : Callable, perm_lvl : int, mx_args : int, mn_args : int, whr : int):
	func_ref = f_ref
	permission_level = perm_lvl
	max_args = mx_args
	min_args = mn_args
	where = whr

               extends RefCounted
class_name CommandInfo

var sender_data : SenderData
var command : String
var whisper : bool

func _init(sndr_dt, cmd, whspr):
	sender_data = sndr_dt
	command = cmd
	whisper = whspr

      extends RefCounted
class_name SenderData

var user : String
var channel : String
var tags : Dictionary

func _init(usr : String, ch : String, tag_dict : Dictionary):
	user = usr
	channel = ch
	tags = tag_dict
               @tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("Gift", "Node", preload("gift_node.gd"), preload("icon.png"))

func _exit_tree() -> void:
	remove_custom_type("Gift")
 extends Node
class_name Gift

# The underlying websocket sucessfully connected to Twitch IRC.
signal twitch_connected
# The connection has been closed. Not emitted if Twitch IRC announced a reconnect.
signal twitch_disconnected
# The connection to Twitch IRC failed.
signal twitch_unavailable
# Twitch IRC requested the client to reconnect. (Will be unavailable until next connect)
signal twitch_reconnect
# User token from Twitch has been fetched.
signal user_token_received(token_data)
# User token is valid.
signal user_token_valid
# User token is no longer valid.
signal user_token_invalid
# The client tried to login to Twitch IRC. Returns true if successful, else false.
signal login_attempt(success)
# User sent a message in chat.
signal chat_message(sender_data, message)
# User sent a whisper message.
signal whisper_message(sender_data, message)
# Initial channel data received
signal channel_data_received(channel_name)
# Unhandled data passed through
signal unhandled_message(message, tags)
# A command has been called with invalid arg count
signal cmd_invalid_argcount(cmd_name, sender_data, cmd_data, arg_ary)
# A command has been called with insufficient permissions
signal cmd_no_permission(cmd_name, sender_data, cmd_data, arg_ary)
# Twitch IRC ping is about to be answered with a pong.
signal pong


# The underlying websocket sucessfully connected to Twitch EventSub.
signal events_connected
# The connection to Twitch EventSub failed.
signal events_unavailable
# The underlying websocket disconnected from Twitch EventSub.
signal events_disconnected
# The id has been received from the welcome message.
signal events_id(id)
# Twitch directed the bot to reconnect to a different URL
signal events_reconnect
# Twitch revoked a event subscription
signal events_revoked(event, reason)

# Refer to https://dev.twitch.tv/docs/eventsub/eventsub-reference/ data contained in the data dictionary.
signal event(type, data)

@export_category("IRC")

## Messages starting with one of these symbols are handled as commands. '/' will be ignored, reserved by Twitch.
@export var command_prefixes : Array[String] = ["!"]

## Time to wait in msec after each sent chat message. Values below ~310 might lead to a disconnect after 100 messages.
@export var chat_timeout_ms : int = 320

## Scopes to request for the token. Look at https://dev.twitch.tv/docs/authentication/scopes/ for a list of all available scopes.
@export var scopes : Array[String] = ["chat:edit", "chat:read"]

@export_category("Emotes/Badges")

## If true, caches emotes/badges to disk, so that they don't have to be redownloaded on every restart.
## This however means that they might not be updated if they change until you clear the cache.
@export var disk_cache : bool = false

## Disk Cache has to be enbaled for this to work
@export_file var disk_cache_path : String = "user://gift/cache"

var client_id : String = ""
var client_secret : String = ""
var username : String = ""
var user_id : String = ""
var token : Dictionary = {}

# Twitch disconnects connected clients if too many chat messages are being sent. (At about 100 messages/30s).
# This queue makes sure messages aren't sent too quickly.
var chat_queue : Array[String] = []
var last_msg : int = Time.get_ticks_msec()
# Mapping of channels to their channel info, like available badges.
var channels : Dictionary = {}
# Last Userstate of the bot for channels. Contains <channel_name> -> <userstate_dictionary> entries.
var last_state : Dictionary = {}
# Dictionary of commands, contains <command key> -> <Callable> entries.
var commands : Dictionary = {}

var eventsub : WebSocketPeer
var eventsub_messages : Dictionary = {}
var eventsub_connected : bool = false
var eventsub_restarting : bool = false
var eventsub_reconnect_url : String = ""
var session_id : String = ""
var keepalive_timeout : int = 0
var last_keepalive : int = 0

var websocket : WebSocketPeer
var server : TCPServer = TCPServer.new()
var peer : StreamPeerTCP
var connected : bool = false
var user_regex : RegEx = RegEx.new()
var twitch_restarting : bool = false

const USER_AGENT : String = "User-Agent: GIFT/4.1.5 (Godot Engine)"

enum RequestType {
	EMOTE,
	BADGE,
	BADGE_MAPPING
}

var caches := {
	RequestType.EMOTE: {},
	RequestType.BADGE: {},
	RequestType.BADGE_MAPPING: {}
}

# Required permission to execute the command
enum PermissionFlag {
	EVERYONE = 0,
	VIP = 1,
	SUB = 2,
	MOD = 4,
	STREAMER = 8,
	# Mods and the streamer
	MOD_STREAMER = 12,
	# Everyone but regular viewers
	NON_REGULAR = 15
}

# Where the command should be accepted
enum WhereFlag {
	CHAT = 1,
	WHISPER = 2
}

func _init():
	user_regex.compile("(?<=!)[\\w]*(?=@)")
	if (disk_cache):
		for key in RequestType.keys():
			if (!DirAccess.dir_exists_absolute(disk_cache_path + "/" + key)):
				DirAccess.make_dir_recursive_absolute(disk_cache_path + "/" + key)

# Authenticate to authorize GIFT to use your account to process events and messages.
func authenticate(client_id, client_secret) -> void:
	self.client_id = client_id
	self.client_secret = client_secret
	print("Checking token...")
	if (FileAccess.file_exists("user://gift/auth/user_token")):
		var file : FileAccess = FileAccess.open_encrypted_with_pass("user://gift/auth/user_token", FileAccess.READ, client_secret)
		token = JSON.parse_string(file.get_as_text())
		if (token.has("scope") && scopes.size() != 0):
			if (scopes.size() != token["scope"].size()):
				get_token()
				token = await(user_token_received)
			else:
				for scope in scopes:
					if (!token["scope"].has(scope)):
						get_token()
						token = await(user_token_received)
	else:
		get_token()
		token = await(user_token_received)
	username = await(is_token_valid(token["access_token"]))
	while (username == ""):
		print("Token invalid.")
		var refresh : String = token.get("refresh_token", "")
		if (refresh != ""):
			refresh_access_token(refresh)
		else:
			get_token()
		token = await(user_token_received)
		username = await(is_token_valid(token["access_token"]))
	print("Token verified.")
	user_token_valid.emit()
	refresh_token()

func refresh_access_token(refresh : String) -> void:
	print("Refreshing access token.")
	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://id.twitch.tv/oauth2/token", [USER_AGENT, "Content-Type: application/x-www-form-urlencoded"], HTTPClient.METHOD_POST, "grant_type=refresh_token&refresh_token=%s&client_id=%s&client_secret=%s" % [refresh.uri_encode(), client_id, client_secret])
	var reply : Array = await(request.request_completed)
	request.queue_free()
	var response : Dictionary = JSON.parse_string(reply[3].get_string_from_utf8())
	if (response.has("error")):
		print("Refresh failed, requesting new token.")
		get_token()
	else:
		token = response
		var file : FileAccess = FileAccess.open_encrypted_with_pass("user://gift/auth/user_token", FileAccess.WRITE, client_secret)
		file.store_string(reply[3].get_string_from_utf8())
		user_token_received.emit(response)

# Gets a new auth token from Twitch.
func get_token() -> void:
	print("Fetching new token.")
	var scope = ""
	for i in scopes.size() - 1:
		scope += scopes[i]
		scope += " "
	if (scopes.size() > 0):
		scope += scopes[scopes.size() - 1]
	scope = scope.uri_encode()
	OS.shell_open("https://id.twitch.tv/oauth2/authorize?response_type=code&client_id=" + client_id +"&redirect_uri=http://localhost:18297&scope=" + scope)
	server.listen(18297)
	print("Waiting for user to login.")
	while(!peer):
		peer = server.take_connection()
		OS.delay_msec(100)
	while(peer.get_status() == peer.STATUS_CONNECTED):
		peer.poll()
		if (peer.get_available_bytes() > 0):
			var response = peer.get_utf8_string(peer.get_available_bytes())
			if (response == ""):
				print("Empty response. Check if your redirect URL is set to http://localhost:18297.")
				return
			var start : int = response.find("?")
			response = response.substr(start + 1, response.find(" ", start) - start)
			var data : Dictionary = {}
			for entry in response.split("&"):
				var pair = entry.split("=")
				data[pair[0]] = pair[1] if pair.size() > 0 else ""
			if (data.has("error")):
				var msg = "Error %s: %s" % [data["error"], data["error_description"]]
				print(msg)
				send_response(peer, "400 BAD REQUEST",  msg.to_utf8_buffer())
				peer.disconnect_from_host()
				break
			else:
				print("Success.")
				send_response(peer, "200 OK", "Success!".to_utf8_buffer())
				peer.disconnect_from_host()
				var request : HTTPRequest = HTTPRequest.new()
				add_child(request)
				request.request("https://id.twitch.tv/oauth2/token", [USER_AGENT, "Content-Type: application/x-www-form-urlencoded"], HTTPClient.METHOD_POST, "client_id=" + client_id + "&client_secret=" + client_secret + "&code=" + data["code"] + "&grant_type=authorization_code&redirect_uri=http://localhost:18297")
				var answer = await(request.request_completed)
				if (!DirAccess.dir_exists_absolute("user://gift/auth")):
					DirAccess.make_dir_recursive_absolute("user://gift/auth")
				var file : FileAccess = FileAccess.open_encrypted_with_pass("user://gift/auth/user_token", FileAccess.WRITE, client_secret)
				var token_data = answer[3].get_string_from_utf8()
				file.store_string(token_data)
				request.queue_free()
				user_token_received.emit(JSON.parse_string(token_data))
				break
		OS.delay_msec(100)

func send_response(peer : StreamPeer, response : String, body : PackedByteArray) -> void:
	peer.put_data(("HTTP/1.1 %s\r\n" % response).to_utf8_buffer())
	peer.put_data("Server: GIFT (Godot Engine)\r\n".to_utf8_buffer())
	peer.put_data(("Content-Length: %d\r\n"% body.size()).to_utf8_buffer())
	peer.put_data("Connection: close\r\n".to_utf8_buffer())
	peer.put_data("Content-Type: text/plain; charset=UTF-8\r\n".to_utf8_buffer())
	peer.put_data("\r\n".to_utf8_buffer())
	peer.put_data(body)

# If the token is valid, returns the username of the token bearer. Returns an empty String if the token was invalid.
func is_token_valid(token : String) -> String:
	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://id.twitch.tv/oauth2/validate", [USER_AGENT, "Authorization: OAuth " + token])
	var data = await(request.request_completed)
	request.queue_free()
	if (data[1] == 200):
		var payload : Dictionary = JSON.parse_string(data[3].get_string_from_utf8())
		user_id = payload["user_id"]
		return payload["login"]
	return ""

func refresh_token() -> void:
	await(get_tree().create_timer(3600).timeout)
	if (await(is_token_valid(token["access_token"])) == ""):
		user_token_invalid.emit()
		return
	else:
		refresh_token()
	var to_remove : Array[String] = []
	for entry in eventsub_messages.keys():
		if (Time.get_ticks_msec() - eventsub_messages[entry] > 600000):
			to_remove.append(entry)
	for n in to_remove:
		eventsub_messages.erase(n)

func _process(delta : float) -> void:
	if (websocket):
		websocket.poll()
		var state := websocket.get_ready_state()
		match state:
			WebSocketPeer.STATE_OPEN:
				if (!connected):
					twitch_connected.emit()
					connected = true
					print_debug("Connected to Twitch.")
				else:
					while (websocket.get_available_packet_count()):
						data_received(websocket.get_packet())
					if (!chat_queue.is_empty() && (last_msg + chat_timeout_ms) <= Time.get_ticks_msec()):
						send(chat_queue.pop_front())
						last_msg = Time.get_ticks_msec()
			WebSocketPeer.STATE_CLOSED:
				if (!connected):
					twitch_unavailable.emit()
					print_debug("Could not connect to Twitch.")
					websocket = null
				elif(twitch_restarting):
					print_debug("Reconnecting to Twitch...")
					twitch_reconnect.emit()
					connect_to_irc()
					await(twitch_connected)
					for channel in channels.keys():
						join_channel(channel)
					twitch_restarting = false
				else:
					print_debug("Disconnected from Twitch.")
					twitch_disconnected.emit()
					connected = false
					print_debug("Connection closed! [%s]: %s"%[websocket.get_close_code(), websocket.get_close_reason()])
	if (eventsub):
		eventsub.poll()
		var state := eventsub.get_ready_state()
		match state:
			WebSocketPeer.STATE_OPEN:
				if (!eventsub_connected):
					events_connected.emit()
					eventsub_connected = true
					print_debug("Connected to EventSub.")
				else:
					while (eventsub.get_available_packet_count()):
						process_event(eventsub.get_packet())
			WebSocketPeer.STATE_CLOSED:
				if(!eventsub_connected):
					print_debug("Could not connect to EventSub.")
					events_unavailable.emit()
					eventsub = null
				elif(eventsub_restarting):
					print_debug("Reconnecting to EventSub")
					eventsub.close()
					connect_to_eventsub(eventsub_reconnect_url)
					await(eventsub_connected)
					eventsub_restarting = false
				else:
					print_debug("Disconnected from EventSub.")
					events_disconnected.emit()
					eventsub_connected = false
					print_debug("Connection closed! [%s]: %s"%[websocket.get_close_code(), websocket.get_close_reason()])

func process_event(data : PackedByteArray) -> void:
	var msg : Dictionary = JSON.parse_string(data.get_string_from_utf8())
	if (eventsub_messages.has(msg["metadata"]["message_id"])):
		return
	eventsub_messages[msg["metadata"]["message_id"]] = Time.get_ticks_msec()
	var payload : Dictionary = msg["payload"]
	last_keepalive = Time.get_ticks_msec()
	match msg["metadata"]["message_type"]:
		"session_welcome":
			session_id = payload["session"]["id"]
			keepalive_timeout = payload["session"]["keepalive_timeout_seconds"]
			events_id.emit(session_id)
		"session_keepalive":
			if (payload.has("session")):
				keepalive_timeout = payload["session"]["keepalive_timeout_seconds"]
		"session_reconnect":
			eventsub_restarting = true
			eventsub_reconnect_url = payload["session"]["reconnect_url"]
			events_reconnect.emit()
		"revocation":
			events_revoked.emit(payload["subscription"]["type"], payload["subscription"]["status"])
		"notification":
			var event_data : Dictionary = payload["event"]
			event.emit(payload["subscription"]["type"], event_data)

# Connect to Twitch IRC. Make sure to authenticate first.
func connect_to_irc() -> bool:
	websocket = WebSocketPeer.new()
	websocket.connect_to_url("wss://irc-ws.chat.twitch.tv:443")
	print("Connecting to Twitch IRC.")
	await(twitch_connected)
	send("PASS oauth:%s" % [token["access_token"]], true)
	send("NICK " + username.to_lower())
	var success = await(login_attempt)
	if (success):
		connected = true
	return success

# Connect to Twitch EventSub. Make sure to authenticate first.
func connect_to_eventsub(url : String = "wss://eventsub.wss.twitch.tv/ws") -> void:
	eventsub = WebSocketPeer.new()
	eventsub.connect_to_url(url)
	print("Connecting to Twitch EventSub.")
	await(events_id)
	events_connected.emit()

# Refer to https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/ for details on
# which API versions are available and which conditions are required.
func subscribe_event(event_name : String, version : int, conditions : Dictionary) -> void:
	var data : Dictionary = {}
	data["type"] = event_name
	data["version"] = str(version)
	data["condition"] = conditions
	data["transport"] = {
		"method":"websocket",
		"session_id":session_id
	}
	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://api.twitch.tv/helix/eventsub/subscriptions", [USER_AGENT, "Authorization: Bearer " + token["access_token"], "Client-Id:" + client_id, "Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(data))
	var reply : Array = await(request.request_completed)
	request.queue_free()
	var response : Dictionary = JSON.parse_string(reply[3].get_string_from_utf8())
	if (response.has("error")):
		print("Subscription failed for event '%s'. Error %s (%s): %s" % [event_name, response["status"], response["error"], response["message"]])
		return
	print("Now listening to '%s' events." % event_name)

# Request capabilities from twitch.
func request_caps(caps : String = "twitch.tv/commands twitch.tv/tags twitch.tv/membership") -> void:
	send("CAP REQ :" + caps)

# Sends a String to Twitch.
func send(text : String, token : bool = false) -> void:
	websocket.send_text(text)
	if(OS.is_debug_build()):
		if(!token):
			print("< " + text.strip_edges(false))
		else:
			print("< PASS oauth:******************************")

# Sends a chat message to a channel. Defaults to the only connected channel.
func chat(message : String, channel : String = ""):
	var keys : Array = channels.keys()
	if(channel != ""):
		if (channel.begins_with("#")):
			channel = channel.right(-1)
		chat_queue.append("PRIVMSG #" + channel + " :" + message + "\r\n")
		chat_message.emit(SenderData.new(last_state[channels.keys()[0]]["display-name"], channel, last_state[channels.keys()[0]]), message)
	elif(keys.size() == 1):
		chat_queue.append("PRIVMSG #" + channels.keys()[0] + " :" + message + "\r\n")
		chat_message.emit(SenderData.new(last_state[channels.keys()[0]]["display-name"], channels.keys()[0], last_state[channels.keys()[0]]), message)
	else:
		print_debug("No channel specified.")

# Send a whisper message to a user by username. Returns a empty dictionary on success. If it failed, "status" will be present in the Dictionary.
func whisper(message : String, target : String) -> Dictionary:
	var user_data : Dictionary = await(user_data_by_name(target))
	if (user_data.has("status")):
		return user_data
	var response : int = await(whisper_by_uid(message, user_data["id"]))
	if (response != HTTPClient.RESPONSE_NO_CONTENT):
		return {"status": response}
	return {}

# Send a whisper message to a user by UID. Returns the response code.
func whisper_by_uid(message : String, target_id : String) -> int:
	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://api.twitch.tv/helix/whispers", [USER_AGENT, "Authorization: Bearer " + token["access_token"], "Client-Id:" + client_id, "Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify({"from_user_id": user_id, "to_user_id": target_id, "message": message}))
	var reply : Array = await(request.request_completed)
	request.queue_free()
	if (reply[1] != HTTPClient.RESPONSE_NO_CONTENT):
		print("Error sending the whisper: " + reply[3].get_string_from_utf8())
	return reply[0]

# Returns the response as Dictionary. If it failed, "error" will be present in the Dictionary.
func user_data_by_name(username : String) -> Dictionary:
	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://api.twitch.tv/helix/users?login=" + username, [USER_AGENT, "Authorization: Bearer " + token["access_token"], "Client-Id:" + client_id, "Content-Type: application/json"], HTTPClient.METHOD_GET)
	var reply : Array = await(request.request_completed)
	var response : Dictionary = JSON.parse_string(reply[3].get_string_from_utf8())
	request.queue_free()
	if (response.has("error")):
		print("Error fetching user data: " + reply[3].get_string_from_utf8())
		return response
	else:
		return response["data"][0]

func get_emote(emote_id : String, scale : String = "1.0") -> Texture2D:
	var texture : Texture2D
	var cachename : String = emote_id + "_" + scale
	var filename : String = disk_cache_path + "/" + RequestType.keys()[RequestType.EMOTE] + "/" + cachename + ".png"
	if !caches[RequestType.EMOTE].has(cachename):
		if (disk_cache && FileAccess.file_exists(filename)):
			texture = ImageTexture.new()
			var img : Image = Image.new()
			img.load_png_from_buffer(FileAccess.get_file_as_bytes(filename))
			texture.create_from_image(img)
		else:
			var request : HTTPRequest = HTTPRequest.new()
			add_child(request)
			request.request("https://static-cdn.jtvnw.net/emoticons/v1/" + emote_id + "/" + scale, [USER_AGENT,"Accept: */*"])
			var data = await(request.request_completed)
			request.queue_free()
			var img : Image = Image.new()
			img.load_png_from_buffer(data[3])
			texture = ImageTexture.create_from_image(img)
			texture.take_over_path(filename)
			if (disk_cache):
				DirAccess.make_dir_recursive_absolute(filename.get_base_dir())
				texture.get_image().save_png(filename)
		caches[RequestType.EMOTE][cachename] = texture
	return caches[RequestType.EMOTE][cachename]

func get_badge(badge_name : String, channel_id : String = "_global", scale : String = "1") -> Texture2D:
	var badge_data : PackedStringArray = badge_name.split("/", true, 1)
	var texture : Texture2D
	var cachename = badge_data[0] + "_" + badge_data[1] + "_" + scale
	var filename : String = disk_cache_path + "/" + RequestType.keys()[RequestType.BADGE] + "/" + channel_id + "/" + cachename + ".png"
	if (!caches[RequestType.BADGE].has(channel_id)):
		caches[RequestType.BADGE][channel_id] = {}
	if (!caches[RequestType.BADGE][channel_id].has(cachename)):
		if (disk_cache && FileAccess.file_exists(filename)):
			var img : Image = Image.new()
			img.load_png_from_buffer(FileAccess.get_file_as_bytes(filename))
			texture = ImageTexture.create_from_image(img)
			texture.take_over_path(filename)
		else:
			var map : Dictionary = caches[RequestType.BADGE_MAPPING].get(channel_id, await(get_badge_mapping(channel_id)))
			if (!map.is_empty()):
				if(map.has(badge_data[0])):
					var request : HTTPRequest = HTTPRequest.new()
					add_child(request)
					request.request(map[badge_data[0]]["versions"][badge_data[1]]["image_url_" + scale + "x"], [USER_AGENT,"Accept: */*"])
					var data = await(request.request_completed)
					var img : Image = Image.new()
					img.load_png_from_buffer(data[3])
					texture = ImageTexture.create_from_image(img)
					texture.take_over_path(filename)
					request.queue_free()
				elif channel_id != "_global":
					return await(get_badge(badge_name, "_global", scale))
			elif (channel_id != "_global"):
				return await(get_badge(badge_name, "_global", scale))
			if (disk_cache):
				DirAccess.make_dir_recursive_absolute(filename.get_base_dir())
				texture.get_image().save_png(filename)
		texture.take_over_path(filename)
		caches[RequestType.BADGE][channel_id][cachename] = texture
	return caches[RequestType.BADGE][channel_id][cachename]

func get_badge_mapping(channel_id : String = "_global") -> Dictionary:
	if caches[RequestType.BADGE_MAPPING].has(channel_id):
		return caches[RequestType.BADGE_MAPPING][channel_id]

	var filename : String = disk_cache_path + "/" + RequestType.keys()[RequestType.BADGE_MAPPING] + "/" + channel_id + ".json"
	if (disk_cache && FileAccess.file_exists(filename)):
		var cache = JSON.parse_string(FileAccess.get_file_as_string(filename))
		if "badge_sets" in cache:
			return cache["badge_sets"]

	var request : HTTPRequest = HTTPRequest.new()
	add_child(request)
	request.request("https://api.twitch.tv/helix/chat/badges" + ("/global" if channel_id == "_global" else "?broadcaster_id=" + channel_id), [USER_AGENT, "Authorization: Bearer " + token["access_token"], "Client-Id:" + client_id, "Content-Type: application/json"], HTTPClient.METHOD_GET)
	var reply : Array = await(request.request_completed)
	var response : Dictionary = JSON.parse_string(reply[3].get_string_from_utf8())
	var mappings : Dictionary = {}
	for entry in response["data"]:
		if (!mappings.has(entry["set_id"])):
			mappings[entry["set_id"]] = {"versions": {}}
		for version in entry["versions"]:
			mappings[entry["set_id"]]["versions"][version["id"]] = version
	request.queue_free()
	if (reply[1] == HTTPClient.RESPONSE_OK):
		caches[RequestType.BADGE_MAPPING][channel_id] = mappings
		if (disk_cache):
			DirAccess.make_dir_recursive_absolute(filename.get_base_dir())
			var file : FileAccess = FileAccess.open(filename, FileAccess.WRITE)
			file.store_string(JSON.stringify(mappings))
	else:
		print("Could not retrieve badge mapping for channel_id " + channel_id + ".")
		return {}
	return caches[RequestType.BADGE_MAPPING][channel_id]

func data_received(data : PackedByteArray) -> void:
	var messages : PackedStringArray = data.get_string_from_utf8().strip_edges(false).split("\r\n")
	var tags = {}
	for message in messages:
		if(message.begins_with("@")):
			var msg : PackedStringArray = message.split(" ", false, 1)
			message = msg[1]
			for tag in msg[0].split(";"):
				var pair = tag.split("=")
				tags[pair[0]] = pair[1]
		if (OS.is_debug_build()):
			print("> " + message)
		handle_message(message, tags)

# Registers a command on an object with a func to call, similar to connect(signal, instance, func).
func add_command(cmd_name : String, callable : Callable, max_args : int = 0, min_args : int = 0, permission_level : int = PermissionFlag.EVERYONE, where : int = WhereFlag.CHAT) -> void:
	commands[cmd_name] = CommandData.new(callable, permission_level, max_args, min_args, where)

# Removes a single command or alias.
func remove_command(cmd_name : String) -> void:
	commands.erase(cmd_name)

# Removes a command and all associated aliases.
func purge_command(cmd_name : String) -> void:
	var to_remove = commands.get(cmd_name)
	if(to_remove):
		var remove_queue = []
		for command in commands.keys():
			if(commands[command].func_ref == to_remove.func_ref):
				remove_queue.append(command)
		for queued in remove_queue:
			commands.erase(queued)

func add_alias(cmd_name : String, alias : String) -> void:
	if(commands.has(cmd_name)):
		commands[alias] = commands.get(cmd_name)

func add_aliases(cmd_name : String, aliases : PackedStringArray) -> void:
	for alias in aliases:
		add_alias(cmd_name, alias)

func handle_message(message : String, tags : Dictionary) -> void:
	if(message == "PING :tmi.twitch.tv"):
		send("PONG :tmi.twitch.tv")
		pong.emit()
		return
	var msg : PackedStringArray = message.split(" ", true, 3)
	match msg[1]:
		"NOTICE":
			var info : String = msg[3].right(-1)
			if (info == "Login authentication failed" || info == "Login unsuccessful"):
				print_debug("Authentication failed.")
				login_attempt.emit(false)
			elif (info == "You don't have permission to perform that action"):
				print_debug("No permission. Check if access token is still valid. Aborting.")
				user_token_invalid.emit()
				set_process(false)
			else:
				unhandled_message.emit(message, tags)
		"001":
			print_debug("Authentication successful.")
			login_attempt.emit(true)
		"PRIVMSG":
			var sender_data : SenderData = SenderData.new(user_regex.search(msg[0]).get_string(), msg[2], tags)
			handle_command(sender_data, msg[3].split(" ", true, 1))
			chat_message.emit(sender_data, msg[3].right(-1))
		"WHISPER":
			var sender_data : SenderData = SenderData.new(user_regex.search(msg[0]).get_string(), msg[2], tags)
			handle_command(sender_data, msg[3].split(" ", true, 1), true)
			whisper_message.emit(sender_data, msg[3].right(-1))
		"RECONNECT":
			twitch_restarting = true
		"USERSTATE", "ROOMSTATE":
			var room = msg[2].right(-1)
			if (!last_state.has(room)):
				last_state[room] = tags
				channel_data_received.emit(room)
			else:
				for key in tags:
					last_state[room][key] = tags[key]
		_:
			unhandled_message.emit(message, tags)

func handle_command(sender_data : SenderData, msg : PackedStringArray, whisper : bool = false) -> void:
	if(command_prefixes.has(msg[0].substr(1, 1))):
		var command : String  = msg[0].right(-2)
		var cmd_data : CommandData = commands.get(command)
		if(cmd_data):
			if(whisper == true && cmd_data.where & WhereFlag.WHISPER != WhereFlag.WHISPER):
				return
			elif(whisper == false && cmd_data.where & WhereFlag.CHAT != WhereFlag.CHAT):
				return
			var args = "" if msg.size() == 1 else msg[1]
			var arg_ary : PackedStringArray = PackedStringArray() if args == "" else args.split(" ")
			if(arg_ary.size() > cmd_data.max_args && cmd_data.max_args != -1 || arg_ary.size() < cmd_data.min_args):
				cmd_invalid_argcount.emit(command, sender_data, cmd_data, arg_ary)
				print_debug("Invalid argcount!")
				return
			if(cmd_data.permission_level != 0):
				var user_perm_flags = get_perm_flag_from_tags(sender_data.tags)
				if(user_perm_flags & cmd_data.permission_level == 0):
					cmd_no_permission.emit(command, sender_data, cmd_data, arg_ary)
					print_debug("No Permission for command!")
					return
			if(arg_ary.size() == 0):
				cmd_data.func_ref.call(CommandInfo.new(sender_data, command, whisper))
			else:
				cmd_data.func_ref.call(CommandInfo.new(sender_data, command, whisper), arg_ary)

func get_perm_flag_from_tags(tags : Dictionary) -> int:
	var flag = 0
	var entry = tags.get("badges")
	if(entry):
		for badge in entry.split(","):
			if(badge.begins_with("vip")):
				flag += PermissionFlag.VIP
			if(badge.begins_with("broadcaster")):
				flag += PermissionFlag.STREAMER
	entry = tags.get("mod")
	if(entry):
		if(entry == "1"):
			flag += PermissionFlag.MOD
	entry = tags.get("subscriber")
	if(entry):
		if(entry == "1"):
			flag += PermissionFlag.SUB
	return flag

func join_channel(channel : String) -> void:
	var lower_channel : String = channel.to_lower()
	channels[lower_channel] = {}
	send("JOIN #" + lower_channel)

func leave_channel(channel : String) -> void:
	var lower_channel : String = channel.to_lower()
	send("PART #" + lower_channel)
	channels.erase(lower_channel)
GST2            ����                        �   RIFF�   WEBPVP8L�   /�7��m�*e�߱�Q 	CBR�TԶT��,�k & (�����ɛIo�
��6����6�9�ĭDC..��w�/B����O������.�'���`��f5��u�`:^�O�z<�1?�}c$����X]G�Kꭹ      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://rkm6ge1nohu1"
path="res://.godot/imported/icon.png-b5cf707f4ba91fefa5df60a746e02900.ctex"
metadata={
"vram_texture": false
}
 extends Button

func _pressed():
	%Gift.chat(%LineEdit.text)
	var channel : String = %Gift.channels.keys()[0]
	%Gift.handle_command(SenderData.new(%Gift.username, channel, %Gift.last_state[channel]), (":" + %LineEdit.text).split(" ", true, 1))
	%LineEdit.text = ""
       extends VBoxContainer

func put_chat(senderdata : SenderData, msg : String):
	var msgnode : Control = preload("res://example/ChatMessage.tscn").instantiate()
	var time = Time.get_time_dict_from_system()
	var badges : String = ""
	for badge in senderdata.tags["badges"].split(",", false):
		var result = await(%Gift.get_badge(badge, senderdata.tags["room-id"]))
		badges += "[img=center]" + result.resource_path + "[/img] "
	var locations : Array = []
	if (senderdata.tags.has("emotes")):
		for emote in senderdata.tags["emotes"].split("/", false):
			var data : Array = emote.split(":")
			for d in data[1].split(","):
				var start_end = d.split("-")
				locations.append(EmoteLocation.new(data[0], int(start_end[0]), int(start_end[1])))
	locations.sort_custom(Callable(EmoteLocation, "smaller"))
	var offset = 0
	for loc in locations:
		var result = await(%Gift.get_emote(loc.id))
		var emote_string = "[img=center]" + result.resource_path +"[/img]"
		msg = msg.substr(0, loc.start + offset) + emote_string + msg.substr(loc.end + offset + 1)
		offset += emote_string.length() + loc.start - loc.end - 1
	var bottom : bool = $Chat/ScrollContainer.scroll_vertical == $Chat/ScrollContainer.get_v_scroll_bar().max_value - $Chat/ScrollContainer.get_v_scroll_bar().get_rect().size.y
	msgnode.set_msg("%02d:%02d" % [time["hour"], time["minute"]], senderdata, msg, badges)
	$Chat/ScrollContainer/ChatMessagesContainer.add_child(msgnode)
	await(get_tree().process_frame)
	if (bottom):
		$Chat/ScrollContainer.scroll_vertical = $Chat/ScrollContainer.get_v_scroll_bar().max_value

class EmoteLocation extends RefCounted:
	var id : String
	var start : int
	var end : int

	func _init(emote_id, start_idx, end_idx):
		self.id = emote_id
		self.start = start_idx
		self.end = end_idx

	static func smaller(a : EmoteLocation, b : EmoteLocation):
		return a.start < b.start
             extends HBoxContainer

func set_msg(stamp : String, data : SenderData, msg : String, badges : String) -> void:
	$RichTextLabel.text = stamp + " " + badges + "[b][color="+ data.tags["color"] + "]" + data.tags["display-name"] +"[/color][/b]: " + msg
	queue_sort()
          RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://example/ChatMessage.gd ��������      local://PackedScene_djdix          PackedScene          	         names "         ChatMessage    size_flags_horizontal    script    HBoxContainer    RichTextLabel    layout_mode    focus_mode    bbcode_enabled    fit_content    scroll_active    selection_enabled    	   variants                                                node_count             nodes         ��������       ����                                  ����                                  	      
                conn_count              conns               node_paths              editable_instances              version             RSRC          RSRC                    Environment            ��������                                            d      resource_local_to_scene    resource_name    sky_material    process_mode    radiance_size    script    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction        
   local://1 Q	         local://Environment_pbst5 e	         Sky             Environment                                RSRC               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://example/Gift.gd ��������   Script    res://example/ChatContainer.gd ��������   Script    res://example/LineEdit.gd ��������   Script    res://example/Button.gd ��������      local://PackedScene_put3d �         PackedScene          	         names "         Example    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Control    Gift    unique_name_in_owner    script    scopes    Node    ChatContainer    VBoxContainer    Chat    show_behind_parent    size_flags_horizontal    size_flags_vertical    Panel    ScrollContainer    follow_focus    ChatMessagesContainer    HBoxContainer 	   LineEdit    caret_blink    Button    text    	   variants                        �?                               
   chat:edit    
   chat:read       moderator:read:followers                                Send                node_count    	         nodes     �   ��������       ����                                                          ����   	      
                              ����   	                        
                       ����                                              ����                                            ����                                        ����                          ����   	                                
   	                    ����   	               
   
                conn_count              conns               node_paths              editable_instances              version             RSRC             extends Gift

signal command_check(msg)

func _ready() -> void:
	cmd_no_permission.connect(no_permission)
	chat_message.connect(on_chat)
	event.connect(on_event)

	# I use a file in the working directory to store auth data
	# so that I don't accidentally push it to the repository.
	# Replace this or create a auth file with 3 lines in your
	# project directory:
	# <client_id>
	# <client_secret>
	# <initial channel>
	var authfile := FileAccess.open("./example/auth.txt", FileAccess.READ)
	client_id = authfile.get_line()
	client_secret = authfile.get_line()
	var initial_channel = authfile.get_line()

	# When calling this method, a browser will open.
	# Log in to the account that should be used.
	await(authenticate(client_id, client_secret))
	var success = await(connect_to_irc())
	if (success):
		request_caps()
		join_channel(initial_channel)
		await(channel_data_received)
	await(connect_to_eventsub()) # Only required if you want to receive EventSub events.
	# Refer to https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/ for details on
	# what events exist, which API versions are available and which conditions are required.
	# Make sure your token has all required scopes for the event.
	subscribe_event("channel.follow", 2, {"broadcaster_user_id": user_id, "moderator_user_id": user_id})

	# Adds a command with a specified permission flag.
	# All implementations must take at least one arg for the command info.
	# Implementations that recieve args requrires two args,
	# the second arg will contain all params in a PackedStringArray
	# This command can only be executed by VIPS/MODS/SUBS/STREAMER
	add_command("test", command_test, 0, 0, PermissionFlag.NON_REGULAR)

	# These two commands can be executed by everyone
	add_command("helloworld", hello_world)
	add_command("greetme", greet_me)

	# This command can only be executed by the streamer
	add_command("streamer_only", streamer_only, 0, 0, PermissionFlag.STREAMER)

	# Command that requires exactly 1 arg.
	add_command("greet", greet, 1, 1)

	# Command that prints every arg seperated by a comma (infinite args allowed), at least 2 required
	add_command("list", list, -1, 2)

	# Adds a command alias
	add_alias("test","test1")
	add_alias("test","test2")
	add_alias("test","test3")
	# Or do it in a single line
	# add_aliases("test", ["test1", "test2", "test3"])

	# Remove a single command
	remove_command("test2")

	# Now only knows commands "test", "test1" and "test3"
	remove_command("test")
	# Now only knows commands "test1" and "test3"

	# Remove all commands that call the same function as the specified command
	purge_command("test1")
	# Now no "test" command is known

	# Send a chat message to the only connected channel (<channel_name>)
	# Fails, if connected to more than one channel.
#	chat("TEST")

	# Send a chat message to channel <channel_name>
#	chat("TEST", initial_channel)

	# Send a whisper to target user (requires user:manage:whispers scope)
#	whisper("TEST", initial_channel)

func on_event(type : String, data : Dictionary) -> void:
	match(type):
		"channel.follow":
			print("%s followed your channel!" % data["user_name"])

func on_chat(data : SenderData, msg : String) -> void:
	%ChatContainer.put_chat(data, msg)
	command_check.emit(msg)

# Check the CommandInfo class for the available info of the cmd_info.
func command_test(cmd_info : CommandInfo) -> void:
	print("A")

func hello_world(cmd_info : CommandInfo) -> void:
	chat("HELLO WORLD!")

func streamer_only(cmd_info : CommandInfo) -> void:
	chat("Streamer command executed")

func no_permission(cmd_info : CommandInfo) -> void:
	chat("NO PERMISSION!")

func greet(cmd_info : CommandInfo, arg_ary : PackedStringArray) -> void:
	chat("Greetings, " + arg_ary[0])

func greet_me(cmd_info : CommandInfo) -> void:
	chat("Greetings, " + cmd_info.sender_data.tags["display-name"] + "!")

func list(cmd_info : CommandInfo, arg_ary : PackedStringArray) -> void:
	var msg = ""
	for i in arg_ary.size() - 1:
		msg += arg_ary[i]
		msg += ", "
	msg += arg_ary[arg_ary.size() - 1]
	chat(msg)
               GST2   �   �      ����               � �          RIFF  WEBPVP8L  /�?��m�*e�߱�Q 	CBR�TԶT��,�k & (�� @�{'o&��+ ��6�$�(��0�BQh
ſZ�Շ4��#���ܶ$�83k/�W�cPU�A��,S#��b���k��LU`?O�RO1Ss���L��N�_����`�"���ೖ��tm�-��gȕ6p}���J?G�_��N�ݱ���d��p˼2z~��f�g����^��D��}��=?fg1�@�9O}o	Pw����,��%�%W`}�` [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://ck2181giqo3ep"
path="res://.godot/imported/icon.png-5ad2e6e2e39e89ee29d5171fb300a340.ctex"
metadata={
"vram_texture": false
}
                extends LineEdit

func _input(event : InputEvent):
	if (event is InputEventKey):
		if (event.pressed && event.keycode == KEY_ENTER):
			%Button._pressed()
     extends Node

var filtered_words: PackedStringArray = load_filtered_words()

func load_filtered_words() -> PackedStringArray:
	var filtered_words_file = FileAccess.open("res://filtered_words.txt", FileAccess.READ)
	var filtered_words = []
	
	if filtered_words_file:
		while not filtered_words_file.eof_reached():
			filtered_words.append(filtered_words_file.get_line().strip_edges())
		
		filtered_words_file.close()
	
	return PackedStringArray(filtered_words)

func filter_words(message: String) -> String:
	var filtered_message = message.to_lower()
	
	for filter_word in filtered_words:
		filtered_message = filtered_message.replace(filter_word, "kittens")
	
	return filtered_message
  GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bidflplrd078j"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                extends Control

@onready var gift = %Gift
@onready var tts_volume_slider: HSlider = %Volume
@onready var tts_status: Label = %Status

var voices = DisplayServer.tts_get_voices_for_language("en")
var voice_id = voices[0]

@onready var tts_volume: int = tts_volume_slider.value

var tts_queue = []

func _ready():
	gift.command_check.connect(_on_command_check)
	print(voices)

func _process(delta):
	if not DisplayServer.tts_is_speaking() and tts_queue.size() > 0:
		play_next_tts()

func _on_command_check(msg) -> void:
	var prefix = msg.split(" ")[0].to_lower()
	var message = msg.trim_prefix(prefix).strip_edges()
	
	var filtered_message = Filter.filter_words(message)
	
	match prefix:
		"!tts":
			tts_queue.append(filtered_message)
		_:
			pass

func play_next_tts() -> void:
	if tts_queue.size() > 0:
		var tts_message = tts_queue.pop_front()
		DisplayServer.tts_speak(tts_message, voice_id, tts_volume)

func _on_volume_value_changed(value):
	tts_volume = value


func _on_pause_pressed():
	DisplayServer.tts_pause()
	tts_status.text = "Paused"


func _on_resume_pressed():
	DisplayServer.tts_resume()
	tts_status.text = "Playing"


func _on_stop_pressed():
	DisplayServer.tts_stop()
	tts_status.text = "Skipped"
             RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://main.gd ��������   Script    res://example/Gift.gd ��������   Script    res://example/ChatContainer.gd ��������   Script    res://example/LineEdit.gd ��������   Script    res://example/Button.gd ��������      local://PackedScene_43rqh �         PackedScene          	         names "   1      Main    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    Control 
   ColorRect    offset_right    offset_bottom    color    Gift    unique_name_in_owner    scopes    Node    ChatContainer    VBoxContainer    Chat    show_behind_parent    size_flags_horizontal    size_flags_vertical    Panel    ScrollContainer    follow_focus    ChatMessagesContainer    HBoxContainer    visible 	   LineEdit    caret_blink    Button    text    Label    offset_left    offset_top    Volume    value    HSlider    Pause    Resume    Skip    Status    _on_volume_value_changed    value_changed    _on_pause_pressed    pressed    _on_resume_pressed    _on_stop_pressed    	   variants    '                    �?                            �D     4D                 �?                        
   chat:edit    
   chat:read       moderator:read:followers            �D                               Send               �D     "D     �D    �'D      TTS Volume      *D     .D     HB     D     �D     D      P      �D     �D      R      �D     �D      S      
D    �D      node_count             nodes       ��������       ����                                                          	   	   ����         
                                    ����      	      
                           ����      	         
                                   ����      	                                        ����                        	                    ����                                        ����                                ����      	                          	                          ����      	                                  !   !   ����         "      #      
                               &   $   ����      	         "      #      
            %                     '   ����         "      #      
                                  (   ����         "      #      
                 !                  )   ����         "   "   #      
   #             $               !   *   ����      	         "      #   %   
   #      &             conn_count             conns               ,   +                     .   -                     .   /                     .   0                    node_paths              editable_instances              version             RSRC               [remap]

path="res://.godot/exported/133200997/export-e17866073d83b6c9cbf994962ff51aa1-ChatMessage.scn"
        [remap]

path="res://.godot/exported/133200997/export-c9c19e80cc69005c6d7e347b60e9153f-default_env.res"
        [remap]

path="res://.godot/exported/133200997/export-92f93b24126de25f8b8804731f421411-Example.scn"
            [remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
               list=Array[Dictionary]([{
"base": &"RefCounted",
"class": &"BufferedHTTPClient",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/communication/buffered_http_client.gd"
}, {
"base": &"RefCounted",
"class": &"Command",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_command_data.gd"
}, {
"base": &"RefCounted",
"class": &"CommandData",
"icon": "",
"language": &"GDScript",
"path": "res://addons/gift/util/cmd_data.gd"
}, {
"base": &"RefCounted",
"class": &"CommandInfo",
"icon": "",
"language": &"GDScript",
"path": "res://addons/gift/util/cmd_info.gd"
}, {
"base": &"RefCounted",
"class": &"Generator",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/editor/twitch_api_generator.gd"
}, {
"base": &"EditorImportPlugin",
"class": &"GifImporterImagemagick",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/imagemagick/gif_importer_imagemagick.gd"
}, {
"base": &"EditorImportPlugin",
"class": &"GifImporterNative",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/native/GIF2SpriteFramesPlugin.gd"
}, {
"base": &"RefCounted",
"class": &"GifReader",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/native/GIFReader.gd"
}, {
"base": &"Node",
"class": &"Gift",
"icon": "",
"language": &"GDScript",
"path": "res://addons/gift/gift_node.gd"
}, {
"base": &"RefCounted",
"class": &"HTTPServer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/communication/http_server.gd"
}, {
"base": &"Object",
"class": &"HttpUtil",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/communication/http_util.gd"
}, {
"base": &"Node",
"class": &"ImageMagickConverter",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/imagemagick/image_magick_converter.gd"
}, {
"base": &"TwitchImageTransformer",
"class": &"MagicImageTransformer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/magic_image_transformer.gd"
}, {
"base": &"TwitchImageTransformer",
"class": &"NativeImageTransformer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/native_image_transformer.gd"
}, {
"base": &"RefCounted",
"class": &"SenderData",
"icon": "",
"language": &"GDScript",
"path": "res://addons/gift/util/sender_data.gd"
}, {
"base": &"RefCounted",
"class": &"SimpleTemplate",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/editor/simple_template.gd"
}, {
"base": &"RichTextEffect",
"class": &"SpriteFrameEffect",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/sprite_frame_effect.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAddBlockedTermBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_add_blocked_term_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAddBlockedTermResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_add_blocked_term_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAnnouncementColor",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_announcement_color.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAuth",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/authorization/twitch_auth.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAutoModSettings",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_auto_mod_settings.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchAutoModStatus",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_auto_mod_status.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBanUserBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_ban_user_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBanUserResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_ban_user_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBannedUser",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_banned_user.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBitsLeaderboard",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_bits_leaderboard.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBlockedTerm",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_blocked_term.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchBroadcasterSubscription",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_broadcaster_subscription.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCategory",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_category.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannel",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannelEditor",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel_editor.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannelEmote",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel_emote.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannelInformation",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel_information.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannelStreamScheduleSegment",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel_stream_schedule_segment.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChannelTeam",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_channel_team.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCharityCampaign",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_charity_campaign.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCharityCampaignDonation",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_charity_campaign_donation.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChatBadge",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_chat_badge.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChatSettings",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_chat_settings.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChatSettingsUpdated",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_chat_settings_updated.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchChatter",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_chatter.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheckAutoModStatusBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_check_auto_mod_status_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheckAutoModStatusResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_check_auto_mod_status_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheckUserSubscriptionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_check_user_subscription_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheerRepository",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_cheer_repository.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheermote",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_cheermote.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheermoteImageFormat",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_cheermote_image_format.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheermoteImageTheme",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_cheermote_image_theme.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCheermoteImages",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_cheermote_images.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchClip",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_clip.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCommandHandler",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_command_handler.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCommandInfo",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_command_info.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchContentClassificationLabel",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_content_classification_label.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateChannelStreamScheduleSegmentBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_channel_stream_schedule_segment_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateChannelStreamScheduleSegmentResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_channel_stream_schedule_segment_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateClipResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_clip_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateConduitsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_conduits_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateConduitsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_conduits_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateCustomRewardsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_custom_rewards_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateCustomRewardsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_custom_rewards_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateEventSubSubscriptionBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_event_sub_subscription_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateEventSubSubscriptionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_event_sub_subscription_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateExtensionSecretResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_extension_secret_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateGuestStarSessionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_guest_star_session_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreatePollBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_poll_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreatePollResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_poll_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreatePredictionBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_prediction_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreatePredictionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_prediction_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateStreamMarkerBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_stream_marker_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreateStreamMarkerResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_create_stream_marker_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCreatorGoal",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_creator_goal.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCustomReward",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_custom_reward.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchCustomRewardRedemption",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_custom_reward_redemption.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchDeleteVideosResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_delete_videos_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchDropsEntitlement",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_drops_entitlement.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchDropsEntitlementUpdated",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_drops_entitlement_updated.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEmote",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_emote.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEmoteDefinition",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_emote_definition.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEndGuestStarSessionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_end_guest_star_session_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEndPollBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_end_poll_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEndPollResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_end_poll_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEndPredictionBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_end_prediction_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEndPredictionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_end_prediction_response.gd"
}, {
"base": &"Node",
"class": &"TwitchEventListener",
"icon": "res://addons/twitcher/assets/event-icon.svg",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_event_listener.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEventSubSubscription",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_event_sub_subscription.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchEventsub",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_eventsub.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtension",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionAnalytics",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_analytics.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionBitsProduct",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_bits_product.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionConfigurationSegment",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_configuration_segment.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionIconUrls",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_icon_urls.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionLiveChannel",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_live_channel.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionSecret",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_secret.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchExtensionTransaction",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_extension_transaction.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGame",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_game.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGameAnalytics",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_game_analytics.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetAdScheduleResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_ad_schedule_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetAllStreamTagsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_all_stream_tags_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetAutoModSettingsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_auto_mod_settings_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetBannedUsersResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_banned_users_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetBitsLeaderboardResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_bits_leaderboard_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetBlockedTermsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_blocked_terms_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetBroadcasterSubscriptionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_broadcaster_subscriptions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelChatBadgesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_chat_badges_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelEditorsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_editors_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelEmotesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_emotes_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelFollowersResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_followers_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelGuestStarSettingsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_guest_star_settings_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelInformationResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_information_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelStreamScheduleResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_stream_schedule_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChannelTeamsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_channel_teams_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCharityCampaignDonationsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_charity_campaign_donations_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCharityCampaignResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_charity_campaign_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChatSettingsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_chat_settings_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetChattersResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_chatters_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCheermotesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_cheermotes_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetClipsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_clips_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetConduitShardsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_conduit_shards_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetConduitsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_conduits_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetContentClassificationLabelsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_content_classification_labels_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCreatorGoalsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_creator_goals_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCustomRewardRedemptionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_custom_reward_redemption_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetCustomRewardResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_custom_reward_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetDropsEntitlementsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_drops_entitlements_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetEmoteSetsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_emote_sets_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetEventSubSubscriptionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_event_sub_subscriptions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionAnalyticsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_analytics_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionBitsProductsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_bits_products_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionConfigurationSegmentResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_configuration_segment_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionLiveChannelsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_live_channels_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionSecretsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_secrets_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionTransactionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extension_transactions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetExtensionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_extensions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetFollowedChannelsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_followed_channels_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetFollowedStreamsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_followed_streams_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGameAnalyticsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_game_analytics_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGamesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_games_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGlobalChatBadgesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_global_chat_badges_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGlobalEmotesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_global_emotes_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGuestStarInvitesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_guest_star_invites_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetGuestStarSessionResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_guest_star_session_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetHypeTrainEventsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_hype_train_events_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetModeratedChannelsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_moderated_channels_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetModeratorsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_moderators_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetPollsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_polls_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetPredictionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_predictions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetReleasedExtensionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_released_extensions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetShieldModeStatusResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_shield_mode_status_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetStreamKeyResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_stream_key_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetStreamMarkersResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_stream_markers_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetStreamTagsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_stream_tags_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetStreamsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_streams_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetTeamsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_teams_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetTopGamesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_top_games_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetUserActiveExtensionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_user_active_extensions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetUserBlockListResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_user_block_list_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetUserChatColorResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_user_chat_color_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetUserExtensionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_user_extensions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetUsersResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_users_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetVIPsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_vi_ps_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGetVideosResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_get_videos_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGlobalEmote",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_global_emote.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGuestStarInvite",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_guest_star_invite.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchGuestStarSession",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_guest_star_session.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchHypeTrainEvent",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_hype_train_event.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchIRC",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_irc.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchIconLoader",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_icon_loader.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchImageTransformer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/image_transformer/twitch_image_transformer.gd"
}, {
"base": &"Object",
"class": &"TwitchIrcCapabilities",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_irc_capabilities.gd"
}, {
"base": &"Node",
"class": &"TwitchIrcChannel",
"icon": "res://addons/twitcher/assets/chat-icon.svg",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_irc_channel.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchKeepaliveMessage",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_keepalive_message.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchLogger",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_logger.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchLoggerManager",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_logger_manager.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchManageHeldAutoModMessagesBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_manage_held_auto_mod_messages_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchModifyChannelInformationBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_modify_channel_information_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchNotificationMessage",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_notification_message.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchPoll",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_poll.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchPrediction",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_prediction.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchPredictionOutcome",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_prediction_outcome.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchReconnectMessage",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_reconnect_message.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchRestAPI",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_rest_api.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchRevocationMessage",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_revocation_message.gd"
}, {
"base": &"Object",
"class": &"TwitchScopes",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_scopes.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSearchCategoriesResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_search_categories_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSearchChannelsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_search_channels_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendChatAnnouncementBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_chat_announcement_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendChatMessageBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_chat_message_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendChatMessageResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_chat_message_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendExtensionChatMessageBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_extension_chat_message_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendExtensionPubSubMessageBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_extension_pub_sub_message_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSendWhisperBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_send_whisper_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSetExtensionConfigurationSegmentBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_set_extension_configuration_segment_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSetExtensionRequiredConfigurationBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_set_extension_required_configuration_body.gd"
}, {
"base": &"Object",
"class": &"TwitchSetting",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_setting.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchSnoozeNextAdResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_snooze_next_ad_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStartCommercialBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_start_commercial_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStartCommercialResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_start_commercial_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStartRaidResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_start_raid_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStream",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_stream.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStreamMarkerCreated",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_stream_marker_created.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStreamMarkers",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_stream_markers.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchStreamTag",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_stream_tag.gd"
}, {
"base": &"Object",
"class": &"TwitchSubscriptions",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_subscriptions.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchTags",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/twitch_tags.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchTeam",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_team.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchTokenHandler",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/authorization/twitch_token_handler.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchTokens",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/authorization/twitch_token.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateAutoModSettingsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_auto_mod_settings_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateAutoModSettingsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_auto_mod_settings_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateChannelGuestStarSettingsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_channel_guest_star_settings_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateChannelStreamScheduleSegmentBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_channel_stream_schedule_segment_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateChannelStreamScheduleSegmentResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_channel_stream_schedule_segment_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateChatSettingsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_chat_settings_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateChatSettingsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_chat_settings_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateConduitShardsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_conduit_shards_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateConduitShardsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_conduit_shards_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateConduitsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_conduits_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateConduitsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_conduits_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateCustomRewardBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_custom_reward_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateCustomRewardResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_custom_reward_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateDropsEntitlementsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_drops_entitlements_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateDropsEntitlementsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_drops_entitlements_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateExtensionBitsProductBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_extension_bits_product_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateExtensionBitsProductResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_extension_bits_product_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateRedemptionStatusBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_redemption_status_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateRedemptionStatusResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_redemption_status_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateShieldModeStatusBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_shield_mode_status_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateShieldModeStatusResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_shield_mode_status_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateUserExtensionsBody",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_user_extensions_body.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateUserExtensionsResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_user_extensions_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUpdateUserResponse",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_update_user_response.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUser",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserBlockList",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_block_list.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserChatColor",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_chat_color.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtension",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionComponent",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_component.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionComponentUpdate",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_component_update.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionOverlay",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_overlay.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionOverlayUpdate",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_overlay_update.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionPanel",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_panel.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserExtensionPanelUpdate",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_extension_panel_update.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserModerator",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_moderator.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserSubscription",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_subscription.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchUserVip",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_user_vip.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchVideo",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/generated/twitch_video.gd"
}, {
"base": &"RefCounted",
"class": &"TwitchWelcomeMessage",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/eventsub/twitch_welcome_message.gd"
}, {
"base": &"RefCounted",
"class": &"WebsocketClient",
"icon": "",
"language": &"GDScript",
"path": "res://addons/twitcher/communication/websocket_client.gd"
}])
        <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �>3�1C�   res://addons/gift/icon.png<<PD��   res://example/ChatMessage.tscn؄��*�#   res://example/Example.tscn���A���L   res://example/icon.png�֜DYO )   res://icon.svg�?CZ�r   res://main.tscn               ECFG      application/config/name         SikeBot    application/run/main_scene         res://main.tscn    application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg     audio/general/text_to_speech            autoload/TwitchService0      (   *res://addons/twitcher/twitch_service.gd   autoload/HttpClientManagerD      ;   *res://addons/twitcher/communication/http_client_manager.gd    autoload/Filter         *res://filter.gd"   display/window/size/viewport_width         #   display/window/size/viewport_height      �     display/window/size/resizable             display/window/stretch/aspect         ignore     editor_plugins/enabled,   "         res://addons/gift/plugin.cfg       twitch/auth/broadcaster_id         97097808   twitch/auth/client_id(         qt7immd0k4yjefc5np4xe4azyz7m34     twitch/auth/client_secret(         s1qrsiwshm2g6yxxgmoddz687ncoxh     twitch/auth/scopes/chat            twitch/websocket/irc/username         SikeBotTest  