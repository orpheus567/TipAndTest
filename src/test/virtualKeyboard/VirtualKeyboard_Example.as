package test.virtualKeyboard
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import orpheus.movieclip.TestButton;
	
	import test.virtualKeyboard.vitualkey.example.VirtualKeyboard;
	
	
	[SWF(width="780", height="630", frameRate="60", backgroundColor="0x0")]
	public class VirtualKeyboard_Example extends Sprite
	{
		private var _clip:TestKeyboardClip;
		private var _keyboard:VirtualKeyboard;

		private var $testBtn:MovieClip;
		
		public function VirtualKeyboard_Example()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			_clip = new TestKeyboardClip();
//			_clip["txt"+$a.selectable = false;
//			_clip.txt.setSelection(0,0);

			_keyboard = new VirtualKeyboard(_clip);
			addChild(_clip);
			
			$testBtn = TestButton.btn();
			$testBtn.x = 500;
			$testBtn.addEventListener(MouseEvent.CLICK,onClick);
			addChild($testBtn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		}
		
	}
}