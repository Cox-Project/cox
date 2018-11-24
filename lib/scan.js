const fs = require( 'fs' );
const path = require( 'path' );
const Events = require( 'events' );
const minimatch = require( 'minimatch' );
const is = require( '@lvchengbin/is' );
const utils = require( './utils' );

/**
 * scan directories
 *
 * @param {string} name - name of directory.
 * @param {Object} [options] - options for scanning directories
 * @param {Object} [config]
 */
async function scan( name, options, config ) {

    options || ( options = {} );
    config || ( config = options.config );

    const c = utils.loasConfig( dir );
    c && ( config = c );

    fs.readdir( name, ( err, files ) {
        if( err ) return;

        for( const file of files ) {
            const name = path.join( dir, file ); 

            fs.stat( name, ( e, stats ) => {
                if( e ) return;

                if( this.exclude( name ) ) {
                }
            } );
        }
    } );
}

module.exports = scan;
