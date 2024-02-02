extends Node

signal dialogue_activated()
signal dialogue_deactivated()

signal receive_item(item_name : String)
signal message(message : String, sender : String)

signal cell_activated(name : String, x : int, y : int)
