package com.jok.element
{
	import com.jok.sprites.Board;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class Element {
		
		public var size : Number = 90;
		
		private var _column : Number = 0;
		private var _row : Number = 0;
		private var _board : Board;
		
		public var image : Image;
		
		public function Element(parent : Board, row : Number, column : Number, texture : Texture = null, resize : Boolean = true) {
			
			this.column = column;
			this.row = row;
			this._board = parent;

			this.image = new Image(texture);
			this.image.alpha = 1.0;
			if (resize) {
				this.image.width = size;
				this.image.height = size;
			}
			
			this.displayOnBoard();
		}
		
		public function convertRowToPosition(r : Number) : Number {
			return ((600 - Board.boardHeight * this.size) / 2) + (r * this.size);
		}
		
		public function convertColumnToPosition(c : Number) : Number {
			return ((800 - Board.boardWidth * this.size) / 2) + (c * this.size);
		}
		
		public function displayOnBoard() : void {
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

		public function get board() : Board {
			return _board;
		}

		public function set board(value : Board) : void {
			_board = value;
		}

		
	}
}