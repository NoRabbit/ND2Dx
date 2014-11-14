package de.nulldesign.nd2dx.resource.shader 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2DProperty 
	{
		public var name:String;
		public var label:String;
		public var alias:String;
		public var register:String;
		public var programType:String;
		public var constantCount:int;
		public var constantIndex:int;
		public var value:String;
		
		public function Shader2DProperty(name:String, label:String, alias:String, register:String, programType:String, value:String, constantCount:int) 
		{
			if ( !programType || (programType != "vertex" && programType != "fragment") ) programType = "vertex";
			
			this.name = name;
			this.label = label;
			this.alias = alias;
			this.register = register;
			this.programType = programType;
			this.value = value;
			this.constantCount = constantCount;
		}
		
	}

}