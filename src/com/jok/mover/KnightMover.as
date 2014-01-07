package com.jok.mover
{
	import com.jok.element.KnightElement;
	import com.jok.sprites.Board;

	public class KnightMover {
		
		private var movements : Array = [-17, -15, -10, -6, 6, 10, 15, 17];
		
		private var _knight : KnightElement = null;
		
		private var limit : Number = Board.boardWidth * Board.boardHeight;
		
		public function KnightMover(knight : KnightElement) {
			this.knight = knight;
		}
		
		public function computeRealizableMovements() : Array {
			var results : Array = new Array();
			for each (var m : Number in movements) {
				var result : Number = knight.getRelativePosition() + m;
				var moduloSource : Number = knight.getRelativePosition() % Board.boardWidth;
				var moduloTarget : Number = result % Board.boardWidth;
				var offset : Number = Math.abs(moduloTarget - moduloSource);
				if (result>=0 && result<this.limit && offset<=2) {
					results.push(m);
				}
			}
			return results;
		}

		public function get knight() : KnightElement {
			return _knight;
		}

		public function set knight(value : KnightElement) : void {
			_knight = value;
		}

	}
}