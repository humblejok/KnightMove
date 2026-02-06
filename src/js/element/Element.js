import * as PIXI from 'pixi.js';

/**
 * Base class for game elements (Knight, Blob, Target)
 * Converted from ActionScript Element.as
 */
export default class Element {
    constructor(board, row, column, texture = null, resize = true) {
        this.size = 90;
        this._column = column;
        this._row = row;
        this._board = board;
        
        // Create sprite
        if (texture) {
            this.image = new PIXI.Sprite(texture);
            this.image.alpha = 1.0;
            
            if (resize) {
                this.image.width = this.size;
                this.image.height = this.size;
            }
        }
        
        this.displayOnBoard();
    }

    convertRowToPosition(r) {
        const boardHeight = this._board.constructor.boardHeight;
        return ((600 - boardHeight * this.size) / 2) + (r * this.size);
    }

    convertColumnToPosition(c) {
        const boardWidth = this._board.constructor.boardWidth;
        return ((800 - boardWidth * this.size) / 2) + (c * this.size);
    }

    displayOnBoard() {
        if (this.image) {
            this.image.x = this.convertColumnToPosition(this._column);
            this.image.y = this.convertRowToPosition(this._row);
        }
    }

    getRelativePosition() {
        const boardWidth = this._board.constructor.boardWidth;
        return (boardWidth * this._row) + this._column;
    }

    setRelativePosition(p) {
        const boardWidth = this._board.constructor.boardWidth;
        this._column = p % boardWidth;
        this._row = Math.floor(p / boardWidth);
    }

    get column() {
        return this._column;
    }

    set column(value) {
        this._column = value;
    }

    get row() {
        return this._row;
    }

    set row(value) {
        this._row = value;
    }

    get board() {
        return this._board;
    }

    set board(value) {
        this._board = value;
    }
}
