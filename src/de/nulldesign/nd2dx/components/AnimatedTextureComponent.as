package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTextureComponent extends ComponentBase
	{
		private var _material:Texture2DMaterial;
		private var _animatedTexture2D:AnimatedTexture2D;
		
		private var _fps:Number = 25;
		
		public var elapsedTimeForFrame:Number = 0.0;
		public var elapsedTimeLeft:Number = 0.0;
		
		public var frameIndex:int = 0;
		public var currentFrameIndex:int = -1;
		public var framesToAdd:int = 0;
		
		public var currentTexture:Texture2D;
		
		public var isLoop:Boolean = true;
		public var isFinished:Boolean = false;
		
		public function AnimatedTextureComponent() 
		{
			fps = 24;
		}
		
		public function get fps():Number 
		{
			return _fps;
		}
		
		public function set fps(value:Number):void 
		{
			_fps = value;
			elapsedTimeForFrame = 1 / _fps;
		}
		
		public function get material():Texture2DMaterial 
		{
			return _material;
		}
		
		public function set material(value:Texture2DMaterial):void 
		{
			_material = value;
			if ( _material && _animatedTexture2D ) setFrameIndex(0);
		}
		
		public function get animatedTexture2D():AnimatedTexture2D 
		{
			return _animatedTexture2D;
		}
		
		public function set animatedTexture2D(value:AnimatedTexture2D):void 
		{
			_animatedTexture2D = value;
			if ( _material && _animatedTexture2D ) setFrameIndex(0);
		}
		
		override public function onAddedToNode():void 
		{
			checkForMaterialInComponent(node.getComponent(Mesh2DRendererComponent));
		}
		
		override public function onComponentAddedToParentNode(component:ComponentBase):void 
		{
			checkForMaterialInComponent(component);
		}
		
		public function checkForMaterialInComponent(component:ComponentBase):void
		{
			if ( !component ) return;
			if ( _material ) return;
			
			var meshRendererComponent:Mesh2DRendererComponent = component as Mesh2DRendererComponent;
			if ( !meshRendererComponent ) return;
			
			material = meshRendererComponent.material as Texture2DMaterial;
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( !_material ) return;
			if ( !_animatedTexture2D ) return;
			if ( isFinished ) return;
			
			elapsedTimeLeft += elapsed;
			
			if ( elapsedTimeLeft < elapsedTimeForFrame ) return;
			
			framesToAdd = Math.floor(elapsedTimeLeft / elapsedTimeForFrame);
			elapsedTimeLeft = elapsedTimeLeft % elapsedTimeForFrame;
			
			frameIndex += framesToAdd;
			
			if ( frameIndex >= _animatedTexture2D.numFrames && !isLoop )
			{
				isFinished = true;
				setFrameIndex(_animatedTexture2D.numFrames - 1);
				return;
			}
			
			setFrameIndex(frameIndex);
		}
		
		public function setFrameIndex(index:int):void
		{
			if ( currentFrameIndex == index ) return;
			frameIndex = currentFrameIndex = index % _animatedTexture2D.numFrames;
			
			currentTexture = _animatedTexture2D.frames[currentFrameIndex];
			
			_material.uvRect = currentTexture.uvRect;
			_material.frameOffsetX = currentTexture.frameOffsetX;
			_material.frameOffsetY = currentTexture.frameOffsetY;
			_material.width = currentTexture.textureWidth;
			_material.height = currentTexture.textureHeight;
			
			_material.invalidateClipSpace = true;
		}
	}

}