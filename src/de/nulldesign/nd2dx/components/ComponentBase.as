package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ComponentBase 
	{
		public var stage:Stage = null;
		public var camera:Camera2D = null;
		public var world:World2D = null;
		public var scene:Scene2D = null;
		public var node:Node2D = null;
		
		public var prev:ComponentBase = null;
		public var next:ComponentBase = null;
		
		public var isActive:Boolean = true;
		
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
			// called when this component has successfully been added to its node2d parent
		}
		
		public function onRemovedFromNode():void
		{
			// called when this component has successfully been removed from its node2d parent
		}
		
		public function onComponentAddedToParentNode(component:ComponentBase):void
		{
			// called when a component is added on parent node2d
		}
		
		public function onComponentRemovedFromParentNode(component:ComponentBase):void
		{
			// called when a component is removed from parent node2d
		}
		
		public function step(elapsed:Number):void
		{
			// called on "step" of parent node2d
		}
		
		public function draw(renderSupport:RenderSupportBase):void
		{
			// called on "draw" of parent node2d
		}
		
		public function handleDeviceLoss():void
		{
			// called when device was lost
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
	}

}