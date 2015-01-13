package de.nulldesign.nd2dx.resource.shader 
{
	import com.adobe.utils.AGALMacroAssembler;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.ShaderUtils;
	import de.nulldesign.nd2dx.utils.TextureOption;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2D extends ResourceBase
	{
		public var dProgramForId:Dictionary;
		
		public var propertiesString:String;
		public var vertexAliasesString:String;
		public var fragmentAliasesString:String;
		public var vertexProgramString:String;
		public var fragmentProgramString:String;
		
		public var vShader2DProperties:Vector.<Shader2DProperty>;
		
		public var isDynamic:Boolean = false;
		
		public function Shader2D(allocator:ResourceAllocatorBase, isDynamic:Boolean = false) 
		{
			super(allocator);
			this.isDynamic = isDynamic;
		}
		
		public function getShaderProgram(context:Context3D, texture:Texture2D = null, defines:Array = null):ShaderProgram2D
		{
			//trace("Shader2D", "getShaderProgram", resourceId, propertiesString, texture);
			
			if ( !isLocallyAllocated )
			{
				allocator.allocateLocalResource();
				return null;
			}
			
			if ( !defines ) defines = [];
			
			defines.push("USE_UV", false);
			defines.push("PREMULTIPLIED_ALPHA", (texture ? texture.hasPremultipliedAlpha : false));
			defines.push("REPEAT_CLAMP", (texture ? texture.textureOptions & TextureOption.REPEAT_CLAMP : false));
			
			var aTextureOptions:Array = ["2d"];
			
			//trace("Shader2D", "textureOptions", texture.textureOptions, texture.textureOptions & TextureOption.MIPMAP_DISABLE, texture.textureOptions & TextureOption.MIPMAP_NEAREST, texture.textureOptions & TextureOption.MIPMAP_LINEAR);
			
			if ( texture )
			{
				var optionMissing:Boolean = false;
				var textureOptions:uint = texture.textureOptions;
				
				if ( textureOptions & TextureOption.MIPMAP_DISABLE ) 
				{
					aTextureOptions.push("mipnone");
				}
				else if ( textureOptions & TextureOption.MIPMAP_NEAREST )
				{
					aTextureOptions.push("mipnearest");
				}
				else if ( textureOptions & TextureOption.MIPMAP_LINEAR )
				{
					aTextureOptions.push("miplinear");
				}
				else
				{
					optionMissing = true;
				}
				
				if ( textureOptions & TextureOption.FILTERING_NEAREST )
				{
					aTextureOptions.push("nearest");
				}
				else if ( textureOptions & TextureOption.FILTERING_LINEAR )
				{
					aTextureOptions.push("linear");
				}
				else
				{
					optionMissing = true;
				}
				
				if ( textureOptions & TextureOption.REPEAT_CLAMP )
				{
					aTextureOptions.push("clamp");
				}
				else if ( textureOptions & TextureOption.REPEAT_NORMAL )
				{
					aTextureOptions.push("repeat");
				}
				else if ( textureOptions & TextureOption.REPEAT_WRAP )
				{
					aTextureOptions.push("wrap");
				}
				else
				{
					optionMissing = true;
				}
				
				if ( optionMissing && textureOptions > 0 )
				{
					throw new Error("You need to specify all three texture option components. (MIPMAP_NEAREST | FILTERING_NEAREST | REPEAT_NORMAL)");
				}
				
				if ( texture.textureFormat == Context3DTextureFormat.COMPRESSED )
				{
					aTextureOptions.push("dxt1");
				}
				else if ( texture.textureFormat == "compressedAlpha" )//Context3DTextureFormat.COMPRESSED_ALPHA )
				{
					aTextureOptions.push("dxt5");
				}
			}
			
			//trace("aTextureOptions", aTextureOptions);
			
			// check if we already have a program with those attributes in memory
			if ( !dProgramForId ) dProgramForId = new Dictionary();
			
			var id:String = defines.join(",") + "|" + aTextureOptions.join(",");
			var shaderProgram:ShaderProgram2D = dProgramForId[id] as ShaderProgram2D;
			
			// yes ?
			if ( shaderProgram ) return shaderProgram;
			
			// no continue
			var definesShaderString:String = "";
			
			for (var i:uint = 0; i < defines.length; i += 2) 
			{
				definesShaderString += "#define " + defines[i] + "=" + int(defines[i + 1]) + ";";
			}
			
			var finalVertexProgramString:String = ShaderUtils.COMMON_LIB + ShaderUtils.VERTEX_LIB + vertexAliasesString + definesShaderString + vertexProgramString;
			var finalFragmentProgramString:String = (ShaderUtils.COMMON_LIB + ShaderUtils.FRAGMENT_LIB + fragmentAliasesString + definesShaderString + fragmentProgramString).replace(/\?\?\?/g, aTextureOptions.join(","));
			
			var vertexShaderAssembler:AGALMacroAssembler = new AGALMacroAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, finalVertexProgramString);
			
			var fragmentShaderAssembler:AGALMacroAssembler = new AGALMacroAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, finalFragmentProgramString);
			
			//trace("finalVertexProgramString:", finalVertexProgramString);
			//trace("finalFragmentProgramString:", finalFragmentProgramString);
			
			trace("vertex:", vertexShaderAssembler.profileTrace, vertexShaderAssembler.asmCode);
			trace("fragment:", fragmentShaderAssembler.profileTrace, fragmentShaderAssembler.asmCode);
			
			shaderProgram = new ShaderProgram2D();
			shaderProgram.shader = this;
			shaderProgram.program = context.createProgram();
			shaderProgram.program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			dProgramForId[id] = shaderProgram;
			
			return shaderProgram;
		}
		
		//override public function freeResource():void 
		//{
			//for each(var shaderProgram2D:ShaderProgram2D in dProgramForId ) 
			//{
				//if ( shaderProgram2D.program ) shaderProgram2D.program.dispose();
				//shaderProgram2D.program = null;
			//}
			//
			//propertiesString = null;
			//fragmentAliasesString = null;
			//fragmentProgramString = null;
			//vertexAliasesString = null;
			//vertexProgramString = null;
			//
			//dProgramForId = null;
		//}
		
		override public function handleDeviceLoss():void 
		{
			dProgramForId = null;
		}
		
		override public function dispose():void 
		{
			dProgramForId = null;
		}
	}

}