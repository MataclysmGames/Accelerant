class_name DialogueMolly extends DialogueEntity

static var _singleton : DialogueMolly = null

static func singleton() -> DialogueMolly:
	if not _singleton:
		_singleton = DialogueMolly.new()
	return _singleton
		
func _init():
	default_dialogue = "reception_welcome"
	dialogue_progression = [
		["reception_welcome", "reception_welcome_final"],
		["standup_done", "reception_standard"],
	]
	dialogue_builders = [
		DialogueBuilder.new("reception_welcome").with_header("Receptionist")
			.with_content("Welcome to [rainbow]Accelerant![/rainbow] My name is Molly.")
			.with_header("Molly").with_content_list([
				"You must be the new database engineer! Are you ready to get started?"
			])
			.with_choices("", [Choice.new("1", "Yep!", "reception_welcome_yes"), Choice.new("2", "Not really", "reception_welcome_no"), Choice.new("3", "...", "reception_welcome_no")]),
		
		DialogueBuilder.new("reception_welcome_yes").with_header("Molly")
			.with_content("Alright! Love the positive attitude! I think you're really going to like it here :)")
			.with_next_id("reception_welcome_middle"),
			
		DialogueBuilder.new("reception_welcome_no").with_header("Molly")
			.with_content("Sounds like someone's got a case of the Mondays! Hahaha")
			.with_next_id("reception_welcome_middle"),
		
		DialogueBuilder.new("reception_welcome_middle").with_header("Molly")
			.with_content("Here's your badge to access the office.")
			.with_receive_item("Office Access Badge")
			.with_content("Welcome aboard!")
			.with_next_id("reception_welcome_final"),
		
		DialogueBuilder.new("reception_welcome_final").with_header("Molly")
			.with_content_list([
				"Your team should be meeting for stand-up any minute now.",
				"Head up to the main office in the next room and then go right."
			]),
		DialogueBuilder.new("reception_standard").with_header("Molly").with_content_list([
			"I hope you're getting settled in.",
			"The last guy that had your job was here for 45 years."
		]),
	]
	super()
