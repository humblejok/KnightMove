package com.jok.element
{
	import com.jok.sprites.Board;
	import com.jok.sprites.BoardSprite;
	import com.jok.utils.AssetsProvider;
	
	public class BoardElement {
		
		public var size : Number = 90;
		public var animatedSprite : BoardSprite;

		private var _column : Number = 0;
		private var _row : Number = 0;
		private var _board : Board;
		
		public function BoardElement(parent : Board, row : Number, column : Number) {
			this.animatedSprite = (row + column)%2==1?new BoardSprite(AssetsProvider.getAnimatedBlack().getTextures("black_")):new BoardSprite(AssetsProvider.getAnimatedWhite().getTextures("white_"));
			this._column = column;
			this._row = row;
			this._board = parent;
			this.displayOnBoard();
		}
		
		public function displayOnBoard() : void {
			this.animatedSprite.x = convertColumnToPosition(_column) + Math.floor(this.size / 2);
			this.animatedSprite.y = convertRowToPosition(_row) + Math.floor(this.size / 2);
		}
		
		public function get hit() : Number {
			return animatedSprite.hit;
		}

		public function elementHit() : void {
			animatedSprite.hit -= 1;
			if (animatedSprite.hit==0) {
				this._board.scoreValue += 50;
			}
			this.animatedSprite.animate();
		}
		
		public function repair(complete : Boolean = false) : void {
			if (!complete) {
				if (animatedSprite.hit==0) {
					animatedSprite.hit = 1;
					this._board.scoreValue += 50;
				}
			} else {
				animatedSprite.hit = 3;
			}
			animatedSprite.applyHit();
			this.animatedSprite.animate();
		}

		public function convertRowToPosition(r : Number) : Number {
			return ((600 - Board.boardHeight * this.size) / 2) + (r * this.size);
		}
		
		public function convertColumnToPosition(c : Number) : Number {
			return ((800 - Board.boardWidth * this.size) / 2) + (c * this.size);
		}
		
	}
}