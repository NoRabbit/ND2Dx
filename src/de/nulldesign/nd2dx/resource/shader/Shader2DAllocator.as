package de.nulldesign.nd2dx.resource.shader 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.components.renderers.properties.TextureProperty;
	import de.nulldesign.nd2dx.components.renderers.properties.Vector1Property;
	import de.nulldesign.nd2dx.components.renderers.properties.Vector4Property;
	import de.nulldesign.nd2dx.components.renderers.properties.ColorProperty;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2DAllocator extends ResourceAllocatorBase
	{
		public var shader:Shader2D;
		
		public var propertiesString:String;
		public var vertexProgramString:String;
		public var fragmentProgramString:String;
		public var defines:Array;
		
		public function Shader2DAllocator(propertiesString:String = null, vertexProgramString:String = null, fragmentProgramString:String = null, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			
			this.propertiesString = propertiesString;
			this.vertexProgramString = vertexProgramString;
			this.fragmentProgramString = fragmentProgramString;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( shader.isAllocating ) return;
			if ( shader.isLocallyAllocated && !forceAllocation ) return;
			
			shader.propertiesString = propertiesString;
			shader.vertexProgramString = vertexProgramString;
			shader.fragmentProgramString = fragmentProgramString;
			shader.fragmentAliasesString = "";
			shader.vertexAliasesString = "";
			
			// now precalculate register for each alias
			if ( propertiesString )
			{
				var xml:XML = new XML(propertiesString);
				var properties:XMLList = xml.children();
				var a:Array;
				
				var textureIndex:int = 0;
				var vertexConstantIndexStart:int = 32;
				var vertexConstantIndex:int = 36;
				var fragmentConstantIndex:int = 0;
				
				var aShader2dProperties:Array = [];
				
				for each (var property:XML in properties) 
				{
					switch ( XMLUtils.getCleanString(property.name()) ) 
					{
						case "texture2d":
							{
								aShader2dProperties.push(new Shader2DTextureProperty(XMLUtils.getCleanString(property.name()), XMLUtils.getCleanString(property.@label), XMLUtils.getCleanString(property.@alias), "", XMLUtils.getCleanString(property.@type), XMLUtils.getCleanString(property.text()), TextureProperty.CONSTANT_COUNT));
								break;
							}
							
						case "color":
							{
								aShader2dProperties.push(new Shader2DProperty(XMLUtils.getCleanString(property.name()), XMLUtils.getCleanString(property.@label), XMLUtils.getCleanString(property.@alias), "", XMLUtils.getCleanString(property.@type), XMLUtils.getCleanString(property.text()), ColorProperty.CONSTANT_COUNT));
								break;
							}
							
						case "vector4":
							{
								aShader2dProperties.push(new Shader2DProperty(XMLUtils.getCleanString(property.name()), XMLUtils.getCleanString(property.@label), XMLUtils.getCleanString(property.@alias), "", XMLUtils.getCleanString(property.@type), XMLUtils.getCleanString(property.text()), Vector4Property.CONSTANT_COUNT));
								break;
							}
							
						case "vector1":
							{
								aShader2dProperties.push(new Shader2DProperty(XMLUtils.getCleanString(property.name()), XMLUtils.getCleanString(property.@label), XMLUtils.getCleanString(property.@alias), "", XMLUtils.getCleanString(property.@type), XMLUtils.getCleanString(property.text()), Vector1Property.CONSTANT_COUNT));
								break;
							}
							
						default:
					}
				}
				
				// first sort them by constantCount
				aShader2dProperties.sortOn("constantCount", Array.DESCENDING | Array.NUMERIC);
				
				// now calculate their register and add them to the shader
				var i:int = 0;
				var n:int = aShader2dProperties.length;
				var shader2DProperty:Shader2DProperty;
				var currentConstantIndex:int;
				var currentRegisterComponentIndex:int;
				
				shader.vShader2DProperties = new Vector.<Shader2DProperty>();
				
				for (; i < n; i++) 
				{
					shader2DProperty = aShader2dProperties[i] as Shader2DProperty;
					
					shader.vShader2DProperties.push(shader2DProperty);
					
					if ( shader2DProperty.name == "texture2d" )
					{
						// determine register name for this texture
						shader2DProperty.register = "fs" + textureIndex.toString();
						textureIndex++;
						
						shader.fragmentAliasesString += "alias " + shader2DProperty.register + ", " + shader2DProperty.alias + ";\n";
						
						// now add a uvSheet register for this texture (we know it takes 4 constants = 1 full register)
						var shader2DTextureProperty:Shader2DTextureProperty = shader2DProperty as Shader2DTextureProperty;
						
						shader2DTextureProperty.uvRectConstantIndex = vertexConstantIndex - vertexConstantIndexStart;
						
						currentConstantIndex = vertexConstantIndex / 4;
						shader2DTextureProperty.uvRectRegister = "vc" + currentConstantIndex.toString();
						shader2DTextureProperty.uvRectAlias = shader2DTextureProperty.alias + "UVRect";
						
						vertexConstantIndex += shader2DProperty.constantCount;
						
						shader.vertexAliasesString += "alias " + shader2DTextureProperty.uvRectRegister + ", " + shader2DTextureProperty.uvRectAlias + ";\n";
						
						//trace("shader2DProperty", shader2DProperty.name, shader2DTextureProperty.uvRectAlias, shader2DTextureProperty.uvRectRegister, shader2DTextureProperty.uvRectConstantIndex, shader2DProperty.constantCount);
					}
					else if ( shader2DProperty.programType == "vertex" )
					{
						shader2DProperty.constantIndex = vertexConstantIndex - vertexConstantIndexStart;
						
						if ( shader2DProperty.constantCount == 4 )
						{
							currentConstantIndex = vertexConstantIndex / 4;
							shader2DProperty.register = "vc" + currentConstantIndex.toString();
							vertexConstantIndex += shader2DProperty.constantCount;
						}
						else if ( shader2DProperty.constantCount == 1 )
						{
							currentConstantIndex = Math.floor(vertexConstantIndex / 4);
							currentRegisterComponentIndex = vertexConstantIndex % 4;
							
							shader2DProperty.register = "vc" + currentConstantIndex.toString();
							
							if ( currentRegisterComponentIndex == 0 )
							{
								shader2DProperty.register += ".x";
							}
							else if ( currentRegisterComponentIndex == 1 )
							{
								shader2DProperty.register += ".y";
							}
							else if ( currentRegisterComponentIndex == 2 )
							{
								shader2DProperty.register += ".z";
							}
							else if ( currentRegisterComponentIndex == 3 )
							{
								shader2DProperty.register += ".w";
							}
							
							vertexConstantIndex += shader2DProperty.constantCount;
						}
						
						shader.vertexAliasesString += "alias " + shader2DProperty.register + ", " + shader2DProperty.alias + ";\n";
						
						//trace("shader2DProperty", shader2DProperty.name, shader2DProperty.alias, shader2DProperty.register, shader2DProperty.constantIndex, shader2DProperty.constantCount);
					}
				}
				
				//trace("vertexAliasesString", shader.vertexAliasesString);
				//trace("fragmentAliasesString", shader.fragmentAliasesString);
			}
			
			shader.isLocallyAllocated = false;
			shader.isLocallyAllocated = true;
			
			//if ( shader.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
		}
		
		override public function freeLocalResource():void 
		{
			shader.isLocallyAllocated = false;
			
			propertiesString = null;
			vertexProgramString = null;
			fragmentProgramString = null;
		}
		
		override public function freeRemoteResource():void 
		{
			for each(var shaderProgram2D:ShaderProgram2D in shader.dProgramForId ) 
			{
				if ( shaderProgram2D.program ) shaderProgram2D.program.dispose();
				shaderProgram2D.program = null;
			}
			
			shader.dProgramForId = null;
			
			shader.isRemotelyAllocated = false;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			shader = value as Shader2D;
		}
	}

}