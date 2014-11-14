package com.rabbitframework.animator.parser 
{
	import com.rabbitframework.animator.nodes.RAObjectNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertiesGroupNode;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import de.nulldesign.nd2d.display.Node2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAParserNode2D extends RAParser
	{
		
		public function RAParserNode2D() 
		{
			targetClass = Node2D;
			
			// create properties that belong to it
			
			// group: transformations
			var p:RAParserProperty = new RAParserProperty(Node2D, "Transformations");
			new RAParserProperty(Node2D, "x", "x", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "y", "y", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "scaleX", "scaleX", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "scaleY", "scaleY", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "rotationX", "rotationX", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "rotationY", "rotationY", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			new RAParserProperty(Node2D, "rotationZ", "rotationZ", RASystemObjectProperty.PROPERTY_TYPE_PROPERTY, p);
			
			vProperties.push(p);
			
			animatorManager.addParserProperty(p);
		}
		
		override public function createObjectNodeForTarget(target:Object):RAObjectNode 
		{
			var objectNode:RAObjectNode = animatorManager.createObjectNode(target);
			
			// going through properties of this object
			var i:int = 0;
			var n:int = vProperties.length;
			
			for (; i < n; i++) 
			{
				vProperties[i].createNodeForTarget(target, objectNode);
			}
			
			return objectNode;
		}
	}

}