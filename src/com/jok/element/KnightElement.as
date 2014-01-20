package com.jok.element
{
	import com.jok.sprites.Board;
	import com.jok.utils.AssetsProvider;
	
	import flash.geom.Point;

	public class KnightElement extends Element {
		
		private static var movements : Array = [-17, -15, -10, -6, 6, 10, 15, 17];
		private static var limit : Number = Board.boardWidth * Board.boardHeight;
		
		private var _targetRelativePosition : Number = -1;
		
		public function KnightElement(parent : Board,row : Number, column : Number) {
			super(parent, row, column, AssetsProvider.getAsTexture("chessKnight"));
			this._targetRelativePosition = this.getRelativePosition();
		}
		
		public function predictMovement(movement : Number) : Array {
			var results : Array = new Array();
			
			var relativePosition : Number = this.getRelativePosition() + movement;
			var newColumn : Number = relativePosition % Board.boardWidth;
			var newRow : Number = Math.floor(relativePosition / Board.boardWidth);
			trace("NEW POSITION:" + relativePosition + " - X=" + newColumn + " - Y=" + newRow);
			var targetX : Number = convertColumnToPosition(newColumn) - this.image.x;
			var targetY : Number = convertRowToPosition(newRow) - this.image.y;
			trace("STARTING:" + this.image.x + "/" + this.image.y + " - TARGET:" + targetX + " - " + targetY);
			var fpsSpeed : Number = Math.floor(60 * (this.board.speed / 1000));
			
			targetX = targetX / fpsSpeed;
			targetY = targetY / fpsSpeed;
			
			var previousPoint : Point = new Point(this.image.x, this.image.y);
			for (var i : Number = 1; i<fpsSpeed; i++) {
				var point : Point = new Point(Math.round(previousPoint.x + targetX * i), Math.round(previousPoint.y + targetY * i));
				results.push(point);
			}
			results.push(new Point(convertColumnToPosition(newColumn),convertRowToPosition(newRow)));
			return results;
		}
		
		public function computeRealizableMovements() : Array {
			var results : Array = new Array();
			for each (var m : Number in KnightElement.movements) {
				var result : Number = this._targetRelativePosition + m;
				var moduloSource : Number = this._targetRelativePosition % Board.boardWidth;
				var moduloTarget : Number = result % Board.boardWidth;
				var offset : Number = Math.abs(moduloTarget - moduloSource);
				if (result>=0 && result<KnightElement.limit && offset<=2) {
					results.push(m);
				}
			}
			return results;
		}

		public override function setRelativePosition(p : Number) : void {
			super.setRelativePosition(p);
			this._targetRelativePosition = p;
		}
		
		public function get targetRelativePosition() : Number {
			return _targetRelativePosition;
		}

		public function set targetRelativePosition(value : Number) : void {
			_targetRelativePosition = value;
		}

	}
}