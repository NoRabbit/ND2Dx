package de.nulldesign.nd2dx.display 
{
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import de.nulldesign.nd2dx.support.Texture2DMaterialFastCloudRenderSupport;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FastContainer2D extends Node2D
	{
		public var fastRenderSupport:Texture2DMaterialFastCloudRenderSupport = new Texture2DMaterialFastCloudRenderSupport();
		
		public function FastContainer2D() 
		{
			
		}
		
		override public function drawNode(renderSupport:RenderSupportBase):void 
		{
			// step components first
			/*for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				if( component.isActive ) component.step(renderSupport.elapsed);
			}
			
			step(renderSupport.elapsed);*/
			
			if ( invalidateColors || (parent && parent.invalidateColors) )
			{
				combinedTintRed = _tintRed;
				combinedTintGreen = _tintGreen;
				combinedTintBlue = _tintBlue;
				combinedAlpha = _alpha;
				
				if ( parent )
				{
					combinedTintRed *= parent.combinedTintRed;
					combinedTintGreen *= parent.combinedTintGreen;
					combinedTintBlue *= parent.combinedTintBlue;
					combinedAlpha *= parent.combinedAlpha;
				}
				
				// set this to true so children can update their values as well
				//invalidateColors = true;
			}
			
			/*// perform matrix calculations and draw only if visible
			if ( _visible )
			{
				if ( customRenderSupport && customRenderSupport != renderSupport )
				{
					// change current render support (this is needed so we can call the final "finalize" function in World2D)
					renderSupportManager.setCurrentRenderSupport(customRenderSupport);
					renderSupport = customRenderSupport;
					finalizeRenderSupport = true;
				}
				
				// check first if we have a component that will draw anything
				if ( !hasMesh2DRendererComponent )
				{
					// no, so update matrix if needed
					checkAndUpdateMatrixIfNeeded();
					
					if ( localScrollRect ) renderSupport.setScrollRect(this);
				}
				else
				{
					// render support is in charge of updating matrix if needed
					draw(renderSupport);
				}
				
				for (var child:Node2D = childFirst; child; child = child.next)
				{
					child.drawNode(renderSupport);
				}
				
				if ( finalizeRenderSupport )
				{
					finalizeRenderSupport = false;
					renderSupport.finalize();
				}
				
				renderSupport.endDrawNode(this);
				
				invalidateMatrix = false;
				invalidateScrollRect = false;
				invalidateColors = false;
				matrixUpdated = false;
			}*/
			
			fastRenderSupport.elapsed = renderSupport.elapsed;
			fastRenderSupport.camera = renderSupport.camera;
			fastRenderSupport.viewProjectionMatrix = renderSupport.viewProjectionMatrix;
			fastRenderSupport.context = renderSupport.context;
			//fastRenderSupport.deviceWasLost = renderSupport.deviceWasLost;
			
			fastRenderSupport.prepare();
			
			if ( invalidateMatrix || (parent && parent.invalidateMatrix) )
			{
				if (invalidateMatrix)
				{
					updateLocalMatrix();
				}
				
				updateWorldMatrix();
				
				fastRenderSupport.updateNewParentData(this);
				
				//updateScrollRect();
				
				// set this to true so children can update their values as well
				//invalidateMatrix = true;
				//invalidateScrollRect = true;
				
				// so we don't update matrix more than needed
				//matrixUpdated = true;
			}
			
			//fastRenderSupport.updateNewParentData(this);
			fastRenderSupport.drawChildren(childFirst);
			fastRenderSupport.finalize();
		}
	}

}