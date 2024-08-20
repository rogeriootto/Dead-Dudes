extends CanvasLayer

var progress
var sceneName
var sceneLoadStatus
var isLoading = false
var alreadyRunnedTransitions = false

signal onLoadingFinished

func _ready() -> void:
	self.visible = false

func _process(delta):
	if isLoading:
		onLoading()

func onLoadingReady():
	self.visible = true
	alreadyRunnedTransitions = false
	$VideoStreamPlayer.play()
	isLoading = true
	sceneName = GlobalVariables.sceneToLoad
	progress = []
	sceneLoadStatus = 0
	ResourceLoader.load_threaded_request(sceneName)

func onLoading():
	if sceneName == "" or null:
		return
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(sceneName, progress)
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		GlobalVariables.sceneToLoad = ""
		onLoadingFinished.emit()
		isLoading = false
	

func _on_video_stream_player_finished() -> void:
	if isLoading:
		$VideoStreamPlayer.play()
	else:
		if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED and !alreadyRunnedTransitions:
			alreadyRunnedTransitions = true
			TransitionToBlack.transitionFadeIn()
			$VideoStreamPlayer.play()
			await TransitionToBlack.onTransitionToDeathFinished
			TransitionToBlack.transitionFadeOut()
			var newScene = ResourceLoader.load_threaded_get(sceneName)
			get_tree().change_scene_to_packed(newScene)
			self.visible = false
