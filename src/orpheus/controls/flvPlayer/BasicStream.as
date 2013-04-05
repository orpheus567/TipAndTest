﻿package orpheus.controls.flvPlayer {	import caurina.transitions.Tweener;		import flash.display.Sprite;	import flash.events.AsyncErrorEvent;	import flash.events.NetStatusEvent;	import flash.events.SecurityErrorEvent;	import flash.media.SoundTransform;	import flash.net.NetConnection;	import flash.net.NetStream;		import orpheus.controls.flvPlayer.events.CuePointEvent;	import orpheus.controls.flvPlayer.events.MetaDataEvent;	import orpheus.controls.flvPlayer.events.MovieStatusEvent;		/**	 * @author philip	 */	public class BasicStream extends Sprite 	{		private var nc:NetConnection;		public var playerStream:NetStream;		private var _duration:Number;		private var _width:Number;		private var _height:Number;		protected var fmsURL:String;		private var _nowState:String = "stop";		public var _volume:Number = 1;				protected var _movieArr:Array = new Array();		private var nowPlay:uint;		private var sndTrans:SoundTransform;		private var _mute:Boolean;		private var _muteVolume:Number = 1;		private var _oldFile:String;		public function BasicStream(fmsURL:String = null) 		{			this.fmsURL = fmsURL;			nc = new NetConnection();			nc.client = this;						nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);			if (fmsURL != "wait") connect(fmsURL);		}				public function connect(fmsURL:String = null):void		{			if (fmsURL) this.fmsURL = fmsURL;			nc.connect(fmsURL);		}				public function close():void		{			ns.close();			nc.close();		}		public function playMovies(...arg):void 		{			_movieArr = arg;			nowPlay = 0;			moviePlay(_movieArr[nowPlay]);		}		public function playMovies2(arg:Array):void 		{			_movieArr = arg;			nowPlay = 0;			moviePlay(_movieArr[nowPlay]);		}		public function nextMovie():void 		{			if (_movieArr.length <= 1) return;						nowPlay++;			if (nowPlay >= _movieArr.length) 			{				trace("모든 무비 플레이 완료");				dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STATUS_EVENT, MovieStatusEvent.NETSTREAM_ALL_STOP));			}			else 			{				moviePlay(_movieArr[nowPlay]);			}		}		public function prevMovie():void 		{			if (_movieArr.length <= 1) return;						var num:int = nowPlay - 1;			if (num > 0) 			{				nowPlay = num;				moviePlay(_movieArr[nowPlay]);			}		}		public function play(file:String = null, seek:Number = 0):void 		{			_movieArr = new Array();			moviePlay(file, seek);		}		private function moviePlay(file:String = null, seek:Number = 0):void 		{			if (!file) file = _oldFile;			if (!file) return;			_oldFile = file;			dispatchEvent(new MovieStatusEvent(MovieStatusEvent.START, _oldFile));						if(fmsURL) 			{				if (file.substr(-4) == ".mp3") 				{					file = "mp3:" + file.substr(0, file.length - 4);				}				else if (file.substr(-4) == ".mp4" || file.substr(-4) == ".mov" || file.substr(-4) == ".aac" || file.substr(-4) == ".m4a") 				{					file = "mp4:" + file;				}				else if (file.substr(-4) == ".flv") 				{					file = file.substr(0, file.length - 4);				}			}			_nowState = "play";			if (!playerStream)			{				trace("netStream객체가 생성되지 않았습니다.");				return;			}			playerStream.play(file, seek);						volume = _volume;		}		public function stop():void 		{			_nowState = "stop";			dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STATUS_EVENT, MovieStatusEvent.STOP));			dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STOP));			playerStream.close();		}		public function pause(b:Boolean = true, isSeeking:Boolean = false):void 		{			if (b) 			{				if (_nowState == "play" || (_nowState == "stop" && isSeeking)) 				{					_nowState = "pause";					playerStream.pause();					if(!isSeeking)					{						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STATUS_EVENT, MovieStatusEvent.PAUSE));						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.PAUSE));					}				}			}			else 			{				if (_nowState == "pause") 				{					_nowState = "play";					playerStream.resume();					if(!isSeeking)					{						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STATUS_EVENT, MovieStatusEvent.RESUME));						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.RESUME));					}				}			}		}				public function resume():void 		{			pause(false);		}		/**		 * 초 단위로 seek		 */		public function seek(time:Number):void		{			ns.seek(time);		}				/**		 * 퍼센트 단위로 seek (1 : 100%)		 */		public function seekPercent(percent:Number):void		{			ns.seek(duration * percent);		}				private function netStatusHandler(event:NetStatusEvent):void 		{			switch(event.info["code"]) 			{				case "NetConnection.Connect.Success" : 					createNetStream(); 					break;				case "NetStream.Play.StreamNotFound": 					_nowState = "stop";					trace("Stream not found");					if (_movieArr.length > 1 && nowState != "stop") nextMovie(); 					break;				case MovieStatusEvent.NETSTREAM_PLAY_STOP : 					if (!fmsURL) 					{						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.COMPLETE, _oldFile));						if (_movieArr.length > 1 && nowState != "stop") {							//nextMovie();						}else {//							_nowState = "stop";						}					}					else					{						_nowState = "stop";					}					break;			}			dispatchEvent(new MovieStatusEvent(MovieStatusEvent.STATUS_EVENT, event.info["code"]));		}		private function createNetStream():void 		{			if (playerStream) 			{				playerStream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);				playerStream.close();			}			playerStream = new NetStream(nc);			playerStream.client = this;			playerStream.checkPolicyFile = true;			trace("playerStream.checkPolicyFile: ",playerStream.checkPolicyFile);			playerStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);			dispatchEvent(new MovieStatusEvent(MovieStatusEvent.CREATE_NETSTREAM));		}		public function onPlayStatus(obj:Object):void 		{			switch(obj["code"]) 			{				case MovieStatusEvent.NETSTREAM_PLAY_COMPLETE :					dispatchEvent(new MovieStatusEvent(MovieStatusEvent.COMPLETE, _oldFile));					if (_movieArr.length > 1 && nowState != "stop"){						nextMovie();					}					break;			}						if(stage)stage.dispatchEvent(new MovieStatusEvent(MovieStatusEvent.PLAY_STATUS_EVENT, obj["code"]));		}		public function onXMPData(e:*):void 		{		}		private function onAsyncError(event:AsyncErrorEvent):void 		{			trace("onAsyncError");		}		private function onSecurityError(event:SecurityErrorEvent):void 		{			trace("onSecurityError");		}				public function onMetaData(info:Object):void 		{			_duration = info["duration"];			_width = info["width"];			_height = info["height"];			//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);			dispatchEvent(new MetaDataEvent(info, MetaDataEvent.METADATA));		}		public function onCuePoint(info:Object):void 		{			dispatchEvent(new CuePointEvent(info, CuePointEvent.CUE_POINT));			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);		}		public function onBWDone():void 		{		}				public function onLastSecond(info:Object = null):void		{		}		public function get duration():Number 		{			return _duration;		}				public function set duration(time:Number):void 		{			_duration = time;		}		public function get metaWidth():Number 		{			return _width;		}		public function get metaHeight():Number 		{			return _height;		}		public function get ns():NetStream 		{			return playerStream;		}		public function get nowState():String 		{			return _nowState;		}				public function set nowState(state:String):void 		{			_nowState = state;		}				/**		 * 볼륨		 */		public function get volume():Number		{			return _muteVolume;		}				public function set volume(volume:Number):void		{			if (_mute) 			{				_muteVolume = volume;				return;			}			Tweener.removeTweens(this);			_volume = volume;			volumeChange();		}				/**		 * 음소거		 */		public function set mute(mute:Boolean):void		{			_mute  = mute;			tweenVolume(_mute ? 0 : _muteVolume);			volumeChange();						dispatchEvent(new MovieStatusEvent(MovieStatusEvent.MUTE, mute));		}		public function get mute():Boolean		{			return _mute;		}				public function tweenVolume(volume:Number):void		{			Tweener.addTween(this, {_volume:volume, time:1, onUpdate:volumeChange, transition:"linear"});		}		private function volumeChange():void		{			if (!_mute) _muteVolume = _volume;			if (playerStream)			{				if (!sndTrans) sndTrans = new SoundTransform();				sndTrans.volume = _volume;				ns.soundTransform = sndTrans;			}		}				public function get source():*		{			if (_movieArr.length) return _movieArr;			else return _oldFile;		}				public function set source(source:*):void		{			if (source is Array)			{				_movieArr = source["concat"]();			}			else			{				_oldFile = source;			}		}				public function get filename():String		{			return _oldFile;		}	}}