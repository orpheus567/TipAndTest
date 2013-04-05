package test.iframe
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import orpheus.movieclip.TestButton;
	import orpheus.utils.NetUtil;
	
	public class IFrameTest extends Sprite
	{
		private var $testBtn:MovieClip;
		public function IFrameTest()
		{
			super();
			$testBtn = TestButton.btn(1000,1000);
			$testBtn.addEventListener(MouseEvent.CLICK,onClick);
			addChild($testBtn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			NetUtil.getURL("http://naver.com","_parent");
		}
	}
}