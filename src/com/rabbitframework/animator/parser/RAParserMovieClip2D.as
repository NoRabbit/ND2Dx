package com.rabbitframework.animator.parser 
{
	import com.rabbitframework.animator.nodes.RAObjectNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertiesGroupNode;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import de.nulldesign.nd2d.display.MovieClip2D;
	import de.nulldesign.nd2d.display.Node2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAParserMovieClip2D extends RAParserNode2D
	{
		
		public function RAParserMovieClip2D() 
		{
			super();
			
			targetClass = MovieClip2D;
			
			// create properties that belong to it
			
			var p:RAParserProperty = new RAParserProperty(MovieClip2D, "frame", "currentFrame", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY);
			/*
			var pTransformationPoint:RAParserProperty = new RAParserProperty(Sprite2D, "top left", "", "", p);
			new RAParserProperty(Sprite2D, "x", "a.x", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "a.y", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "top right", "", "", p);
			new RAParserProperty(Sprite2D, "x", "b.x", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "b.y", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "bottom left", "", "", p);
			new RAParserProperty(Sprite2D, "x", "d.x", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "d.y", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "bottom right", "", "", p);
			new RAParserProperty(Sprite2D, "x", "c.x", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "c.y", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, pTransformationPoint);
			*/
			/*
			var pTransformationPoint:RAParserProperty = new RAParserProperty(Sprite2D, "top left", "", "", p);
			new RAParserProperty(Sprite2D, "x", "setTransformPointTopLeftX", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "setTransformPointTopLeftY", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "top right", "", "", p);
			new RAParserProperty(Sprite2D, "x", "setTransformPointTopRightX", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "setTransformPointTopRightY", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "bottom left", "", "", p);
			new RAParserProperty(Sprite2D, "x", "setTransformPointBottomLeftX", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "setTransformPointBottomLeftY", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			
			pTransformationPoint = new RAParserProperty(Sprite2D, "bottom right", "", "", p);
			new RAParserProperty(Sprite2D, "x", "setTransformPointBottomRightX", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			new RAParserProperty(Sprite2D, "y", "setTransformPointBottomRightY", RASystemObjectProperty.PROPERTY_TYPE_FUNCTION, pTransformationPoint);
			*/
			vProperties.push(p);
			
			animatorManager.addParserProperty(p);
		}
	}

}