import * as PIXI from 'pixi.js';
import Board from './Board.js';

/**
 * Main game container
 * Converted from ActionScript Game.as
 */
export default class Game extends PIXI.Container {
    constructor() {
        super();
        this.board = null;
    }

    async initialize(app) {
        console.log('Game is added');
        this.board = new Board();
        this.addChild(this.board);
        await this.board.initialize(app);
    }
}
