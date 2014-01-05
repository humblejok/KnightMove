package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	import com.jok.sprites.Board;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class BoardElement {
		
		
		public const size : Number = 90;
		public var x : Number = 0;
		public var y : Number = 0;
		
		public var image : Image;
		
		public function BoardElement(row : Number, column : Number) {
			this.x = ((800 - Board.boardWidth * size) / 2) + (column * size);
			this.y = (600 - Board.boardHeight * size) / 2 + (row * size);
			
			var texture : Texture = (row + column)%2==1?AssetsProvider.getAsTexture("blackBoard"):AssetsProvider.getAsTexture("whiteBoard");
			this.image = new Image(texture);
			this.image.x = this.x;
			this.image.y = this.y;
			this.image.width = size;
			this.image.height = size;
		}
	}
}