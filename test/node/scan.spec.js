const path = require( 'path' );
const scan = require( '../lib/scan' );
const utils = require( '../lib/utils' );

const sources = path.join( __dirname, 'sources/scan' );

describe( 'scan', () => {
    it( 'should return the full list of every root', async () => {
        const config = require( path.join( sources, '.cox.config.js' ) );
        const root = config.scope[ 0 ];
        await scan( sources );
        const map = path.join( sources, '.cox/map' );
        const dirs = await utils.scan( sources );
        const list = require( path.join( map, utils.pathToName( root, '.json' ) ) );
        expect( list.sort() ).toEqual( dirs.sort() );
    } );
} );
