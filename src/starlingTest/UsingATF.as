package starlingTest
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class UsingATF extends Sprite
	{
		private static const PAD:Number = 5;
		
//		[Embed(source="earth.jpg")]
		private static const TEXTURE_BITMAPDATA:Class;
		
		[Embed(source="earth.atf", mimeType="application/octet-stream")]
		private static const TEXTURE_ATF:Class;
		
		private var program:Program3D;
		private var posUV:VertexBuffer3D;
		private var tris:IndexBuffer3D;
		private var textureBitmapData:Texture;
		private var textureATF:Texture;
		private var curTexture:Texture;
		private var context3D:Context3D;
		
		private var modeDisplay:TextField;
		
		public function UsingATF()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
		}
		
		protected function onContextCreated(ev:Event): void
		{
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			context3D = stage3D.context3D;            
			context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0);
			context3D.enableErrorChecking = true;
			
			makeButtons("BitmapData", "ATF");
			
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			assembler.assemble(
				Context3DProgramType.VERTEX,
				"mov op, va0\n" +
				"mov v0, va1"
			);
			var vertexProgram:ByteArray = assembler.agalcode;
			
			assembler.assemble(
				Context3DProgramType.FRAGMENT,
				"tex oc, v0, fs0 <2d,linear,mipnone,clamp,dxt1>"
			);
			var fragmentProgram:ByteArray = assembler.agalcode;
			
			program = context3D.createProgram();
			program.upload(vertexProgram, fragmentProgram);
			
			posUV = context3D.createVertexBuffer(4, 5);
			posUV.uploadFromVector(
				new <Number>[
					// X,  Y, Z, U, V
					-1,   -1, 0, 0, 1,
					-1,    1, 0, 0, 0,
					 1,    1, 0, 1, 0,
					 1,   -1, 0, 1, 1
				], 0, 4
			);
 
			// Create the triangles index buffer
			tris = context3D.createIndexBuffer(6);
			tris.uploadFromVector(
				new <uint>[
					0, 1, 2,
					2, 3, 0
				], 0, 6
			);
			var bd:BitmapData = new BitmapData(512,512,true,0xff0000);
			var bitmap:Bitmap = new Bitmap(bd);
			var bmd:BitmapData = (bitmap).bitmapData;
			textureBitmapData = context3D.createTexture(
				bmd.width,
				bmd.height,
				Context3DTextureFormat.BGRA,
				false
			);
			textureBitmapData.uploadFromBitmapData(bmd);
			
			var atfBytes:ByteArray = new TEXTURE_ATF() as ByteArray;
			textureATF = context3D.createTexture(
				512,
				512,
				Context3DTextureFormat.COMPRESSED,
				false
			);
			textureATF.uploadCompressedTextureFromByteArray(atfBytes, 0);
			curTexture = textureBitmapData;
			
			modeDisplay = new TextField();
			modeDisplay.autoSize = TextFieldAutoSize.LEFT;
			modeDisplay.defaultTextFormat = new TextFormat("_sans", 36);
			modeDisplay.text = "BitmapData";
			addChild(modeDisplay);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function makeButtons(...labels): Number
		{
			var curX:Number = PAD;
			var curY:Number = stage.stageHeight - PAD;
			for each (var label:String in labels)
			{
				var tf:TextField = new TextField();
				tf.mouseEnabled = false;
				tf.selectable = false;
				tf.defaultTextFormat = new TextFormat("_sans");
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.text = label;
				tf.name = "lbl";
				
				var button:Sprite = new Sprite();
				button.buttonMode = true;
				button.graphics.beginFill(0xF5F5F5);
				button.graphics.drawRect(0, 0, tf.width+PAD, tf.height+PAD);
				button.graphics.endFill();
				button.graphics.lineStyle(1);
				button.graphics.drawRect(0, 0, tf.width+PAD, tf.height+PAD);
				button.addChild(tf);
				button.addEventListener(MouseEvent.CLICK, onButton);
				if (curX + button.width > stage.stageWidth - PAD)
				{
					curX = PAD;
					curY -= button.height + PAD;
				}
				button.x = curX;
				button.y = curY - button.height;
				addChild(button);
				
				curX += button.width + PAD;
			}
			
			return curY - button.height;
		}
		
		private function onButton(ev:MouseEvent): void
		{
			var mode:String = ev.target.getChildByName("lbl").text;
			switch (mode)
			{
				case "BitmapData":
					curTexture = textureBitmapData;
					modeDisplay.text = "BitmapData";
					break;
				case "ATF":
					curTexture = textureATF;
					modeDisplay.text = "ATF";
					break;
			}
		}
		
		private function onEnterFrame(ev:Event): void
		{
			context3D.clear(0.5, 0.5, 0.5);
			context3D.setProgram(program);
			context3D.setTextureAt(0, curTexture);
			context3D.setVertexBufferAt(0, posUV, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, posUV, 3, Context3DVertexBufferFormat.FLOAT_2);
			context3D.drawTriangles(tris);
			context3D.present();
		}
	}
}
