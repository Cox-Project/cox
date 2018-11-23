const fs = require( 'fs' );
const path = require( 'path' );
const util = require( 'util' );
const minimatch = require( 'minimatch' );

function stat( name ) {
    return util.promisify( fs.stat )( name );
}

async function isFile( name ) {
    const stat = await stat( name );
    return stat.isFile();
}

async function isDirectory( name ) {
    const stat = await stat( name );
    return stat.isDirectory();
}

async function loadConfig( dir ) {
    const name = path.join( dir, '.cox.json' );
    const isFile = await isFile( name );
    if( !isFile ) return null;
    return require( name );
}

/**
 * to check if a path or a name of directory matches the exclusion pattern.
 * this method will check the basename of the path(directory) first, and then the full path.
 * to use (!) pattern can set expective rules.
 *
 * minimatch: https://github.com/isaacs/minimatch
 * 
 * @param {string} name - the directory name or the full path
 * @param {string} pattern - directory name, apart of path or a pattern string of minimatch
 *
 */
async function excludes( name, pattern ) {
    let matched = false;
    for( const item of pattern ) {
        /**
         * to check if the basename of the path matches the pattern
         * so that specified directory name can be matched.
         */
        if( minimatch( path.basename( name ), item ) || minimatch( name, item ) ) {
            /**
             * if the pattern matches the path and the pattern starts with "!" set matched to false, otherwise set matched to true;
             */
            matched = !( matched && item.charAt( 0 ) === '!' );
            continue;
        }

        const i = name.indexOf( item );

        // not including the pattern
        if( i < 0 ) continue;

        // including the pattern but the matching part is not full directory names
        // eg. /abc/def -> c/d
        const prec = name.charAt( i - 1 );
        if( prec && prec !== path.sep ) continue;

        const nextc = name.charAt( i + item.length );
        if( nextc && nextc !== path.sep ) continue;
        matched = true;
    }
    return matched;
}

module.exports = { stat, isFile, isDirectory, loadConfig, excludes };
