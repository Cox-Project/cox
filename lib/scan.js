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

    const c = utils.loasConfig( name );
    c && ( config = c );

    const subdirs = utils.subdirs( name, config.excludes );

    for( const dir of subdirs ) {
        scan( dir, options, config ); 
    }

}

module.exports = scan;
