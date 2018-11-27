const fs = require( 'fs' );
const path = require( 'path' );
const util = require( 'util' );
const minimatch = require( 'minimatch' );
const is = require( '@lvchengbin/is' );

/**
 * Promisifying File methods.
 */
const stat = util.promisify( fs.stat );
const readdir = util.promisify( fs.readdir );
const write = util.promisify( fs.writeFile );

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

/**
 * to load .cox.json file from a directory. returns null if .cox.json doesn't exist or failed to load.
 *
 * @param {string} dir
 *
 * @return {Object|NULL}
 */
async function loadConfig( dir, file ) {
    const js = path.join( dir, ( file || '.cox' ) + '.js' );
    const json = path.join( dir, ( file || '.cox' ) + '.json' );

    if( await isFile( js ) ) return require( js );
    if( await isFile( json ) ) return require( json );
    return null;
}

//async function findConfig( dir ) {
//}

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
function excludes( name, patterns ) {
    is.array( patterns ) || ( patterns = [ patterns ] );
    let matched = false;
    for( let item of patterns ) {
        let neg = false;
        if( item.charAt( 0 ) === '~' ) {
            neg = true;
            item = item.substr( 1 );
        }
        minimatch( name, item ) && ( matched = !neg );
    }
    return matched;
}

/**
 * to get sub directories of a given dir.
 *
 * @param {string} dir - the path(name) or the given directory.
 * @param {Object} [options={}] - options.
 * @param {boolean} [options.fullPath=false] - to use the full path of sub directories in the result.
 * @param {string} [options.base] - to set the base dir which will be used for matching exclusive patterns.
 * @param {Array} [options.exclude] - the exclusive patterns.
 */
async function subdirs( dir, options = {} ) {
    const res = [];

    const files = await readdir( dir );

    for( const file of files ) {
        const fullPath = path.join( dir, file );
        if( !await isDirectory( fullPath ) ) continue;
        const p = options.base ? path.relative( options.base, fullPath ) : fullPath;
        if( !options.exclude || !excludes( p, options.exclude ) ) {
            res.push( options.fullPath ? fullPath : file );
        }
    }
    return res;
}

async function scan( name, options = {}, callback, arr ) {
    if( is.array( options ) ) {
        arr = options;
        callback = null;
        options = {};
    } else if( is.function( options ) ) {
        arr = callback;
        callback = options;
        options = {};
    } else if( is.array( callback ) ) {
        arr = callback;
        callback = null;
    }

    const res = arr || [];

    const c = await loadConfig( name );
    const base = c ? c.base || name : options.base;
    const exclude = c && c.exclude ? c.exclude : options.exclude;
    const dirs = await subdirs( name, { base, exclude, fullPath : true } );

    for( const dir of dirs ) {
        is.function( callback ) && callback( dir );
        res.push( dir );
        await scan( dir, { base, exclude }, callback, res );
    }

    return res;
}

function pathToName( p, ext ) {
    return p.replace( /[/\\]/g, '_' ) + ext;
}

module.exports = { stat, isFile, write, isDirectory, loadConfig, excludes, subdirs, scan, pathToName };
