package test.cam{
	import flash.display.*;
	[SWF(backgroundColor="#000000", frameRate="12", width="400", height="300")]
	public class Main extends Sprite {
		[Embed(source='../../../asset/Qufu.jpg')]
		private var SourceImage:Class;
		
		public function Main():void {
			addChild(new Bitmap(CartoonFilter.Cartoonize((new SourceImage()).bitmapData)));
		}//end of function  
		
	}//end of class
}//end of package