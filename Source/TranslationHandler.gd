extends Control

onready var langSelect:OptionButton = $"../Panel/MarginContainer/VBoxContainer/SubButtons/TranslateTo"
# Http
onready var translationReq = $TranslationRequest
onready var langReq = $LanguagesRequest

var languages
var headers = []
var tlEntries: Array

func _ready() -> void:
	langReq.request("https://api.cognitive.microsofttranslator.com/languages?api-version=3.0")
	headers = [
		"Ocp-Apim-Subscription-Key: " + ConfigManager.get_setting("api", "key"),
		"Ocp-Apim-Subscription-Region: " + ConfigManager.get_setting("api", "region"),
		"Content-type: application/json"
	]


func _on_Translate_pressed() -> void:
	tlEntries = get_tree().get_nodes_in_group("tl_entry")
	if tlEntries.size() > 0:
		var data = []
		for entry in tlEntries:
			if not (entry as EntryActor).subText.text.empty():
				data.append({"Text": (entry as EntryActor).subText.text})
		
		if data.size() > 0:
			var languageString = langSelect.get_item_text(langSelect.get_selected_id())
			_make_post_request(
				"https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=" + languageString,
				data,
				headers,
				false
			)
		else:
			print("Empty data to translate")


func _make_post_request(url: String, data, headers: Array, use_ssl: bool) -> void:
	var query = JSON.print(data)
	translationReq.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

# TODO: Show the errors in a popup window
func _on_LanguagesRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		languages = parse_json(body.get_string_from_utf8())
		for language in languages.translation:
			langSelect.add_item(language)
	else:
		print("Error:\n", body.get_string_from_utf8())


func _on_TranslationRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var translation = parse_json(body.get_string_from_utf8())
		print(translation)
		for i in range(translation.size()):
			(tlEntries[i] as EntryTranslate).tlText.text = translation[i]["translations"][0]["text"]
			(tlEntries[i] as EntryTranslate).translated = true
	else:
		print("Error:\n", body.get_string_from_utf8())
