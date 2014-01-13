package com.jok.element
{
	import com.jok.sprites.BlackSprite;
	import com.jok.sprites.Board;
	import com.jok.sprites.WhiteSprite;
	
	import starling.display.Sprite;
	
	public class BoardElement {
		
		public static const ALPHAS : Array = [0.0, 0.33, 0.66, 1.0];
		
		public var size : Number = 90;
		public var animatedSprite : Sprite;

		private var _hit : Number = 3;
		private var _column : Number = 0;
		private var _row : Number = 0;
		private var _board : Board;
		
		public function BoardElement(parent : Board, row : Number, column : Number) {
			this.animatedSprite = (row + column)%2==1?new BlackSprite():new WhiteSprite();
			this._column = column;
			this._row = row;
			this._board = parent;
		}
		
		public function displayOnBoard() : void {
			this.animatedSprite.x = convertColumnToPosition(_column) + Math.floor(this.size / 2);
			this.animatedSprite.y = convertRowToPosition(_row) + Math.floor(this.size / 2);
		}
		
		public function get hit() : Number {
			return _hit;
		}

		public function elementHit() : void {
			_hit -= 1;
			animatedSprite["animate"]();
		}
		
		public function spin() : void {
		}
		
		public function repair(complete : Boolean = false) : void {
			if (!complete) {
				if (_hit==0) {
					_hit = 1;
					this._board.scoreValue += 50;
					this.animatedSprite.alpha = BoardElement.ALPHAS[_hit];
				}
			} else {
				this._hit = 3;
				this.animatedSprite.alpha = BoardElement.ALPHAS[_hit];
			}
		}

		public function convertRowToPosition(r : Number) : Number {
			return ((600 - Board.boardHeight * this.size) / 2) + (r * this.size);
		}
		
		public function convertColumnToPosition(c : Number) : Number {
			return ((800 - Board.boardWidth * this.size) / 2) + (c * this.size);
		}
		
	}
}