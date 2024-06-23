extends Node

var filtered_words: PackedStringArray = load_filtered_words()

func load_filtered_words() -> PackedStringArray:
	var filtered_words_file = FileAccess.open("res://filtered_words.txt", FileAccess.READ)
	filtered_words = []
	
	if filtered_words_file:
		while not filtered_words_file.eof_reached():
			filtered_words.append(filtered_words_file.get_line().strip_edges())
		
		filtered_words_file.close()
	
	return PackedStringArray(filtered_words)

func filter_words(message: String) -> String:
	var filtered_message = message
	
	return filtered_message
