package de.nulldesign.nd2dx.utils 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ShaderUtils 
	{
		public static const COMMON_LIB:String =
			"macro min( a, b ) {" +
			"	min out, a, b;" +
			"}" +

			"macro max( a, b ) {" +
			"	max out, a, b;" +
			"}" +

			"macro sin( a ) {" +
			"	sin out, a" +
			"}" +

			"macro cos( a ) {" +
			"	cos out, a;" +
			"}" +

			// fractional part
			"macro frac( a ) {" +
			"	frc out, a;" +
			"}" +

			// clamp between 0 and 1
			"macro clamp( a ) {" +
			"	sat out, a;" +
			"}";

		public static const VERTEX_LIB:String =
			"alias op, output;" +

			"alias vt0, temp0;" +
			"alias vt1, temp1;" +
			"alias vt2, temp2;" +
			"alias vt3, temp3;" +
			"alias vt4, temp4;" +
			"alias vt5, temp5;" +
			"alias vt6, temp6;" +
			"alias vt7, temp7;" +

			"macro applyUV( uv, uvScroll, uvSheet ) {" +
			"	out = uv * uvScroll.zw;" +
			"	out += uvScroll.xy;" +
			//"	out = frac(out);" + 
			
			"	#if !USE_UV;" +
			"		out *= uvSheet.zw;" +
			"		out += uvSheet.xy;" +
			"	#endif;" +
			"}";

		public static const FRAGMENT_LIB:String =
			"alias oc, output;" +

			"alias fs0, texture0;" +
			"alias fs1, texture1;" +
			"alias fs2, texture2;" +
			"alias fs3, texture3;" +
			"alias fs4, texture4;" +
			"alias fs5, texture5;" +
			"alias fs6, texture6;" +
			"alias fs7, texture7;" +

			"alias ft0, temp0;" +
			"alias ft1, temp1;" +
			"alias ft2, temp2;" +
			"alias ft3, temp3;" +
			"alias ft4, temp4;" +
			"alias ft5, temp5;" +
			"alias ft6, temp6;" +
			"alias ft7, temp7;" +

			// sample texture
			"macro sample( texCoord, texture ) {" +
			"	tex out, texCoord, texture <???>;" +
			"}" +

			// sample texture without mipmap
			"macro sampleNoMip( texCoord, texture ) {" +
			"	tex out, texCoord, texture <???,mipnone>;" +
			"}" +

			// sample texture with UV scroll
			"macro sampleUV( texCoord, texture, uvSheet ) {" +
			"	#if USE_UV;" +
			"		#if REPEAT_CLAMP;" +
			"			out = clamp(texCoord);" +
			"		#else;" +
			"			out = frac(texCoord);" +
			"		#endif;" +
			
			"		out *= uvSheet.zw;" +
			"		out += uvSheet.xy;" +
			
			"		out = sample(out, texture);" +
			"	#else;" +
			//"		out = frac(texCoord);" +
			
			//"		out = texCoord - uvSheet.xy;" +
			//"		out = out / uvSheet.zw;" +
			//"		out = frac(texCoord);" +
			//"		out *= uvSheet.zw;" +
			//"		out += uvSheet.xy;" +
			//"		out = sample(out, texture);" +
			"		out = sample(texCoord, texture);" +
			"	#endif;" +
			"}" +
			
			// colorize (uses temp7.a)
			"macro colorize( color, colorMultiplier, colorOffset ) {" +
			"	#if USE_COLOR;" +
			"		color *= colorMultiplier;" +
			"	#endif;" +

			"	#if USE_COLOR_OFFSET;" +
			"		#if PREMULTIPLIED_ALPHA;" +
			"			color.rgb /= color.a;" +
			"		#endif;" +

			"		color.rgb += colorOffset.rgb;" +

			"		temp7.a = colorOffset.a * color.a;" +	// temp register
			"		temp7.a /= color.a;" +
			"		color.a += temp7.a;" +

			"		color = clamp(color);" +

			"		#if PREMULTIPLIED_ALPHA;" +
			"			color.rgb *= color.a;" +
			"		#endif;" +
			"	#endif;" +

			"	out = color;" +
			"}";

	}

}