package test.cam
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.media.Camera;
	import flash.media.Video;
	
	import orpheus.movieclip.TestButton;

	[SWF(width="1280",height="720",frameRate="30")]
	public class WebCamTest extends Sprite
	{
		private var cam:Camera;
		protected var vid:Video;
		protected var _videoCover:Sprite;
		private var $mcblend:Sprite;
		[Embed(source="../../../asset/bokeh0.jpg")] public var Bokeh0:Class;
		[Embed(source="../../../asset/bokeh0.jpg")] public var Bokeh1:Class;
		[Embed(source="../../../asset/bokeh0.jpg")] public var Bokeh2:Class;
		[Embed(source="../../../asset/bokeh0.jpg")] public var Bokeh3:Class;
		
		public function WebCamTest()
		{
			super();
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			cam = Camera.getCamera();
			_videoCover = new Sprite;
//			$videoCover.visible =false;
			addChild(_videoCover);
			if (!cam) 
			{
				trace("No camera is installed.");
			}
			else 
			{
				connectCamera();
			}
			setting();
		}
		
		protected function setting():void
		{
			
		}
		
		private function showVideo():void
		{
			_videoCover.visible =true;
		}
		
		private function connectCamera():void 
		{
			cam.setMode(1280, 720, 25); 
			cam.setQuality(0,100);
			
			vid             = new Video();
			vid.smoothing = true;
			vid.width       = 1920;
			vid.height      = 1080; 
			vid.attachCamera(cam);
			
			$mcblend = new Sprite;
			addChild($mcblend);
			
//			$mcblend.addChild(new Bokeh0);
//			$mcblend.blendMode = BlendMode.OVERLAY;
			_videoCover.addChild(vid);    
			
//			TweenMax.to($videoCover, .1, {colorMatrixFilter:{amount:1, saturation:0,onComplete:showVideo}});
//			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			
			return;
			trace("cam.width: ",cam.width);
			switch (cam.width) {
				case 160:
					cam.setMode(320, 240, 10); 
					break;
				case 320:
					cam.setMode(640, 480, 5); 
					break;
				default:
					cam.setMode(160, 120, 15); 
					break;
			} 
			removeChild(vid);           
			connectCamera();
		}
	}
}