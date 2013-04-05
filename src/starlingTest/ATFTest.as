package starlingTest
{
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;


	import flash.events.Event;
	import starling.events.Event;	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	import texture.ATFTextureTest;
	
	public class ATFTest extends Sprite
	{
		public static const CompressedData:Class;
		private var mStarling:Starling;
		
		public function ATFTest()
		{
			super();
			var stageWidth:int  = 320;
			var stageHeight:int = 480;			
			// launch Starling
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, 320, 480), 
				ScaleMode.SHOW_ALL, iOS);
			
			mStarling = new Starling(ATFTextureTest, stage);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				
				var game:ATFTextureTest = mStarling.root as ATFTextureTest;
				
				game.start();
				mStarling.start();
			});
		}
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
	}
}