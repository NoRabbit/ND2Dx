package de.nulldesign.nd2dx.resource.shader 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.utils.StringUtils;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2DXMLAllocator extends Shader2DAllocator
	{
		public var xml:XML;
		
		public function Shader2DXMLAllocator(xml:XML) 
		{
			this.xml = xml;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( xml )
			{
				shader.isDynamic = true;
				propertiesString = StringUtils.cleanMasterString(xml.properties);
				vertexProgramString = StringUtils.cleanMasterString(xml.vertex);
				fragmentProgramString = StringUtils.cleanMasterString(xml.fragment);
				
				super.allocateLocalResource(assetGroup, forceAllocation);
			}
		}
	}

}