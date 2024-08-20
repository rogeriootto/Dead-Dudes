extends CanvasLayer

var progress = []
var sceneName
var sceneLoadStatus = 0

func _ready() -> void:
	sceneName = GlobalVariables.sceneToLoad
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta: float) -> void:
	if sceneName == "" or null:
		return
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(sceneName, progress)
	$VBoxContainer/RichTextLabel.text = "Loading... " + str(progress[0]*100) + "%"
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		GlobalVariables.sceneToLoad = ""
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
		
