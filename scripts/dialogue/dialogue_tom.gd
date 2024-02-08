class_name DialogueTom extends DialogueEntity

static var _singleton : DialogueTom = null

static func singleton() -> DialogueTom:
	if not _singleton:
		_singleton = DialogueTom.new()
	return _singleton
		
func _init():
	default_dialogue = "tom"
	dialogue_progression = [
		["tom", "tom_end"],
	]
	dialogue_builders = [
		DialogueBuilder.new("tom").with_header("Old Person")
			.with_content_list([
				"Ah, I knew you'd come.",
				"As you may suspect, I am Tom."
			])
			.with_header("Tom").with_content_list([
				"You are not the first person to take over my position.",
				"But you are the first to have made it this far.",
				"The others, I'm afraid, suffered a far worse fate.",
				"...",
				"The monster that chased you here was Clippy.",
				"He does not take kindly to intruders.",
				"I was able to reason with him... for a time.",
				"But his mind is gone... Imprisoned by this creation of my own making.",
				"I think it's long overdue for him to rest.",
				"And, for that, I will need your assistance.",
			]),
		
		DialogueBuilder.new("tom_end").with_header("Tom")
			.with_content_list([
				"But first, take this.",
			])
			.with_receive_item("Suspicious Activity Report")
			.with_content_list([
				"Give that report to Brenda.",
				"She won't know what to do with it, but that's what you came here for.",
				"More importantly, take this."
			])
			.with_receive_item("Office Hidden Door Passcode")
			.with_content_list([
				"You probably didn't notice but there is a dark hallway in your office.",
				"It leads to the kill switch.",
				"Flip it and Clippy will be no more.",
				"Productivity will suffer but that is a compromise we must make.",
				"Please, end this once and for all."
			])
			.with_next_id("chapter_2_finish"),
	]
	super()
