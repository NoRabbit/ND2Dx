package de.nulldesign.nd2dx.resource.shader 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2DTextureProperty extends Shader2DProperty
	{
		public var uvRectRegister:String;
		public var uvRectAlias:String;
		public var uvRectConstantIndex:int;
		
		public function Shader2DTextureProperty(name:String, label:String, alias:String, register:String, programType:String, value:String, constantCount:int) 
		{
			super(name, label, alias, register, programType, value, constantCount);
		}
		
	}

}