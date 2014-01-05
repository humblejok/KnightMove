package com.jok.sprites
{
	import com.jok.element.BoardElement;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Board extends Sprite {
		
		public static var boardWidth : Number = 8;
		
		public static var boardHeight : Number = 4;
		
		private var background : Image;
		private var checkboxes : Array;
		private var startButton : Button;
		
		public function Board() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void {
			trace("Board added")
			background = new Image(AssetsProvider.getAsTexture("backGround"));
			this.addChild(background);
			
			checkboxes = new Array(boardWidth);
			for (var i : Number = 0;i<boardWidth;i++) {
				checkboxes[i] = new Array(boardHeight);
				for (var j : Number = 0;j<boardHeight; j++) {
					checkboxes[i][j] = new BoardElement(j,i);
					this.addChild(checkboxes[i][j].image);
				}
			}
			
			startButton = new Button(AssetsProvider.getAsTexture("chessKing"));
			startButton.x = 144;
			startButton.y = 44;
			this.addChild(startButton);
		}
		
		public function initialize() : void {
			this.visible = true;
		}
	}
}