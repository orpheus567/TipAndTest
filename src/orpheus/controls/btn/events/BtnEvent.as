﻿	package orpheus.controls.btn.events {	import flash.display.MovieClip;		import flash.events.Event;		/**	 * @author philip	 */	public class BtnEvent extends Event 	{		public static const ROLL_OVER:String = "ROLL_OVER";		public static const ROLL_OUT:String = "ROLL_OUT";		public static const CLICK:String = "CLICK";		public static const DOUBLE_CLICK:String = "DOUBLE_CLICK";		public var data:*;		public var tg:MovieClip;		public function BtnEvent(type:String, tg:MovieClip, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)		{			this.tg = tg;			this.data = data;			super(type, bubbles, cancelable);		}				override public function clone():Event		{			return new BtnEvent(type, tg, data, bubbles, cancelable);		}	}}