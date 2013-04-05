package texture
{
	import flash.utils.ByteArray;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ATFTextureTest extends Sprite
	{
		public function ATFTextureTest()
		{
			super();
		}
		[Embed(source="../../asset/textures/1x/compressed_texture.atf", mimeType="application/octet-stream")]
		public static const atlas:Class;
		
		[Embed(source="../../asset/textures/1x/atlas.xml",mimeType="application/octet-stream")]
		public static const xm:Class;
		
		public function start():void{
			var data:ByteArray = new atlas() as ByteArray;//cast atlas class to ByteArray first
			var t:Texture = Texture.fromAtfData(data);
			var x:XML = XML(new xm());
			var a:TextureAtlas = new TextureAtlas(t,x);
			
			var tt:Texture = a.getTexture("checkbox");
			var i:Image = new Image(tt);
			addChild(i);
			
		}
	}
}