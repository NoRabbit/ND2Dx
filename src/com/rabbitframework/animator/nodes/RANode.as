package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.managers.AnimationSystemManager;
	import com.rabbitframework.animator.managers.AnimatorManager;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.display.RabbitSprite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RANode extends RabbitSprite
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		public var animationSystemManager:AnimationSystemManager = AnimationSystemManager.getInstance();
		
		protected var _parentNode:RANode = null;
		public var vChildrenNode:Vector.<RANode> = new Vector.<RANode>;
		public var childrenContainer:Sprite;
		
		public var nodeX:Number = 0.0;
		//public var nodeWidth:Number = 100.0;
		public var nodeHeight:Number = 16.0;
		public var nodeTotalHeight:Number = 16.0;
		
		protected var currentElementX:Number = 0.0;
		protected var currentChildNodeY:Number = 0.0;
		
		protected var _expanded:Boolean = false;
		protected var _mainNode:Boolean = false;
		
		public var refNode:RANode = null;
		
		public function RANode() 
		{
			childrenContainer = this;
		}
		
		override public function preInit():void 
		{
			
		}
		/*
		public function setSize(width:Number = NaN, height:Number = NaN):void
		{
			if ( !isNaN(width) )
			{
				if ( width < RAStyle.NODE_MIN_WIDTH ) width = RAStyle.NODE_MIN_WIDTH;
				nodeWidth = width;
			}
			
			if ( !isNaN(height) )
			{
				if ( height < RAStyle.NODE_MIN_HEIGHT ) height = RAStyle.NODE_MIN_HEIGHT;
				nodeHeight = height;
			}
			
			draw();
		}
		*/
		public function draw():void
		{
			currentElementX = nodeX;
			
			// total node height
			nodeTotalHeight = nodeHeight;
			
			// if node is expanded, draw children
			if ( _expanded )
			{
				// draw children and add children node height
				var i:int = 0;
				var n:int = vChildrenNode.length;
				var childNode:RANode;
				currentChildNodeY = nodeHeight;
				
				for (; i < n; i++)
				{
					childNode = vChildrenNode[i];
					childNode.y = currentChildNodeY;
					childNode.nodeX = currentElementX + RAStyle.NODE_CHILD_OFFSET_X;
					childNode.draw();
					currentChildNodeY += childNode.nodeTotalHeight;
					nodeTotalHeight += childNode.nodeTotalHeight;
				}
			}
		}
		
		/*
		public function callParentDraw():void
		{
			var currentNode:RANode = parentNode;
			
			if ( currentNode )
			{
				while ( currentNode.parentNode )
				{
					currentNode = currentNode.parentNode;
				}
			}
			else
			{
				currentNode = this;
			}
			
			if ( currentNode ) currentNode.draw();
		}
		*/
		
		public function addChildNode(child:RANode):RANode
		{
			if ( child.parentNode == this ) return child;
			if ( child.parent ) child.parent.removeChild(child);
			
			child.parentNode = this;
			vChildrenNode.push(child);
			
			if ( _expanded )
			{
				childrenContainer.addChild(child);
				
				if ( animatorManager.rabbitAnimator ) animatorManager.rabbitAnimator.draw();
			}
			
			if ( _mainNode && refNode )
			{
				refNode.addChildNode(child.refNode);
			}
			
			return child;
		}
		
		public function removeChildNode(child:RANode):RANode
		{
			var currentIndex:int = vChildrenNode.indexOf(child);
			if ( currentIndex >= 0 ) vChildrenNode.splice(currentIndex, 1);
			if ( child.parent == childrenContainer ) childrenContainer.removeChild(child);
			
			if ( _mainNode && refNode )
			{
				refNode.removeChildNode(child.refNode);
			}
			
			return child;
		}
		
		public function setInChildrenContainerChildNodeAt(childNode:RANode, index:int):void
		{
			childrenContainer.setChildIndex(childNode, index);
			if ( _mainNode && refNode ) refNode.setInChildrenContainerChildNodeAt(childNode.refNode, index);
		}
		
		public function addChildrenToChildrenContainer():void
		{
			var i:int = 0;
			var n:int = vChildrenNode.length;
			var childNode:RANode;
			
			for (; i < n; i++) 
			{
				childNode = vChildrenNode[i];
				if ( childNode.parent != childrenContainer ) childrenContainer.addChild(childNode);
			}
		}
		
		public function removeChildrenFromChildrenContainer():void
		{
			var i:int = 0;
			var n:int = vChildrenNode.length;
			var childNode:RANode;
			
			for (; i < n; i++) 
			{
				childNode = vChildrenNode[i];
				if ( childNode.parent ) childNode.parent.removeChild(childNode);
			}
		}
		
		// remove all children
		public function clear():void
		{
			var i:int = 0;
			var n:int = vChildrenNode.length;
			var childNode:RANode;
			
			for (; i < n; i++) 
			{
				childNode = vChildrenNode[i];
				childNode.dispose();
			}
			
			vChildrenNode.splice(0, vChildrenNode.length);
		}
		
		/*
		public function getChildNodeIndex(child:RANode):int
		{
			return vChildrenNode.indexOf(child);
		}
		
		public function setChildNodeIndex(child:RANode, index:int):void
		{
			var currentIndex:int = vChildrenNode.indexOf(child);
			
			if ( currentIndex >= 0 )
			{
				vChildrenNode.splice(currentIndex, 1);
			}
			
			vChildrenNode.splice(index, 0, child);
			
			callParentDraw();
		}
		*/
		
		override public function dispose():void 
		{
			super.dispose();
			
			eManager.removeAllFromGroup(eventGroup);
			animatorManager = null;
			animationSystemManager = null;
			_parentNode = null;
			refNode = null;
			
			var i:int = 0;
			var n:int = vChildrenNode.length;
			
			for (; i < n; i++) 
			{
				vChildrenNode[i].dispose();
			}
			
			vChildrenNode.splice(0, vChildrenNode.length);
			childrenContainer.removeChildren();
			
			if ( parent ) parent.removeChild(this);
		}
		
		public function get expanded():Boolean 
		{
			return _expanded;
		}
		
		public function set expanded(value:Boolean):void 
		{
			if ( _expanded == value ) return;
			_expanded = value;
			
			if (_expanded)
			{
				addChildrenToChildrenContainer();
			}
			else
			{
				removeChildrenFromChildrenContainer();
			}
			
			if ( _mainNode && refNode ) refNode.expanded = _expanded;
			
			if( animatorManager.rabbitAnimator ) animatorManager.rabbitAnimator.draw();
		}
		
		public function get parentNode():RANode 
		{
			return _parentNode;
		}
		
		public function set parentNode(value:RANode):void 
		{
			_parentNode = value;
		}
		
		public function get mainNode():Boolean 
		{
			return _mainNode;
		}
		
		public function set mainNode(value:Boolean):void 
		{
			_mainNode = value;
		}
	}

}