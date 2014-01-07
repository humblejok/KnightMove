package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	import com.jok.sprites.Board;
	
	public class BlobElement extends Element {
			
		public function BlobElement(parent:Board, row:Number, column:Number) {
			super(parent, row, column, AssetsProvider.getAsTexture("chessBlob"));
			this.image.height = 52;
		}
		
		override public function convertRowToPosition(r : Number) : Number {
			return ((600 - Board.boardHeight * this.size) / 2) + (r * this.size) + 19;
		}
	}
}