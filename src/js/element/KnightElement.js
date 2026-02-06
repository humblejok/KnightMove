import Element from './Element.js';
import AssetsProvider from '../utils/AssetsProvider.js';

/**
 * Knight game piece - moves in L-shapes like a chess knight
 * Converted from ActionScript KnightElement.as
 */
export default class KnightElement extends Element {
    static movements = [-17, -15, -10, -6, 6, 10, 15, 17];
    static movements_ordered = [-17, -15, -6, 10, 17, 15, 6, -10];
    static limit = 0; // Will be set based on board size

    constructor(board, row, column) {
        super(board, row, column, AssetsProvider.getAsTexture('chessKnight'));
        this._targetRelativePosition = this.getRelativePosition();
        
        // Set static limit if not already set
        if (KnightElement.limit === 0) {
            KnightElement.limit = board.constructor.boardWidth * board.constructor.boardHeight;
        }
    }

    predictMovement(movement) {
        const results = [];
        
        const relativePosition = this.getRelativePosition() + movement;
        const boardWidth = this.board.constructor.boardWidth;
        const newColumn = relativePosition % boardWidth;
        const newRow = Math.floor(relativePosition / boardWidth);
        
        console.log(`NEW POSITION: ${relativePosition} - X=${newColumn} - Y=${newRow}`);
        
        const targetX = this.convertColumnToPosition(newColumn) - this.image.x;
        const targetY = this.convertRowToPosition(newRow) - this.image.y;
        
        console.log(`STARTING: ${this.image.x}/${this.image.y} - TARGET: ${targetX} - ${targetY}`);
        
        const fpsSpeed = Math.floor(60 * (this.board.speed / 1000));
        const stepX = targetX / fpsSpeed;
        const stepY = targetY / fpsSpeed;
        
        const startX = this.image.x;
        const startY = this.image.y;
        
        for (let i = 1; i < fpsSpeed; i++) {
            results.push({
                x: Math.round(startX + stepX * i),
                y: Math.round(startY + stepY * i)
            });
        }
        
        results.push({
            x: this.convertColumnToPosition(newColumn),
            y: this.convertRowToPosition(newRow)
        });
        
        return results;
    }

    computeRealizableMovements() {
        const results = [];
        const boardWidth = this.board.constructor.boardWidth;
        
        for (const m of KnightElement.movements) {
            const result = this._targetRelativePosition + m;
            const moduloSource = this._targetRelativePosition % boardWidth;
            const moduloTarget = result % boardWidth;
            const offset = Math.abs(moduloTarget - moduloSource);
            
            if (result >= 0 && result < KnightElement.limit && offset <= 2) {
                results.push(m);
            }
        }
        
        return results;
    }

    setRelativePosition(p) {
        super.setRelativePosition(p);
        this._targetRelativePosition = p;
    }

    get targetRelativePosition() {
        return this._targetRelativePosition;
    }

    set targetRelativePosition(value) {
        this._targetRelativePosition = value;
    }
}
