package com.jok.sprites
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class AssetsProvider {
		
		[Embed(source="/../assets/ChessKing.png")]
		public static var chessKing : Class;
		
		[Embed(source="/../assets/BackGround.png")]
		public static var backGround : Class;
		
		[Embed(source="/../assets/WhiteBoard.png")]
		public static var whiteBoard : Class;
		
		[Embed(source="/../assets/BlackBoard.png")]
		public static var blackBoard : Class;
		
		
		private static var textures : Dictionary = new Dictionary();
		
		public function AssetsProvider() {
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