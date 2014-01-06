package com.jok.sprites
{
	import com.jok.element.BoardElement;
	import com.jok.mover.KnightMover;
	
	import flash.utils.getTimer;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Board extends Sprite {
		
		public static var boardWidth : Number = 8;
		
		public static var boardHeight : Number = 4;
		
		public static var speed : Number = 750;
		
		private var background : Image;
		private var checkboxes : Array;
		private var startButton : Button;
		private var pauseButton : Button;
		
		private var players : Array = new Array();
		
		private var timePrevious : Number;
		
		private var paused : Boolean = false;
		
		public function Board() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void {
			trace("Board added")
			background = new Image(AssetsProvider.getAsTexture("backGround"));
			this.addChild(background);
			
			checkboxes = new Array(Board.boardWidth);
			for (var i : Number = 0;i<Board.boardWidth;i++) {
				checkboxes[i] = new Array(Board.boardHeight);
				for (var j : Number = 0;j<Board.boardHeight; j++) {
					checkboxes[i][j] = new BoardElement(j,i);
					this.addChild(checkboxes[i][j].image);
				}
			}
			
			startButton = new Button(AssetsProvider.getAsTexture("chessKing"));
			startButton.x = 144;
			startButton.y = 44;
			startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered );
			this.addChild(startButton);
			
			pauseButton = new Button(AssetsProvider.getAsTexture("pause"));
			pauseButton.x = 700;
			pauseButton.y = 20;
			pauseButton.width = 40;
			pauseButton.height = 40;
			pauseButton.visible = false;
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered );
			pauseButton.addEventListener(Event.TRIGGERED, onPauseButtonTriggered );
			this.addChild(startButton);
			this.addChild(pauseButton);
			
		}
		
		private function onPauseButtonTriggered(event : Event) : void {
			paused = !paused;
			trace("Pause clicked - " + paused);
		}
		
		private function onStartButtonTriggered(event : Event) : void {
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
			startButton.visible = false;
			pauseButton.visible = true;
			
			this.players.push(new KnightMover(new BoardElement(2,4, AssetsProvider.getAsTexture("chessKnight"))));
			this.addChild(players[0].knight.image); // TODO Change to dynamic
			this.addEventListener(Event.ENTER_FRAME, checkTimeElapsed);
			
			timePrevious = getTimer();
		}
		
		private function checkTimeElapsed(event : Event):void {
			if (!paused) {
				if (getTimer()-timePrevious>Board.speed) {
					timePrevious = getTimer();
					for each(var p : KnightMover in players) {
						var movements : Array = p.computeRealizableMovements();
						var index : Number = Math.round(Math.random() * (movements.length + 1) );
						while (index>=movements.length) {
							index = Math.round(Math.random() * (movements.length + 1) );
						}
						trace("Movement - INDEX:" + index + " MVT:" + movements[index]);
						p.move(movements[index]);
					}
				}
			}
		}
		
		public function initialize() : void {
			this.visible = true;
		}
	}
}