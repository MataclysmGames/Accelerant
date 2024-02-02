class_name DialogueOmar extends DialogueEntity

static var _singleton : DialogueOmar = null

static func singleton() -> DialogueOmar:
	if not _singleton:
		_singleton = DialogueOmar.new()
	return _singleton

func _init():
	default_dialogue = "omar_welcome"
	dialogue_progression = [
		["omar_welcome_end", "omar_welcome_end"],
		["daniel_active_users_complete", "omar_set_expenses"],
		["omar_set_expenses_end", "omar_set_expenses_end"],
		["chapter_1_finish", "omar_set_expenses_complete"],
		["omar_set_expenses_complete_end", "omar_set_expenses_complete_end"],
	]
	dialogue_builders = [
		DialogueBuilder.new("omar_welcome").with_header("Omar").with_content_list([
			"So you really think you can handle this job, eh?"
		]).with_choices("", [Choice.new("1", "Yes", "omar_welcome_yes"), Choice.new("2", "No", "omar_welcome_no")]),
		
		DialogueBuilder.new("omar_welcome_yes").with_header("Omar").with_content_list([
			"Bah, the arrogance. You'll never be Tom."
		]).with_next_id("omar_welcome_end"),
		
		DialogueBuilder.new("omar_welcome_no").with_header("Omar").with_content_list([
			"Hmm... so you've got some sense in ya after all."
		]).with_next_id("omar_welcome_end"),
		
		DialogueBuilder.new("omar_welcome_end").with_header("Omar").with_content_list([
			"Just don't go startin' any fires, alright?",
			"I've got enough stress already."
		]),
		
		DialogueBuilder.new("omar_set_expenses").with_header("Omar").with_content_list([
			"So I hear you gave the active user count to Daniel.",
			"That's no small feat. Tom would spend hours 'trudging through the levels' to get that data to us.",
			"No one ever knew what he was talking about. But genius is often misunderstood.",
			"You might be more competent than I thought.",
		]).with_next_id("omar_set_expenses_end"),
		
		DialogueBuilder.new("omar_set_expenses_end").with_header("Omar").with_content_list([
			"Hey, do me a favor. Set the monthly expenses in the database.",
			"This will be the true test of whether you're ready to replace Tom.",
		]).with_final_id("chapter_1_start"),
		
		DialogueBuilder.new("omar_set_expenses_complete").with_header("Omar").with_content_list([
			"Huh, well I'll be damned.",
			"You're alright kid. I think we'll get along just fine."
		]).with_next_id("omar_set_expenses_complete_end"),
		
		DialogueBuilder.new("omar_set_expenses_complete_end").with_header("Omar").with_content_list([
			"Just between you and me, I didn't think [shake]anyone[/shake] could do Tom's job.",
			"No one else here has any idea what you database guys do in there.",
			"But you get the job done and that's all that matters.",
		]),
	]
	super()
