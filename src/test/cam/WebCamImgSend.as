package test.cam
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	import orpheus.nets.UploadBitmap;
	import orpheus.utils.Stats;

	public class WebCamImgSend extends WebCamTest
	{
		private var $upLoader:UploadBitmap;
		public function WebCamImgSend()
		{
			super();
		}
		override protected function setting():void
		{
			stage.addEventListener(MouseEvent.CLICK,captureImg);
			addChild(new Stats);
		}
		
		protected function captureImg(event:MouseEvent):void
		{
			var bitmapData:BitmapData = new BitmapData(1280,720);
			bitmapData.draw(_videoCover);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			//addChild(bitmap);		
			var urlVars:URLVariables = new URLVariables;
			urlVars.name = "애드쿠아";
			urlVars.cel1 = "010";
			urlVars.cel2 = "1234";
			urlVars.cel3 = "5678";
			urlVars.bagType = "red";
			
//			$upLoader = new UploadBitmap("http://mcm.adqua.co.kr/process/EventSave.ashx",
//				{onComplete:onComplete});
//			$upLoader.upload(bitmap,urlVars);
		}
		
		private function onComplete(data:Object):void
		
		{
			//			Debug.alert("사진전송완료");
			trace("전송완료");
		}
	}
}