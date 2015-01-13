package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.components.renderers.properties.TextureProperty;
	import de.nulldesign.nd2dx.resource.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTextureComponent extends ComponentBase
	{
		private var texturedMeshRendererComponent:TexturedMeshRendererComponent;
		private var textureProperty:TextureProperty;
		
		private var _animatedTexture2D:AnimatedTexture2D;
		
		private var isReadyForRender:Boolean = false;
		
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
		
		public function checkIfReadyForRender():void
		{
			if ( (!texturedMeshRendererComponent && !textureProperty) || !_animatedTexture2D )
			{
				isReadyForRender = false;
			}
			else
			{
				if ( _animatedTexture2D.numFrames <= 0 )
				{
					isReadyForRender = false
				}
				else
				{
					isReadyForRender = true;
				}
			}
		}
		
		[WGM (position = -1000, label = "fps")]
		public function get fps():Number 
		{
			return _fps;
		}
		
		public function set fps(value:Number):void 
		{
			_fps = value;
			elapsedTimeForFrame = 1 / _fps;
		}
		
		[WGM (position = -900, label = "source", acceptedTypes = "de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent,de.nulldesign.nd2dx.components.renderers.properties.TextureProperty")]
		public function get source():Object 
		{
			return (texturedMeshRendererComponent ? texturedMeshRendererComponent : textureProperty);
		}
		
		public function set source(value:Object):void 
		{
			if ( value == null )
			{
				texturedMeshRendererComponent = null;
				textureProperty = null;
			}
			
			if ( value is TexturedMeshRendererComponent )
			{
				texturedMeshRendererComponent = value as TexturedMeshRendererComponent;
			}
			else if ( value is TextureProperty )
			{
				textureProperty = value as TextureProperty;
			}
			
			checkIfReadyForRender();
		}
		
		[WGM (position = -800, label = "animated texture", acceptedTypes = "de.nulldesign.nd2dx.resource.texture.AnimatedTexture2D")]
		public function get animatedTexture2D():AnimatedTexture2D 
		{
			return _animatedTexture2D;
		}
		
		public function set animatedTexture2D(value:AnimatedTexture2D):void 
		{
			_animatedTexture2D = value;
			//setFrameIndex(0);
			checkIfReadyForRender();
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( !isReadyForRender ) return;
			
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
			
			if ( currentFrameIndex < 0 ) currentFrameIndex = _animatedTexture2D.numFrames + currentFrameIndex;
			
			currentTexture = _animatedTexture2D.frames[currentFrameIndex];
			
			if ( texturedMeshRendererComponent )
			{
				texturedMeshRendererComponent.texture = currentTexture;
			}
			else if ( textureProperty )
			{
				textureProperty.texture = currentTexture;
			}
			
		}
	}

}