const path = require( 'path' );
const fs = require( 'fs-extra' );
const is = require( '@lvchengbin/is' );
const utils = require( './utils' );

module.exports = async home => {
    const c = await utils.loadConfig( home, '.cox.config' );
    if( !c ) throw new Error( 'Cannot find config file in ' + home );

    const scope = is.array( c.scope ) ? c.scope : [ c.scope ];

    for( const item of scope ) {
        const dir = path.join( home, '.cox/map' );
        await fs.mkdirp( dir );         
        const list = await utils.scan( item );
        utils.write( path.join( dir, utils.pathToName( item, '.json' ) ), JSON.stringify( list, null, '    ' ) );
    }
}
