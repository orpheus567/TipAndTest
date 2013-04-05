package orpheus.utils
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class BtnEffect
	{
		public function BtnEffect()
		{
			
		}
		public static function overBNC(event:MouseEvent):void{
			var mc:DisplayObject = event.currentTarget as DisplayObject;
			TweenMax.to(mc,.5,{colorMatrixFilter:{brightness:1.1,contrast:1.1}});
		}
		public static function outBNC(event:MouseEvent):void{
			var mc:DisplayObject = event.currentTarget as DisplayObject;
			TweenMax.to(mc,.5,{colorMatrixFilter:{brightness:1,contrast:1},
				onComplete:reset,
				onCompleteParams:[mc]
			});
		}
		
		private static function reset(mc:DisplayObject):void
		{
			mc.filters = [];
		}
	}
}