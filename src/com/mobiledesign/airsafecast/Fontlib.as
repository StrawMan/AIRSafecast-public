//////////////////////////////
//Embedded font library class.
//////////////////////////////
package com.mobiledesign.airsafecast {
	import flash.text.Font;
	
	//////////////////////////////
	public class Fontlib extends Font {
		//////////////////////////////
		//Font embeds.
		//////////////////////////////
		//Droid family.
		[Embed(source='/../fonts/DroidSans.ttf',embedAsCFF='false',mimeType="application/x-font-truetype",advancedAntiAliasing='true',fontName='DroidSans',unicodeRange='U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E')]
		public static var DroidSans:Class;
		[Embed(source='/../fonts/DroidSans-Bold.ttf',embedAsCFF='false',mimeType="application/x-font-truetype",advancedAntiAliasing='true',fontName='DroidSansBold',unicodeRange='U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E')]
		public static var DroidSansBold:Class;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Fontlib() {
			super();
			//Fontin family. Serif.
			Font.registerFont(DroidSans);
			Font.registerFont(DroidSansBold);
		}
		//////////////////////////////
	}
}

