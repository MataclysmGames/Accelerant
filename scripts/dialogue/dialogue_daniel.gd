class_name DialogueDaniel extends DialogueEntity

static var _singleton : DialogueDaniel = null

static func singleton() -> DialogueDaniel:
	if not _singleton:
		_singleton = DialogueDaniel.new()
	return _singleton
	
func _init():
	default_dialogue = "daniel_welcome"
	dialogue_progression = [
		["daniel_welcome", "daniel_active_users"],
		["chapter_0_finish", "daniel_active_users_complete"],
		["daniel_active_users_complete_end", "daniel_active_users_complete_end"],
		["chapter_1_finish", "daniel_suspicious_reports"],
		["daniel_suspicious_reports_end", "daniel_suspicious_reports_end"]
	]
	dialogue_builders = [
		DialogueBuilder.new("daniel_welcome").with_header("Daniel").with_content_list([
			"Hey bud. Nice to meet ya!",
			"If you need [rainbow]anything[/rainbow] just let me know."
		]).with_choices("", [Choice.new("1", "Will do!", "daniel_welcome_yes"), Choice.new("2", "Nah I'm good.", "daniel_welcome_no")]),
		
		DialogueBuilder.new("daniel_welcome_yes").with_header("Daniel").with_content_list([
			"Nice! Looking forward to working with you!"
		]).with_next_id("daniel_active_users"),
		
		DialogueBuilder.new("daniel_welcome_no").with_header("Daniel").with_content_list([
			"Wow, okay. Rude..."
		]).with_next_id("daniel_active_users"),
		
		DialogueBuilder.new("daniel_active_users").with_header("Daniel").with_content_list([
			"Anyway, I need to know how many active users we have right now.",
			"I think Tom said he made a 'routine' to make querying that easier. Haha whatever that means.",
			"There should be some helpful notes in your office."
		]),
		
		DialogueBuilder.new("daniel_active_users_complete").with_header("Daniel").with_content_list([
			"Wow that was quick. 37139 users, eh? Not too shabby.",
			"Seems like you're picking things up quickly.",
			"It really just goes to show how ingenious Tom's database design is.",
			"This company would be doomed without it."
		]).with_next_id("daniel_active_users_complete_end"),
		
		DialogueBuilder.new("daniel_active_users_complete_end").with_header("Daniel").with_content_list([
			"Anyway, thanks a lot for your help.",
			"You just may have what it takes."
		]),
		
		DialogueBuilder.new("daniel_suspicious_reports").with_header("Daniel").with_content_list([
			"Wowzers, you've been busy!",
			"The team hasn't been this productive in a long time.",
			"Unfortunately, I've got some bad news.",
			"Brenda says we're getting some 'suspicious activity' coming from the database.",
			"Some sort of automated alert that Tom made way back in the day.",
			"No idea what it means but Tom always seemed super annoyed whenever this happened before."
		]).with_next_id("daniel_suspicious_reports_end"),
		
		DialogueBuilder.new("daniel_suspicious_reports_end").with_header("Daniel").with_content_list([
			"Anyway, better go talk to Brenda and see if she has any info for you.",
			"Good luck!"
		]),
	]
	super()
