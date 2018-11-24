const fs = require( 'fs' );
const path = require( 'path' );
const util = require( 'util' );
const minimatch = require( 'minimatch' );

function stat( name ) {
    return util.promisify( fs.stat )( name );
}

async function isFile( name ) {
    try {
        const s = await stat( name );
        return s.isFile();
    } catch( e ) {
        return false;
    }
}

async function isDirectory( name ) {
    try {
        const s = await stat( name );
        return s.isDirectory();
    } catch( e ) {
        return false;
    }
}

async function loadConfig( dir ) {
    const name = path.join( dir, '.cox.json' );
    const f = await isFile( name );
    if( !f ) return null;
    return require( name );
}

/**
 * to check if a path or a name of directory matches the exclusion minimatch pattern.
 * to use (!) pattern can set expective rules.
 *
 * minimatch: https://github.com/isaacs/minimatch
 * 
 * @param {string} name - the directory name or the full path
 * @param {string} pattern - minimatch pattern.
 *
 * @return {boolean}
 */
function excludes( name, pattern ) {
    let matched = false;
    for( let item of pattern ) {
        let neg = false;
        if( item.charAt( 0 ) === '~' ) {
            neg = true;
            item = item.substr( 1 );
        }
        minimatch( name, item ) && ( matched = !neg );
    }
    return matched;
}

module.exports = { stat, isFile, isDirectory, loadConfig, excludes };
