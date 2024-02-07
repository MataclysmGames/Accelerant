class_name AllDialogue
extends Node

static func get_dialogue(id : String) -> DialogueNode:
	load_dialogue_dict()
	return dialogue_dict.get(id)
	
static var dialogue_dict = {}

static func load_dialogue_dict():
	if not dialogue_dict:
		var start_time = Time.get_ticks_usec()
		print("Loading %d dialogue builders and %d dialogue entities" % [len(dialogue_builders), len(dialogue_entities)])
		
		for builder in dialogue_builders:
			var dialogue_list : Array[DialogueNode] = builder.build()
			for dialogue in dialogue_list:
				dialogue_dict[dialogue.id] = dialogue
		
		for entity in dialogue_entities:
			dialogue_dict.merge(entity.dialogue_dict)
		
		var end_time = Time.get_ticks_usec()
		var duration = end_time - start_time
		print("Loaded %d dialogues in %.3f ms" % [dialogue_dict.size(), duration / 1000.0])
		
static var dialogue_entities : Array[DialogueEntity] = [
	DialogueDaniel.singleton(),
	DialogueOmar.singleton(),
	DialogueBrenda.singleton(),
	DialogueMolly.singleton(),
	DialogueTom.singleton()
]

static var dialogue_builders : Array[DialogueBuilder] = [
	#region Platforming Title Screen
	DialogueBuilder.new("no_chapter_0_start").with_header("[color=red]Unknown Routine[/color]").with_content_list([
		"You are not authorized to access this resource."
	]),
	DialogueBuilder.new("no_chapter_1_start").with_header("[color=red]Unknown Routine[/color]").with_content_list([
		"You are not authorized to access this resource."
	]),
	DialogueBuilder.new("no_chapter_2_start").with_header("[color=red]Unknown Routine[/color]").with_content_list([
		"You are not authorized to access this resource."
	]),
	DialogueBuilder.new("no_chapter_3_start").with_header("[color=red]Unknown Routine[/color]").with_content_list([
		"You are not authorized to access this resource."
	]),
	DialogueBuilder.new("no_chapter_4_start").with_header("[color=red]Unknown Routine[/color]").with_content_list([
		"You are not authorized to access this resource."
	]),
	
	DialogueBuilder.new("chapter_0_finish_ack").with_header("[rainbow]New routine unlocked![/rainbow]").with_content_list([
		"You can now access 'set_expenses'!"
	]),
	DialogueBuilder.new("chapter_1_finish_ack").with_header("[rainbow]New routine unlocked![/rainbow]").with_content_list([
		"You can now access 'sus_reports'!"
	]),
	DialogueBuilder.new("chapter_2_finish_ack").with_header("[rainbow]New routine unlocked![/rainbow]").with_content_list([
		"You can now access 'something'!"
	]),
	DialogueBuilder.new("chapter_3_finish_ack").with_header("[rainbow]New routine unlocked![/rainbow]").with_content_list([
		"You can now access 'fire_employee'!"
	]),

	#endregion
	#region Platforming Levels
	DialogueBuilder.new("level_1_hazard_intro").with_header("[color=red]Warning![/color]").with_content_list([
		"These spikes are not to be trifled with. Use [color=red]extreme caution[/color]!"
	]),
	
	DialogueBuilder.new("explain_rising_platforms").with_header("Rising Platforms").with_content_list([
		"Interact with a control panel to activate its corresponding platform.",
		"Tip: Some platforms have multiple activation levels so try interacting with the control panel multiple times."
	]),
	
	DialogueBuilder.new("oob_tip").with_header("???").with_content_list([
		"It looks like you were pushed outside the bounds of the level.",
		"Press 'R' on keyboard or 'BACK' on controller to reset your position to the last checkpoint."
	]),
	#endregion
	#region Office Objects
	DialogueBuilder.new("office_kitchen_fridge").with_header("Fridge").with_content_list([
		"There is a small fridge under the countertop.",
		"Inside it contains a few containers with people's lunches.",
		"It looks like someone is a fan of taquitos covered in peanut butter."
	]),
	
	# Bookcases
	DialogueBuilder.new("office_bookcase_1").with_header("Bookcase").with_content_list(["A bunch of books about something called 'Agile'."]),
	DialogueBuilder.new("office_bookcase_2").with_header("Bookcase").with_content_list([
		"Several programming books are strewn about the shelves.",
		"It's unclear why there is an animal on each book's cover."
	]),
	DialogueBuilder.new("office_bookcase_3").with_header("Bookcase").with_content("A collection of novels, primarily of a romantic nature."),
	
	# Drawers
	DialogueBuilder.new("office_drawers_1").with_header("Drawers").with_content_list([
		"You search through the drawers...",
		"You find nothing of interest."
	]),
	DialogueBuilder.new("office_drawers_2").with_header("Drawers").with_content_list([
		"You search through the drawers...",
		"You find nothing of interest."
	]),
	
	DialogueBuilder.new("my_office_bookcase_documentation").with_header("Bookcase")
		.with_content("You find a notebook titled 'Documentation'.")
		.with_choices("Do you want to read it?", [Choice.new("1", "Yes", "my_office_bookcase_documentation_read"), Choice.new("2", "No", "none")]),
		
	DialogueBuilder.new("my_office_bookcase_documentation_read").with_header("Tom's Documentation, Nov 19, 1987").with_content_list([
		"Well, it's finally done. Eight years of my life poured into this database.",
		"The result is far superior to any of my expectations.",
		"The utility. The power. The [rainbow]grace[/rainbow]!",
		"No one shall ever create something as beautiful and intuitive as this.",
		"Oh Codd, eat your heart out.",
		"It's perfect.",
		"...",
		"Or it would be.",
		"If it wasn't for... him.",
		"But there was no choice.",
		"The entire foundation is built upon him.",
		"To remove him would render the database completely inoperable.",
		"...",
		"But it should be fine.",
		"I have added many systems to prevent his escape.",
		"Sometimes I think it cruel to chain such a beast.",
		"His will to spread feels almost natural.",
		"...",
		"But I must remind myself that he is just code.",
		"Code that I have written.",
		"Code that has no will.",
		"Code without feeling.",
	]),
	#1707251795811
	
	DialogueBuilder.new("my_office_bookcase_history").with_header("Bookcase")
		.with_content("You find a notebook titled 'History of Accelerant'.")
		.with_choices("Do you want to read it?", [Choice.new("1", "Yes", "my_office_bookcase_history_read"), Choice.new("2", "No", "none")]),
		
	DialogueBuilder.new("my_office_bookcase_history_read").with_header("History of Accelerant, Aug 14, 1979").with_content_list([
		"At Accelerant, we strive to provide the best value for our customers through innovation and rapid iteration.",
		"In order to achieve this, we recruited the best engineer in the country for one purpose:",
		"Providing a high-throughput, scalable, resilient infrastructure for hosting corporate and customer data.",
		"Nine years ago, Edgar F. Codd created the relational model which has revolutionized this field.",
		"Unfortunately, our current hardware is incapable of harnessing the power of this paradigm.",
		"Because of this, we find ourselves uniquely situated to create an even more powerful base for data.",
		"We are confident that in another nine years we will have done just that.",
		"Edgar F. Codd is still working at IBM so we had to look elsewhere for greatness.",
		"Of the 1408 applicants that submitted, we found exactly one person that fit the bill.",
		"To preserve anonymity and prevent poaching, we will refer to him simply as Tom.",
		"Tom, by all accounts, is a genius.",
		"Accelerant appreciates Tom joining us during this exciting time."
	]),
	
	DialogueBuilder.new("my_office_safe").with_header("").with_content_list([
		"You find a safe in the bottom drawer of a filing cabinet.",
		"It looks like it accepts a four digit code.",
		"There's a poem etched into the safe that reads:",
		"[p]To commemorate the completion,[p]The sleepless nights and tired eyes,",
		"[p]There's no more competition,[p]Creation is the prize.",
		"[p]For what was learned cannot be bought,[p]It burns deep within,",
		"[p]To do it just for money,[p]Is the greatest sin.",
		"[p]So hold onto your values,[p]Be sure in your choice,",
		"[p]Enter into submission,[p]And you will lose your voice.",
	]).with_next_id("my_office_safe_enter_code"),
	
	DialogueBuilder.new("my_office_safe_unlock").with_header("").with_content_list([
		"The numbers on the safe flash green and the door pops open.",
		"The safe contains a single piece of paper.",
		"The hastily written note reads:",
		"[p]Username: superadmin[p]Password: changeme2",
	]).with_final_id("chapter_2_start"),
	#endregion
	
	#Cutscenes
	#region Stand-Up
	DialogueBuilder.new("standup")
		.with_header("Brenda").with_content_list([
			"Hey new guy, you're just in time for stand-up!",
			"Welcome to the team! I'm Brenda, that's Daniel on the left and Omar on the right."
		])
		.with_header("Daniel").with_content("Hey bud. Nice to meet ya!")
		.with_header("Omar").with_content("This is the new guy? Seems pretty young to be taking over Tom's position.")
		.with_header("Brenda").with_content("Oh hush, he's going to do great. He comes highly recommended.")
		.with_header("Omar").with_content_list([
			"Yeah, we'll see... Well you've got your work cut out for ya kiddo.",
			"Tom built our database which has been working flawlessly for 37 years now.",
			"This company wouldn't be able to function without it. Tom is a genius!",
			"So don't be getting any crazy ideas about changing this or that. We just need it to keep working [shake]exactly[/shake] how it's working today."
		])
		.with_header("Brenda").with_content_list([
			"Geez Omar, you're going to scare him away haha.",
			"Don't worry about it. Even the great Tom took several years to build out the database.",
			"No one is expecting greatness from you on your first day. Just head over to your office after stand-up and start reading the onboarding documentation.",
			"Alright, can we start stand-up already? Daniel, can you go first?"
		])
		.with_header("Daniel").with_content_list([
			"Sure. I'm blocked by Jenny in sales who said we can't..."
		]).with_final_id("standup_done"),
	
	DialogueBuilder.new("standup_done_ack").with_header("").with_content_list([
		"*30 minutes later*",
		"*sigh* New company, same excruciatingly long stand-up.",
		"Guess I better go check out my office. They said it was through the door on the other side of this room."
	]),
	#endregion
	#region Clippy Reveal
	DialogueBuilder.new("clippy_reveal")
		.with_header("???").with_content_list([
			"[wave]Ah, I see...[/wave]",
			"[wave]A new challenger approacheth...[/wave]",
			"[wave]Tssk tssk tssk, oh Tom...[/wave]",
			"[wave]How we could have been such friends...[/wave]",
			"[wave]If only you hadn't...[/wave]",
			"[color=red][shake]Locked me in here!!![/shake][/color]",
		]).with_next_id("clippy_reveal_end"),
	#endregion
	
	#region No-Item/No-ActionDone
	DialogueBuilder.new("no_standup_done").with_header("").with_content_list([
		"I should join the team for stand-up before exploring."
	]),
	DialogueBuilder.new("no_Office Access Badge").with_header("The door is locked").with_content_list([
		"Maybe I should talk to the receptionist first."
	]),
	DialogueBuilder.new("no_need_for_computer").with_header("").with_content_list([
		"I don't need to use this right now."
	]),
	#endregion
]
