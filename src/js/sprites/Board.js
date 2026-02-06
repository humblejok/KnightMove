import * as PIXI from 'pixi.js';
import AssetsProvider from '../utils/AssetsProvider.js';
import BoardElement from '../element/BoardElement.js';
import KnightElement from '../element/KnightElement.js';
import BlobElement from '../element/BlobElement.js';
import TargetElement from '../element/TargetElement.js';

/**
 * Main game board - handles game logic, rendering, and user input
 * Converted from ActionScript Board.as
 */
export default class Board extends PIXI.Container {
    static boardWidth = 8;
    static boardHeight = 4;

    constructor() {
        super();
        
        this.speed = 900;
        this.checkboxes = [];
        this.players = [];
        this.timePrevious = 0;
        this.previousStatus = null;
        this._status = 'moving';
        this.currentMovement = 0;
        this._pathes = [];
        this._currentMvtGap = 0;
        this._scoreValue = 0;
        this._chosenMovement = -1;
        this._cleaningStep = 127;
        
        this.background = null;
        this.startButton = null;
        this.pauseButton = null;
        this.information = null;
        this.score = null;
        this.blob = null;
        this.target = null;
    }

    async initialize(app) {
        this.app = app;
        this.visible = true;
        
        // Create background
        this.background = new PIXI.Sprite(AssetsProvider.getAsTexture('backGround'));
        this.addChild(this.background);
        
        // Create start button
        this.startButton = new PIXI.Sprite(AssetsProvider.getAsTexture('chessKing'));
        this.startButton.x = 144;
        this.startButton.y = 44;
        this.startButton.interactive = true;
        this.startButton.buttonMode = true;
        this.startButton.on('pointerdown', () => this.onStartButtonTriggered());
        this.addChild(this.startButton);
        
        // Create pause button
        this.pauseButton = new PIXI.Sprite(AssetsProvider.getAsTexture('pause'));
        this.pauseButton.x = 700;
        this.pauseButton.y = 20;
        this.pauseButton.width = 40;
        this.pauseButton.height = 40;
        this.pauseButton.visible = false;
        this.pauseButton.interactive = true;
        this.pauseButton.buttonMode = true;
        this.pauseButton.on('pointerdown', () => this.onPauseButtonTriggered());
        this.addChild(this.pauseButton);
        
        // Create board tiles
        this.checkboxes = new Array(Board.boardHeight * Board.boardWidth);
        for (let i = 0; i < Board.boardHeight * Board.boardWidth; i++) {
            this.checkboxes[i] = new BoardElement(
                this,
                Math.floor(i / Board.boardWidth),
                i % Board.boardWidth
            );
            this.addChild(this.checkboxes[i].animatedSprite);
        }
        
        // Create information text
        this.information = new PIXI.Text('EMPTY', {
            fontFamily: 'Arial',
            fontSize: 36,
            fill: 0xDD11DD,
            fontWeight: 'bold'
        });
        this.information.x = 250;
        this.information.y = 250;
        this.information.visible = false;
        this.addChild(this.information);
        
        // Create score text
        this.score = new PIXI.Text('0', {
            fontFamily: 'Arial',
            fontSize: 24,
            fill: 0x1111DD,
            fontWeight: 'bold'
        });
        this.score.x = 600;
        this.score.y = 15;
        this.score.visible = false;
        this.addChild(this.score);
        
        // Set up interactive area for touch/click input
        this.interactive = true;
        this.on('pointerdown', (event) => this.onScreenTouched(event));
        
        // Start game loop
        app.ticker.add(() => this.checkTimeElapsed());
    }

    onPauseButtonTriggered() {
        if (this.status === 'paused') {
            this.status = this.previousStatus;
            this.timePrevious = Date.now() - this._currentMvtGap;
            this.information.text = '';
            this.information.visible = false;
        } else {
            this.previousStatus = this.status;
            this.status = 'paused';
            this._currentMvtGap = Date.now() - this.timePrevious;
            this.information.text = 'PAUSE';
            this.information.visible = true;
        }
        console.log(`Pause clicked - ${this.status} - ${this._currentMvtGap}`);
    }

    onStartButtonTriggered() {
        this.startButton.off('pointerdown');
        this.startButton.visible = false;
        this.pauseButton.visible = true;
        this.speed = 900;
        
        // Create target
        this.target = new TargetElement(this, 0, 3);
        this.target.image.visible = true;
        this.target.image.alpha = 0.5;
        this.target.displayOnBoard();
        
        // Create knight player
        this.players.push(new KnightElement(this, 2, 4));
        
        // Create blob
        this.blob = new BlobElement(this, 0, 0);
        this.blob.move(this.players);
        
        // Add sprites to stage
        this.addChild(this.target.image);
        this.addChild(this.blob.image);
        this.addChild(this.players[0].image);
        
        this.status = 'move';
        this.score.visible = true;
        
        this.timePrevious = Date.now();
        this._chosenMovement = 0;
    }

    onScreenTouched(event) {
        const pos = event.data.global;
        const col = Math.floor((pos.x - 40) / 90);
        const row = Math.floor((pos.y - 120) / 90);
        
        console.log(`INPUT->>> ${col} ---- ${row} <<<-INPUT`);
        
        this.target.row = row;
        this.target.column = col;
        
        for (const player of this.players) {
            const mvt = this.target.getRelativePosition() - player.targetRelativePosition;
            const mvtIndex = player.computeRealizableMovements().indexOf(mvt);
            
            if (mvtIndex !== -1) {
                this.target.displayOnBoard();
                this._chosenMovement = mvtIndex;
            }
        }
    }

    restartGame() {
        this.scoreValue = 0;
        
        for (const cb of this.checkboxes) {
            cb.repair(true);
        }
        
        for (const player of this.players) {
            player.setRelativePosition(20);
            player.displayOnBoard();
            player.image.visible = true;
        }
        
        this.blob.move(this.players);
        this.blob.image.visible = true;
        this.information.text = '';
        this.information.visible = false;
        this.startButton.off('pointerdown');
        this.startButton.visible = false;
        this.pauseButton.visible = true;
        
        this.speed = 900;
        this.timePrevious = Date.now();
        
        this.target.image.visible = true;
        this.target.row = 0;
        this.target.column = 3;
        this.target.displayOnBoard();
        this._chosenMovement = 0;
        
        this.status = 'move';
        
        // Re-bind start button for next restart
        this.startButton.on('pointerdown', () => this.onStartButtonTriggered());
    }

    checkTimeElapsed() {
        switch (this.status) {
            case 'move':
                if (Date.now() - this.timePrevious > this.speed) {
                    for (const player of this.players) {
                        const movements = player.computeRealizableMovements();
                        this.currentMovement = movements[this._chosenMovement];
                        console.log(`Movement - INDEX: ${this._chosenMovement} MVT: ${movements[this._chosenMovement]}`);
                        
                        player.targetRelativePosition = player.getRelativePosition() + this.currentMovement;
                        this._status = 'moving';
                        this._pathes = [];
                        
                        const newMvt = player.computeRealizableMovements();
                        for (let index = 0; index < newMvt.length; index++) {
                            if (this.currentMovement === newMvt[index]) {
                                this._chosenMovement = index;
                                break;
                            } else if (this.currentMovement > newMvt[index]) {
                                if (index > 0) {
                                    this._chosenMovement = index - 1;
                                } else {
                                    this._chosenMovement = 0;
                                }
                                break;
                            }
                        }
                        
                        this.target.setRelativePosition(
                            this.target.getRelativePosition() + newMvt[this._chosenMovement]
                        );
                        this.target.displayOnBoard();
                    }
                }
                break;
                
            case 'moving':
                if (this._pathes.length === 0) {
                    for (const player of this.players) {
                        this._pathes.push(player.predictMovement(this.currentMovement));
                    }
                }
                
                for (let i = 0; i < this._pathes.length; i++) {
                    const point = this._pathes[i][0];
                    this.players[i].image.x = point.x;
                    this.players[i].image.y = point.y;
                    this._pathes[i].shift();
                }
                
                if (this._pathes[this._pathes.length - 1].length === 0) {
                    this._status = 'move';
                    
                    for (const player of this.players) {
                        const position = player.getRelativePosition() + this.currentMovement;
                        player.setRelativePosition(position);
                        this.checkboxes[position].elementHit();
                        
                        if (this.checkboxes[position].hit < 0) {
                            this.information.text = 'GAME OVER';
                            this.information.visible = true;
                            this._status = 'stopped';
                            this.startButton.visible = true;
                            this.pauseButton.visible = false;
                            this.startButton.on('pointerdown', () => this.restartGame());
                            player.image.visible = false;
                            this.blob.image.visible = false;
                            this.target.image.visible = true;
                        }
                        
                        if (player.getRelativePosition() === this.blob.getRelativePosition()) {
                            this.scoreValue += 100;
                            this.previousStatus = this.status;
                            this.status = 'cleaning';
                            this.information.text = 'Good!';
                            this.information.visible = true;
                        }
                    }
                    
                    this.timePrevious = Date.now();
                }
                break;
                
            case 'cleaning':
                if (this._cleaningStep % 4 === 0) {
                    this.checkboxes[this._cleaningStep / 4].repair();
                }
                this._cleaningStep -= 1;
                
                if (this._cleaningStep < 0) {
                    this.status = this.previousStatus;
                    this.information.visible = false;
                    this.blob.move(this.players);
                    this._cleaningStep = 127;
                    this.speed -= 50;
                }
                break;
                
            case 'paused':
            default:
                break;
        }
    }

    get status() {
        return this._status;
    }

    set status(value) {
        this._status = value;
    }

    get scoreValue() {
        return this._scoreValue;
    }

    set scoreValue(value) {
        this._scoreValue = value;
        this.score.text = this._scoreValue.toString();
    }
}
