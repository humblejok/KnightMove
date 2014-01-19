package com.jok.utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsProvider {
		
		[Embed(source="/../assets/ChessKing.png")]
		public static var chessKing : Class;
		
		[Embed(source="/../assets/BackGround.png")]
		public static var backGround : Class;
		
		[Embed(source="/../assets/WhiteBoard.png")]
		public static var whiteBoard : Class;
		
		[Embed(source="/../assets/BlackBoard.png")]
		public static var blackBoard : Class;
		
		[Embed(source="/../assets/ChessKnight.png")]
		public static var chessKnight : Class;
		
		[Embed(source="/../assets/ChessBlob.png")]
		public static var chessBlob : Class;
		
		[Embed(source="/../assets/Pause.png")]
		public static var pause : Class;
		
		[Embed(source="/../assets/Target.png")]
		public static var target : Class;
		
		[Embed(source="/../assets/BADABB__.TTF", fontFamily="badaboomFontName", embedAsCFF="false")]
		public static var badaboomFont:Class;

		[Embed(source="/../assets/white-starling.png")]
		public static const whiteTextures : Class;
		
		[Embed(source="/../assets/white-starling.xml", mimeType="application/octet-stream")]
		public static const whiteXml : Class;
		
		[Embed(source="/../assets/black-starling.png")]
		public static const blackTextures : Class;
		
		[Embed(source="/../assets/black-starling.xml", mimeType="application/octet-stream")]
		public static const blackXml : Class;
		
		private static var textures : Dictionary = new Dictionary();
		
		private static var texturesWhiteAtlas : TextureAtlas;
		private static var texturesBlackAtlas : TextureAtlas;
		
		public function AssetsProvider() {
		}
		
		public static function getAnimatedWhite() : TextureAtlas {
			if (texturesWhiteAtlas==null) {
				var texture : Texture = getAsTexture("whiteTextures");
				var xml : XML = XML(new whiteXml());
				texturesWhiteAtlas = new TextureAtlas(texture, xml);
			}
			return texturesWhiteAtlas;
		}
		
		public static function getAnimatedBlack() : TextureAtlas {
			if (texturesBlackAtlas==null) {
				var texture : Texture = getAsTexture("blackTextures");
				var xml : XML = XML(new blackXml());
				texturesBlackAtlas = new TextureAtlas(texture, xml);
			}
			return texturesBlackAtlas;
		}
		
		
		public static function getAsTexture(texture : String) : Texture {
			if (textures[texture]== undefined) {
				var bitmap : Bitmap = new AssetsProvider[texture]();
				textures[texture] = Texture.fromBitmap(bitmap);
			}
			return textures[texture];
		}
	}
}