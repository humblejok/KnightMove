package com.jok.sprites
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite {
		
		private var board : Board;
		
		public function Game() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event) : void {
			trace("Game is added");
			board = new Board();
			this.addChild(board);
			board.initialize();
		}
		
	}
}