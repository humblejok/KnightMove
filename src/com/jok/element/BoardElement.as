package com.jok.element
{
	import com.jok.sprites.AssetsProvider;
	
	public class BoardElement extends Element {
		
		public static const ALPHAS : Array = [0.0, 0.33, 0.66, 1.0];
		public static const FLIP : Number = 60;
		
		private var flipping : Number = 0;
		
		private var _hit : Number = 3;
		
		public function BoardElement(row : Number, column : Number) {
			super(row, column, (row + column)%2==1?AssetsProvider.getAsTexture("blackBoard"):AssetsProvider.getAsTexture("whiteBoard"));
		}
		
		
		public function get hit() : Number {
			return _hit;
		}

		public function elementHit() : void {
			_hit -= 1;
			this.image.alpha = BoardElement.ALPHAS[_hit];
		}

	}
}