import Element from './Element.js';
import AssetsProvider from '../utils/AssetsProvider.js';

/**
 * Blob element that the knight needs to collect
 * Converted from ActionScript BlobElement.as
 */
export default class BlobElement extends Element {
    constructor(board, row, column) {
        super(board, row, column, AssetsProvider.getAsTexture('chessBlob'));
        this.image.height = 52;
    }

    convertRowToPosition(r) {
        const boardHeight = this.board.constructor.boardHeight;
        return ((600 - boardHeight * this.size) / 2) + (r * this.size) + 19;
    }

    move(players) {
        let newPosition = -1;
        const boardWidth = this.board.constructor.boardWidth;
        const boardHeight = this.board.constructor.boardHeight;
        
        while (newPosition === -1) {
            newPosition = Math.floor(Math.random() * boardHeight * boardWidth);
            
            // Check if position conflicts with any player
            for (const p of players) {
                if (p.getRelativePosition() === newPosition) {
                    newPosition = -1;
                    break;
                }
            }
        }
        
        this.setRelativePosition(newPosition);
        this.displayOnBoard();
    }
}
