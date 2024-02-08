class_name DialogueBrenda extends DialogueEntity

static var _singleton : DialogueBrenda = null

static func singleton() -> DialogueBrenda:
	if not _singleton:
		_singleton = DialogueBrenda.new()
	return _singleton

func _init():
	default_dialogue = "brenda_welcome"
	dialogue_progression = [
		["daniel_suspicious_reports_end", "brenda_suspicious_reports"],
		["brenda_suspicious_reports_end", "brenda_suspicious_reports_end"],
		["chapter_2_finish", "brenda_chapter_2_finish"],
		["brenda_chapter_2_finish_end", "brenda_chapter_2_finish_end"],
		["chapter_3_finish", "brenda_fire_employee"],
		["brenda_fire_employee_end", "brenda_fire_employee_end"],
		["chapter_4_finish", "brenda_fire_employee_complete"],
	]
	dialogue_builders = [
		DialogueBuilder.new("brenda_welcome").with_header("Brenda").with_content_list([
			"Hi. Sorry I'm a little busy right now.",
			"Let's talk later."
		]),
		
		DialogueBuilder.new("brenda_suspicious_reports").with_header("Brenda").with_content_list([
			"Hmm? Suspicious activity?",
			"Oh yeah! Sorry, my mind has been all over the place today.",
			"Okay, here's the deal.",
			"Rather, here's everything I know about it.",
			"Tom set up a series of security measures in the database to prevent unauthorized access.",
			"But you may have noticed that our network is air-gapped so that the database is only accessible from our intranet.",
			"*checks notes*",
			"Yeah, that's right.",
			"This is how it's always been ever since the database was created.",
			"Tom was adamant that nothing was ever allowed to escape or it would be the end of the world.",
			"A little dramatic but geniuses have their quirks, eh? Haha",
			"...",
			"Oh right! Okay, history lesson aside, here's what you need to do.",
			"The alert generates a report that gets saved in the database.",
			"You just need to go get it and then read it to figure out what's going on.",
			"...There's just one problem.",
			"*checks notes*",
			"You need super-admin permissions to access that area of the database.",
			"And the only super-admin credentials that exist are locked in a safe in your office.",
			"Tom was supposed to leave a sticky note on your desk with the combination but he said that was 'ridiculous'.",
			"So..."
		]).with_next_id("brenda_suspicious_reports_end"),
		
		DialogueBuilder.new("brenda_suspicious_reports_end").with_header("Brenda").with_content_list([
			"I guess you need to figure out how to get into the safe first.",
			"Then hop in the database and figure out what's going wrong.",
			"Good luck!"
		]).with_final_id("suspicious_reports_need_safe"),
		
		DialogueBuilder.new("brenda_chapter_2_finish").with_header("Brenda").with_content_list([
			"Hmm? Oh hey, what's up?",
		]).with_header("").with_content("*You hand the report to Brenda*")
		.with_header("Brenda").with_content_list([
			"Oh right! The report!",
			"*quickly flips through the report*",
			"Mhmm...",
			"Yep...",
			"I see...",
			"I don't know what any of this means.",
			"Sorry, I've just got so many wheels in motion right now!",
			"Let's parking lot this for now and circle back later.",
			"I trust you'll be able to handle it.",
		]).with_next_id("brenda_chapter_2_finish_end"),
		
		DialogueBuilder.new("brenda_chapter_2_finish_end").with_header("Brenda").with_content_list([
			"Tom was the only person that understood how any of this works.",
			"Please, just [rainbow]fix it[/rainbow]!"
		]).with_next_id("chapter_3_start"),
		
		DialogueBuilder.new("brenda_fire_employee").with_header("Brenda").with_content_list([
			"Oh I don't know what to do.",
			"HR says we need to let someone go. 'Budget adjustments' they claim. Pfft.",
			"I've narrowed it down to Daniel or Omar.",
			"Omar has been here for 35 years. But Daniel consistently brings in more clients.",
			"Oh I just don't know.",
		]).with_choices("Who do you think I should fire?", [Choice.new("1", "Daniel", "brenda_fire_employee_daniel"), Choice.new("2", "Omar", "brenda_fire_employee_omar")]),
		
		DialogueBuilder.new("brenda_fire_employee_daniel").with_header("Brenda").with_content_list([
			"Hmm... Maybe you're right. Daniel will find another good job.",
			"I'll write a glowing letter of recommendation for him."
		]).with_next_id("brenda_fire_employee_end"),
		
		DialogueBuilder.new("brenda_fire_employee_omar").with_header("Brenda").with_content_list([
			"Hmm... Maybe you're right. I need to put the company's needs first.",
			"If not maybe it will be my head on the chopping block next."
		]).with_next_id("brenda_fire_employee_end"),
		
		DialogueBuilder.new("brenda_fire_employee_end").with_header("Brenda").with_content_list([
			"Okay then it's settled.",
			"Yes. This is the right choice.",
			"Please update the database to fire him.",
			"Ugh this is so frustrating!"
		]).with_final_id("chapter_4_start"),
		
		DialogueBuilder.new("brenda_fire_employee_complete").with_header("Brenda").with_content_list([
			"Thank you for getting that done.",
			"It's nasty business but that's life. The show must go on.",
			"Hey why don't you take the rest of the day off?",
			"It's been one heck of a first day for you haha.",
			"Get some rest and I'll see you bright and early tomorrow morning at 8:00.",
			"Oh. And, once again, welcome to the team."
		]).with_next_id("game_end"),
	]
	super()
