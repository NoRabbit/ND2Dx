package showdown.scenes 
{
	import de.nulldesign.nd2dx.components.ComponentBase;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import flash.events.Event;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SceneBase extends Scene2D
	{
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		public function SceneBase() 
		{
			addSignalListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			addSignalListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
		}
		
		protected function onRemovedFromStageHandler():void 
		{
			
		}
		
		protected function onAddedToStageHandler():void 
		{
			
		}
	}

}