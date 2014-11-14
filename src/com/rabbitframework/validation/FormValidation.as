package com.rabbitframework.validation 
{
	import com.rabbitframework.ui.checkbox.CheckBox;
	import com.rabbitframework.ui.radiobutton.RadioButton;
	import com.rabbitframework.utils.MathUtils;
	import com.rabbitframework.utils.StringUtils;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FormValidation 
	{
		public static const CHECK_TYPE_IS_NUMERIC:String = "CHECK_TYPE_IS_NUMERIC";
		public static const CHECK_TYPE_IS_EMAIL:String = "CHECK_TYPE_IS_EMAIL";
		public static const CHECK_TYPE_LENGTH_IS_EQUAL:String = "CHECK_TYPE_LENGTH_IS_EQUAL";
		public static const CHECK_TYPE_LENGTH_IS_MORE:String = "CHECK_TYPE_LENGTH_IS_MORE";
		public static const CHECK_TYPE_LENGTH_IS_LESS:String = "CHECK_TYPE_LENGTH_IS_LESS";
		public static const CHECK_TYPE_IS_MORE:String = "CHECK_TYPE_IS_MORE";
		public static const CHECK_TYPE_IS_LESS:String = "CHECK_TYPE_IS_LESS";
		public static const CHECK_TYPE_IS_EQUAL:String = "CHECK_TYPE_IS_EQUAL";
		public static const CHECK_TYPE_IS_DIFFERENT:String = "CHECK_TYPE_IS_DIFFERENT";
		public static const CHECK_TYPE_IS_EMPTY:String = "CHECK_TYPE_IS_EMPTY";
		public static const CHECK_TYPE_IS_NOT_EMPTY:String = "CHECK_TYPE_IS_NOT_EMPTY";
		public static const CHECK_TYPE_IS_NULL:String = "CHECK_TYPE_IS_NULL";
		public static const CHECK_TYPE_IS_NOT_NULL:String = "CHECK_TYPE_IS_NOT_NULL";
		public static const CHECK_TYPE_DATE_DD_MM_YYY:String = "CHECK_TYPE_DATE_DD_MM_YYY";
		
		public var vItems:Vector.<FormValidationItem> = new Vector.<FormValidationItem>();
		
		public function FormValidation() 
		{
			
		}
		
		public function addCheck(object:Object, checkType:String, checkOption:Object = null, highlightFormObject:IHighlightFormObject = null, resultIfTrue:Object = null, resultIfFalse:Object = null):void
		{
			var bAddToArray:Boolean = false;
			var item:FormValidationItem = getItemFormObject(object);
			
			if ( item == null )
			{
				item = new FormValidationItem();
				bAddToArray = true;
			}
			
			item.object = object;
			item.checkTypes.push(checkType);
			item.checkOptions.push(checkOption);
			item.highlightFormObjects.push(highlightFormObject);
			item.resultsIfTrue.push(resultIfTrue);
			item.resultsIfFalse.push(resultIfFalse);
			
			if( bAddToArray ) vItems.push(item);
		}
		
		public function getItemFormObject(object:Object):FormValidationItem
		{
			var i:int = 0;
			var n:int = vItems.length;
			var item:FormValidationItem;
			
			for (i = 0; i < n; i++) 
			{
				item = vItems[i];
				if ( item.object == object ) return item;
			}
			
			return null;
		}
		
		public function checkItems():Array
		{
			var i:int = 0;
			var n:int = vItems.length;
			var item:FormValidationItem;
			var aFalseItems:Array = new Array();
			
			for (i = 0; i < n; i++) 
			{
				item = vItems[i];
				
				if ( !checkItem(item) )
				{
					aFalseItems.push(item.object);
				}
			}
			
			return aFalseItems;
		}
		
		public function checkItem(item:FormValidationItem):Boolean
		{
			var i:int = 0;
			var n:int = item.checkTypes.length;
			
			var object:Object = item.object;
			var data:Object;
			var type:String;
			var option:Object;
			var highlightFormObject:IHighlightFormObject;
			
			var bResult:Boolean = true;
			
			for (i = 0; i < n; i++) 
			{
				type = item.checkTypes[i] as String;
				option = item.checkOptions[i] as Object;
				highlightFormObject = item.highlightFormObjects[i] as IHighlightFormObject;
				
				if ( object is IValidationObject )
				{
					data = (object as IValidationObject).value;
				}
				else if ( object is TextField )
				{
					data = object.text;
				}
				else if ( object is RadioButton )
				{
					data = RadioButton(object).getSelectedRadioButtonInGroup();
				}
				else if ( object is CheckBox )
				{
					data = CheckBox(object).selected;
				}
				else
				{
					data = object;
				}
				
				if ( !checkType(data, type, option) )
				{
					// failure
					bResult = false;
				}
				else
				{
					// success
				}
			}
			
			item.checkResult = bResult;
			
			if ( bResult )
			{
				// ok
				if ( highlightFormObject )
				{
					highlightFormObject.highlightCorrect();
				}
			}
			else
			{
				// not ok
				if ( highlightFormObject )
				{
					highlightFormObject.highlightWrong();
				}
			}
			
			return bResult;
		}
		
		public function checkType(data:Object, type:String, option:Object):Boolean
		{
			switch(type)
			{
				case CHECK_TYPE_IS_NUMERIC:
				{
					return MathUtils.isNumber(data);
					break;
				}
				
				case CHECK_TYPE_IS_EMAIL:
				{
					return StringUtils.isEmail(String(data));
					break;
				}
				
				case CHECK_TYPE_LENGTH_IS_EQUAL:
				{
					if ( String(data).length == Number(option) ) return true;
					return false;
					break;
				}
				
				case CHECK_TYPE_IS_DIFFERENT:
				{
					if ( data != option ) return true;
					return false;
					break;
				}
				
				case CHECK_TYPE_LENGTH_IS_LESS:
				{
					if ( String(data).length < Number(option) ) return true;
					return false;
					break;
				}
				
				case CHECK_TYPE_LENGTH_IS_MORE:
				{
					if ( String(data).length > Number(option) ) return true;
					return false;
					break;
				}
				
				case CHECK_TYPE_IS_EMPTY:
				{
					return StringUtils.isEmpty(String(data));
					break;
				}
				
				case CHECK_TYPE_IS_NOT_EMPTY:
				{
					return !StringUtils.isEmpty(String(data));
					break;
				}
				
				case CHECK_TYPE_IS_NULL:
				{
					if ( data == null ) return true;
					break;
				}
				
				case CHECK_TYPE_IS_NOT_NULL:
				{
					if ( data != null ) return true;
					break;
				}
				
				case CHECK_TYPE_IS_MORE:
				{
					if ( data > option ) return true;
					break;
				}
				
				case CHECK_TYPE_IS_LESS:
				{
					if ( data < option ) return true;
					break;
				}
				
				case CHECK_TYPE_IS_EQUAL:
				{
					if ( data == option ) return true;
					break;
				}
				
				case CHECK_TYPE_DATE_DD_MM_YYY:
				{
					var r:RegExp = /^([123]0|[012][1-9]|31)(\.|-|\/|,)(0[1-9]|1[012])(\.|-|\/|,)(19[0-9]{2}|2[0-9]{3})$/;
					return r.test(String(data));
				}
			}
			
			return false;
		}
	}

}