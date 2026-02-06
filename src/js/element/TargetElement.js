import Element from './Element.js';
import AssetsProvider from '../utils/AssetsProvider.js';

/**
 * Target element showing where knight will move next
 * Converted from ActionScript TargetElement.as
 */
export default class TargetElement extends Element {
    constructor(board, row, column) {
        super(board, row, column, AssetsProvider.getAsTexture('target'));
    }
}
