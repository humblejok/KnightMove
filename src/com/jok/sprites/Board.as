package com.jok.sprites
{
	import com.jok.element.BlobElement;
	import com.jok.element.BoardElement;
	import com.jok.element.KnightElement;
	
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
		private var information : TextField;
		private var score : TextField;
		private var blob : BlobElement;
		
		private var players : Array = new Array();
		
		private var timePrevious : Number;
		
		private var previousStatus : String = null;
		
		private var _status : String = "moving";
		private var currentMovement : Number;
		private var _pathes : Array = new Array();
		private var _currentMvtGap : Number;
		private var _scoreValue : Number = 0;
		
		private var _cleaningStep : Number = 127;
		
		public function Board() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void {
			trace("Board added")
			background = new Image(AssetsProvider.getAsTexture("backGround"));
			this.addChild(background);
			
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

			checkboxes = new Array(Board.boardHeight * Board.boardWidth);
			for (var i : Number = 0;i<Board.boardHeight * Board.boardWidth;i++) {
				checkboxes[i] = new BoardElement(this, Math.floor(i / Board.boardWidth), i % Board.boardWidth);
				this.addChild(checkboxes[i].image);
				trace("->" + checkboxes[i].image.x + "," + checkboxes[i].image.y + "<-");
			}
			information = new TextField(300,100,"EMPTY","Verdana", 36, 0xDD11DD, true)
			information.x = 250;
			information.y = 250;
			information.visible = false;
			
			score = new TextField(100,50,"0","Verdana", 24, 0x1111DD, true)
			score.x = 600;
			score.y = 15;
			score.visible = false;
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered );
			pauseButton.addEventListener(Event.TRIGGERED, onPauseButtonTriggered );
			this.addChild(startButton);
			this.addChild(pauseButton);
			
		}
		
		private function onPauseButtonTriggered(event : Event) : void {
			if (status=="paused") {
				status = previousStatus;
				timePrevious = getTimer()-_currentMvtGap;
				information.text = "";
				information.visible = false;
			} else {
				previousStatus = status;
				status = "paused";
				_currentMvtGap = getTimer()-timePrevious;
				information.text = "PAUSE";
				information.visible = true;
			}
			trace("Pause clicked - " + status + " - " + _currentMvtGap);
		}
		
		private function onStartButtonTriggered(event : Event) : void {
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
			startButton.visible = false;
			pauseButton.visible = true;
			
			this.players.push(new KnightElement(this, 2, 4));
			this.blob = new BlobElement(this, 0,0);
			this.blob.move(players);
			
			this.addChild(blob.image);
			this.addChild(players[0].image); // TODO Change to dynamic
			
			this.status = "move";
			this.score.visible = true;
			
			this.addChild(information);
			this.addChild(score);
			
			timePrevious = getTimer();
			this.addEventListener(Event.ENTER_FRAME, checkTimeElapsed);
		}
		
		private function checkTimeElapsed(event : Event):void {
			var player : KnightElement;
			switch(status) {
				case "move": {
					trace(getTimer() + " - Move");
					if (getTimer()-timePrevious>Board.speed) {
						for each(player in players) {
							var movements : Array = player.computeRealizableMovements();
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
						for each(player in players) {
							_pathes.push(player.predictMovement(currentMovement));
						}
					}
					trace(getTimer() + " - Moving - Remains " + _pathes[0]);
					for (var i : Number = 0;i<_pathes.length; i++) {
						var point : Point = _pathes[i][0];
						players[i].image.x = point.x;
						players[i].image.y = point.y;
						_pathes[i].shift();
					}
					if (_pathes[_pathes.length-1].length==0) {
						_status = "move";
						for each(player in players) {
							var position : Number = player.getRelativePosition() + currentMovement;
							player.setRelativePosition(position);
							checkboxes[position].elementHit();
							if (checkboxes[position].hit<0) {
								information.text = "GAME OVER";
								information.visible = true;
								_status = "stopped";
								startButton.visible = true;
								pauseButton.visible = false;
								startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
								player.image.visible = false;
								blob.image.visible = true;
							}
							if (player.getRelativePosition()==blob.getRelativePosition()) {
								this.scoreValue += 100;
								previousStatus = status;
								this.status = "cleaning";
								information.text = "Good!";
								information.visible = true;
							}
						}
						timePrevious = getTimer();
					}
				}
				break;
				case "cleaning":
					if (_cleaningStep%4==0) {
						checkboxes[_cleaningStep/4].repair();
					}
					_cleaningStep -= 1;
					if (_cleaningStep<0) {
						status = previousStatus;
						information.visible = false;
						blob.move(players);
						_cleaningStep = 127;
					}
					break;
				case "paused":
				default:
					break;
			}
			for each(var cb : BoardElement in checkboxes) {
				cb.spin();
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

		public function get scoreValue() : Number {
			return _scoreValue;
		}

		public function set scoreValue(value : Number) : void {
			_scoreValue = value;
			score.text = _scoreValue.toString();
		}


	}
}