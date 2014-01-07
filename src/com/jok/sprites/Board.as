package com.jok.sprites
{
	import com.jok.element.BoardElement;
	import com.jok.element.KnightElement;
	import com.jok.mover.KnightMover;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class Board extends Sprite {
		
		public static var boardWidth : Number = 8;
		
		public static var boardHeight : Number = 4;
		
		public static var speed : Number = 500;
		
		private var background : Image;
		private var checkboxes : Array;
		private var startButton : Button;
		private var pauseButton : Button;
		
		private var players : Array = new Array();
		
		private var timePrevious : Number;
		
		private var previousStatus : String = null;
		
		private var _status : String = "moving";
		private var currentMovement : Number;
		private var _pathes : Array = new Array();
		private var _currentMvtGap : Number;
		
		public function Board() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void {
			trace("Board added")
			background = new Image(AssetsProvider.getAsTexture("backGround"));
			this.addChild(background);
			
			checkboxes = new Array(Board.boardHeight * Board.boardWidth);
			for (var i : Number = 0;i<Board.boardHeight * Board.boardWidth;i++) {
				checkboxes[i] = new BoardElement(Math.floor(i / Board.boardWidth), i % Board.boardWidth);
				this.addChild(checkboxes[i].image);
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
			if (status=="paused") {
				status = previousStatus;
				timePrevious = getTimer()-_currentMvtGap;
			} else {
				previousStatus = status;
				status = "paused";
				_currentMvtGap = getTimer()-timePrevious;
			}
			trace("Pause clicked - " + status + " - " + _currentMvtGap);
		}
		
		private function onStartButtonTriggered(event : Event) : void {
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
			startButton.visible = false;
			pauseButton.visible = true;
			
			this.players.push(new KnightMover(new KnightElement(2,4)));
			this.addChild(players[0].knight.image); // TODO Change to dynamic
			status = "move";
			timePrevious = getTimer();
			this.addEventListener(Event.ENTER_FRAME, checkTimeElapsed);
		}
		
		private function checkTimeElapsed(event : Event):void {
			var p : KnightMover;
			switch(status) {
				case "move": {
					trace(getTimer() + " - Move");
					if (getTimer()-timePrevious>Board.speed) {
						for each(p in players) {
							var movements : Array = p.computeRealizableMovements();
							trace("Movement - " + movements);
							var index : Number = Math.round(Math.random() * (movements.length + 1) );
							while (index>=movements.length) {
								index = Math.round(Math.random() * (movements.length + 1) );
							}
							currentMovement = movements[index];
							trace("Movement - INDEX:" + index + " MVT:" + movements[index]);
						}
						_status = "moving";
						_pathes = new Array();
					}
					break;
				}
				case "moving": {
					if (_pathes.length==0) {
						for each(p in players) {
							_pathes.push(p.knight.predictMovement(currentMovement));
						}
					}
					trace(getTimer() + " - Moving - Remains " + _pathes[0])
					for (var i : Number = 0;i<_pathes.length; i++) {
						var point : Point = _pathes[i][0];
						players[i].knight.image.x = point.x;
						players[i].knight.image.y = point.y;
						_pathes[i].shift();
					}
					if (_pathes[_pathes.length-1].length==0) {
						_status = "move";
						for each(p in players) {
							var position : Number = p.knight.getRelativePosition() + currentMovement;
							p.knight.setRelativePosition(position);
							checkboxes[position].elementHit();
							if (checkboxes[position].hit==0) {
								var tf : TextField = new TextField(300,100,"Game Over","Verdana", 36, 0xDD11FDD, true);
								tf.x = 250;
								tf.y = 250;
								this.addChild(tf);
								onPauseButtonTriggered(null); 
							}
						}
						timePrevious = getTimer();
					}
				}
				case "paused":
				default:
				{
					break;
				}
			}
		}
		
		public function initialize() : void {
			this.visible = true;
		}

		public function get status() : String {
			return _status;
		}

		public function set status(value:String) : void {
			_status = value;
		}

	}
}