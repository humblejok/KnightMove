package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	import com.jok.sprites.Board;
	
	import starling.utils.deg2rad;
	
	public class BoardElement extends Element {
		
		public static const ALPHAS : Array = [0.0, 0.33, 0.66, 1.0];
		public static const FLIP : Number = 60;
		
		private var flipping : Number = 0;
		private var flipLimit : Number = 90;
		private var flipStep : Number = flipLimit / BoardElement.FLIP;
		
		private var _hit : Number = 3;
		
		public function BoardElement(parent : Board, row : Number, column : Number) {
			super(parent, row, column, (row + column)%2==1?AssetsProvider.getAsTexture("blackBoard"):AssetsProvider.getAsTexture("whiteBoard"));
			this.image.rotation = 0.0;
		}
		
		override public function setPositionOnBoard() : void {
			this.image.alignPivot();
			this.image.x = convertColumnToPosition(column) + Math.floor(this.size / 2);
			this.image.y = convertRowToPosition(row) + Math.floor(this.size / 2);
		}
		
		public function get hit() : Number {
			return _hit;
		}

		public function elementHit() : void {
			_hit -= 1;
			if (_hit>=0) {
				this.flipping = FLIP;
			}
			if (_hit==0) {
				this.board.scoreValue += 50;
			}
		}
		
		public function spin() : void {
			if (flipping>0) {
				this.image.rotation = this.image.rotation + deg2rad(flipStep);
				flipping -= 1;
				if (flipping==0) {
					this.image.alpha = BoardElement.ALPHAS[_hit];
				}
			}
		}

	}
}