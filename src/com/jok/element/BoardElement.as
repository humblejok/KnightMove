package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	import com.jok.sprites.Board;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class BoardElement {
		
		
		public const size : Number = 90;
		private var _column : Number = 0;
		private var _row : Number = 0;
		
		public var image : Image;
		
		public function BoardElement(row : Number, column : Number, texture : Texture = null) {
			
			this.column = column;
			this.row = row;
			
			if (texture==null) {
				texture = (row + column)%2==1?AssetsProvider.getAsTexture("blackBoard"):AssetsProvider.getAsTexture("whiteBoard");
			}
			this.image = new Image(texture);

			this.image.width = size;
			this.image.height = size;
			
			this.setPositionOnBoard();
		}
		
		public function setPositionOnBoard() : void {
			this.image.x = ((800 - Board.boardWidth * size) / 2) + (column * size);
			this.image.y = ((600 - Board.boardHeight * size) / 2) + (row * size);
		}
		
		
		
		public function getRelativePosition() : Number {
			return (Board.boardWidth * this.row) + this.column;
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

		public function applyMovement(movement : Number) : void {
			var relativePosition : Number = this.getRelativePosition() + movement;
			this.column = relativePosition % Board.boardWidth;
			this.row = Math.floor(relativePosition / Board.boardWidth);
			trace("POSITION:" + relativePosition + " - X=" + this.column + " - Y=" + this.row);
			this.setPositionOnBoard();
		}
	}
}