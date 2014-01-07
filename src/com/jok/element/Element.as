package com.jok.element
{
	import com.jok.sprites.Board;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class Element {
		
		public static const size : Number = 90;
		private var _column : Number = 0;
		private var _row : Number = 0;
		
		public var image : Image;
		
		public function Element(row : Number, column : Number, texture : Texture = null) {
			
			this.column = column;
			this.row = row;

			this.image = new Image(texture);
			this.image.alpha = 1.0;
			
			this.image.width = size;
			this.image.height = size;
			
			this.setPositionOnBoard();
		}
		
		public static function convertRowToPosition(r : Number) : Number {
			return ((600 - Board.boardHeight * Element.size) / 2) + (r * size);
		}
		
		public static function convertColumnToPosition(c : Number) : Number {
			return ((800 - Board.boardWidth * Element.size) / 2) + (c * size);
		}
		
		public function setPositionOnBoard() : void {
			this.image.x = convertColumnToPosition(column);
			this.image.y = convertRowToPosition(row);
		}
		
		public function getRelativePosition() : Number {
			return (Board.boardWidth * this.row) + this.column;
		}
		
		public function setRelativePosition(p : Number) : void {
			this._column = p % Board.boardWidth;
			this._row = Math.floor(p / Board.boardWidth);
		}
		
		public function get column() : Number {
			return _column;
		}
		
		public function set column(value : Number) : void {
			_column = value;
		}
		
		public function get row() : Number {
			return _row;
		}
		
		public function set row(value : Number) : void {
			_row = value;
		}
		
	}
}