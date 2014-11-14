package com.rabbitframework.animator.parser 
{
	import com.rabbitframework.animator.managers.AnimatorManager;
	import com.rabbitframework.animator.nodes.RANode;
	import com.rabbitframework.animator.nodes.RAObjectPropertiesGroupNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertyNode;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAParserProperty 
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		
		public var targetClass:Class;
		
		public var propertyType:String;
		public var propertyPath:String;
		public var propertyName:String;
		
		public var vChildren:Vector.<RAParserProperty> = new Vector.<RAParserProperty>();
		
		public function RAParserProperty(targetClass:Class, propertyName:String, propertyPath:String = "", propertyType:String = "", parent:RAParserProperty = null) 
		{
			this.targetClass = targetClass;
			this.propertyName = propertyName;
			this.propertyPath = propertyPath;
			this.propertyType = propertyType;
			
			if ( parent ) parent.addChild(this);
		}
		
		public function addChild(child:RAParserProperty):void
		{
			child.targetClass = targetClass;
			if ( vChildren.indexOf(child) >= 0 ) return;
			vChildren.push(child);
		}
		
		public function removeChild(child:RAParserProperty):void
		{
			var index:int = vChildren.indexOf(child);
			vChildren.splice(index, 1);
		}
		
		public function getProperties():Vector.<RAParserProperty>
		{
			var v:Vector.<RAParserProperty> = new Vector.<RAParserProperty>();
			
			if ( vChildren.length <= 0 )
			{
				v.push(this);
				return v;
			}
			
			var i:int = 0;
			var n:int = vChildren.length;
			
			for (; i < n; i++) 
			{
				v = v.concat(vChildren[i].getProperties());
			}
			
			return v;
		}
		
		public function createNodeForTarget(target:Object, parentNode:RANode):RANode
		{
			if ( vChildren.length == 0 )
			{
				// create a simple property node
				var currentObjectProperty:RAObjectPropertyNode = animatorManager.createObjectPropertyNode(this, parentNode);
				currentObjectProperty.parserProperty = this;
				return currentObjectProperty;
			}
			else
			{
				// create a properties group with properties inside of it
				var objectPropertiesGroup:RAObjectPropertiesGroupNode = animatorManager.createObjectPropertiesGroupNode(this, parentNode);
				//var currentObjectProperty:RAObjectPropertyNode;
				
				var i:int = 0;
				var n:int = vChildren.length;
				
				for (; i < n; i++) 
				{
					//currentObjectProperty = vChildren[i].createNodeForTarget(target, objectPropertiesGroup);
					vChildren[i].createNodeForTarget(target, objectPropertiesGroup);
				}
				
				return objectPropertiesGroup;
			}
		}
		/*
		public function propertyNameExist(propertyName:String):Boolean
		{
			if ( vChildren.length == 0 )
			{
				if ( this.propertyName == propertyName ) return;
				return false;
			}
			
			var i:int = 0;
			var n:int = vChildren.length;
			
			for (; i < n; i++) 
			{
				if ( vChildren[i].propertyNameExist(propertyName) ) return true;
			}
			
			return false;
		}
		*/
		public function get length():int 
		{
			return vChildren.length;
		}
	}

}