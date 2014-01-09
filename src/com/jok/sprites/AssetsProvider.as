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
		
		[Embed(source="/../assets/ChessKnight.png")]
		public static var chessKnight : Class;
		
		[Embed(source="/../assets/ChessBlob.png")]
		public static var chessBlob : Class;
		
		[Embed(source="/../assets/Pause.png")]
		public static var pause : Class;
		
		[Embed(source="/../assets/BADABB__.TTF", fontFamily="BadaboomFont", embedAsCFF="false")]
		public static var MyFont:Class;
		
		
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