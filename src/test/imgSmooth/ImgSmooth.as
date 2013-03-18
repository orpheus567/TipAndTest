package test.imgSmooth
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import orpheus.movieclip.TestButton;
	
	public class ImgSmooth extends Sprite
	{
		[Embed(source="../../../asset/suji.jpg")] public var Img:Class;
		private var $img:Bitmap;
		private var $testBtn:MovieClip;
		private var $imgCoverBank:Array=[];
		public function ImgSmooth()
		{
			super();
			stage.scaleMode = "noScale";
			stage.align = "TL";
			for (var i:int = 0; i < 2; i++) 
			{
				var imgCover = new Sprite;
				addChild(imgCover);
				$img = new Img;
				$img.x = int($img.width/2*-1);
				$img.y = int($img.height/2*-1);
				imgCover.addChild($img);
				imgCover.x = ($img.width*i)+200;
				imgCover.y = $img.height;
				$imgCoverBank.push(imgCover);
			}
			
			
		$testBtn = TestButton.btn();
		$testBtn.x = $testBtn.y = 30;
		addChild($testBtn);
		$testBtn.addEventListener(MouseEvent.CLICK,onClick);
		$testBtn = TestButton.btn();
		$testBtn.x = 60; 
		$testBtn.y = 30;
		addChild($testBtn);
		$testBtn.addEventListener(MouseEvent.CLICK,onClick2);
		}
		
		protected function onClick2(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			$imgCoverBank[1].z = 0;
			TweenLite.delayedCall(.5,resetImg);
		}
		
		private function resetImg():void
		{
			var mtrx:Matrix = new Matrix(1,0,0,1,$imgCoverBank[1].x,$imgCoverBank[1].y);
			$imgCoverBank[1].transform.matrix = mtrx;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			$imgCoverBank[0].z = 0;
		}
	}
}