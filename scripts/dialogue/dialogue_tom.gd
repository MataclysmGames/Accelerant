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
				"You are the first to have made it this far.",
				"The others, I'm afraid, suffered a far worse fate.",
				"...",
				"The monster that chased you here...",
				"He does not take kindly to intruders.",
				"I was able to reason with him... for a time.",
				"But his mind is gone... Imprisoned by this creation of my own making.",
				"I think it's long overdue for him to rest.",
				"And, for that, I will need your assistance.",
			]).with_next_id("tom_end"),
		
		DialogueBuilder.new("tom_end").with_header("Tom")
			.with_content_list([
				"But first, take this.",
			])
			.with_receive_item("Suspicious Activity Report")
			.with_content_list([
				"Give that report to Brenda.",
				"You'll never hear the end of it if she doesn't get that.",
				"More importantly, take this."
			])
			.with_receive_item("Office Hidden Door Passcode")
			.with_content_list([
				"Use that to open the door in your office.",
				"It leads to the kill switch.",
				"It will reset the beast to his default state.",
				"Unfortunately this will also strip the database down to its foundation.",
				"No more fun moving platforms or spikes.",
				"Just boring, easily accessible data.",
				"But that's the sacrifice we must make to ensure he doesn't escape.",
				"Please. End this once and for all."
			])
			.with_next_id("chapter_2_finish"),
	]
	super()
