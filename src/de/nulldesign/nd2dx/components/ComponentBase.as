package de.nulldesign.nd2dx.components 
{
	import com.rabbitframework.utils.IPoolable;
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import com.rabbitframework.signals.SignalDispatcher;
	import de.nulldesign.nd2dx.utils.IIdentifiable;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ComponentBase extends SignalDispatcher implements IPoolable, IIdentifiable
	{
		WGM::IS_EDITOR
		public var callStepInEditor:Boolean = false;
		
		public var _id:String = "";
		
		[WGM (position = -2000)]
		public var name:String = "";
		
		public var stage:Stage = null;
		public var camera:Camera2D = null;
		public var world:World2D = null;
		public var scene:Scene2D = null;
		public var node:Node2D = null;
		
		public var prev:ComponentBase = null;
		public var next:ComponentBase = null;
		
		public var _isActive:Boolean = true;
		
		public function ComponentBase() 
		{
			
		}
		
		public function setReferences(stage:Stage, camera:Camera2D, world:World2D, scene:Scene2D, node:Node2D):void
		{
			this.camera = camera;
			this.world = world;
			this.scene = scene;
			this.node = node;
			
			if ( this.stage != stage )
			{
				this.stage = stage;
				
				if ( this.stage )
				{
					onNodeAddedToStage();
				}
				else
				{
					onNodeRemovedFromStage();
				}
			}
		}
		
		public function onNodeAddedToStage():void
		{
			// called when node was added to stage
		}
		
		public function onNodeRemovedFromStage():void
		{
			// called when node was removed from stage
		}
		
		public function onAddedToNode():void
		{
			// called when this component has successfully been added to its node2d
		}
		
		public function onRemovedFromNode():void
		{
			// called when this component has successfully been removed from its node2d
		}
		
		public function onComponentAddedToNode(component:ComponentBase):void
		{
			// called when a component is added on node2d
		}
		
		public function onComponentRemovedFromNode(component:ComponentBase):void
		{
			// called when a component is removed from node2d
		}
		
		public function onActivate():void
		{
			
		}
		
		public function onDeactivate():void
		{
			
		}
		
		public function step(elapsed:Number):void
		{
			// called on "step" of parent node2d
		}
		
		public function draw(renderer:RendererBase):void
		{
			// called on "draw" of parent node2d
		}
		
		public function handleDeviceLoss():void
		{
			// called when device was lost
		}
		
		public function hitTest(x:Number, y:Number):Boolean
		{
			return false;
		}
		
		/* INTERFACE com.rabbitframework.utils.IPoolable */
		
		public function initFromPool():void 
		{
			
		}
		
		public function disposeForPool():void 
		{
			if ( node ) node.removeComponent(this);
			
			stage = null;
			camera = null;
			world = null;
			scene = null;
			node = null;
			prev = null;
			next = null;
		}
		
		public function dispose():void 
		{
			if ( node ) node.removeComponent(this);
			
			stage = null;
			camera = null;
			world = null;
			scene = null;
			node = null;
			prev = null;
			next = null;
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			if ( _isActive == value ) return;
			
			_isActive = value;
			
			if ( _isActive )
			{
				onActivate();
			}
			else
			{
				onDeactivate();
			}
		}
		
		/* INTERFACE de.nulldesign.nd2dx.utils.IIdentifiable */
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
	}

}