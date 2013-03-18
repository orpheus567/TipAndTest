package test.fitScale
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import test.imgSmooth.ImgSmooth;
	
	public class FitScaleTest extends Sprite
	{
		[Embed(source="../../../asset/sujiBig.jpg")] public var Img:Class;
		private var _tRatio:Number;
		private var $img:Bitmap;
		public function FitScaleTest()
		{
			super();
			stage.scaleMode = "noScale";
			stage.align = "TL";
			$img = new Img;
			addChild($img);
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		protected function onResize(event:Event=null):void
		{
			var rect:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			pitScale($img,rect,true);
		}
		public function pitScale($target:DisplayObject,$rect:Rectangle,$isOut:Boolean=false,$align:String=null):void{
			var tw:Number;;//영역 가로
			var th:Number;;//영역 세로
			var ratio:Number;;//영역 가로세로 비율 (w/h)               
			var isOut:Boolean;;//target이 영역 밖으로 나가도 되느냐 아니냐대한 flag               
			tw=$rect.width;
			th=$rect.height;
			ratio=tw/th;
			if(!_tRatio){
				_tRatio=$target.width/$target.height;
			}
			isOut=$isOut;
			
			if ((_tRatio < ratio && !isOut) || (_tRatio > ratio && isOut)) {
				tw=th*_tRatio;
			}
			if ((_tRatio > ratio && !isOut) || (_tRatio < ratio && isOut)) {
				th=tw/_tRatio;
			}
			
			$target.width=tw;
			$target.height=th;               
			
		}		
	}
}