package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	import com.jok.sprites.Board;
	
	import flash.geom.Point;

	public class KnightElement extends Element {
		
		public function KnightElement(parent : Board,row : Number, column : Number) {
			super(parent, row, column, AssetsProvider.getAsTexture("chessKnight"));
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
			var fpsSpeed : Number = Math.floor(60 * (Board.speed / 1000));
			
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
	}
}