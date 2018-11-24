const fs = require( 'fs' );
const path = require( 'path' );
const utils = require( '../lib/utils' );

const file = path.join( __dirname, 'utils.spec.js' );
const nonfile = path.join( __dirname, +new Date + '' );

function fname( ...args ) {
    return path.join( __dirname, ...args );
}

describe( 'utils.stat', () => {
    it( 'should return a Promise object', () => {
        return expect( utils.stat( file ) ).resolves.toBeInstanceOf( fs.Stats );
    } );    

    it( 'should return a rejected Promise object while trying to attach a nonexistent file', () => {
        return expect( utils.stat( nonfile ) ).rejects.toThrow(); 
    } );
} );

describe( 'utils.isFile', () => {
    it( 'should return ture with a file', () => {
        return expect( utils.isFile( file ) ).resolves.toBe( true );     
    } ); 

    it( 'should return false with a dir', () => {
        return expect( utils.isFile( __dirname ) ).resolves.toBe( false );
    } );

    it( 'should return false with a nonexitent path', () => {
        return expect( utils.isFile( nonfile ) ).resolves.toBe( false );
    } );
} );

describe( 'utils.isDirectory', () => {
    it( 'should return true with a directory', () => {
        return expect( utils.isDirectory( __dirname ) ).resolves.toBe( true ); 
    } );

    it( 'should return false with a file', () => {
        return expect( utils.isDirectory( file ) ).resolves.toBe( false );
    } );

    it( 'should return false with a nonexistent path', () => {
        return expect( utils.isDirectory( nonfile ) ).resolves.toBe( false );
    } );
    
} );

describe( 'utils.loadConfig', () => {
    it( 'should return null', () => {
        return expect( utils.loadConfig( __dirname ) ).resolves.toBe( null );
    } );  

    it( 'should return null with a nonexistent directory', () => {
        return expect( utils.loadConfig( nonfile ) ).resolves.toBe( null ); 
    } );

    it( 'should return the config object in .cox.json', () => {
        return expect( utils.loadConfig( fname( 'sources', 'utils' ) ) ).resolves.toEqual( {
            exclude : []
        } );
    } );
} );

describe( 'utils.execludes', () => {
    const m = utils.excludes;

    it( 'should match minimatch patterns', () => {

        expect( m( '/home/www/node_modules', [
            'node_modules'
        ] ) ).toBe( false );

        expect( m( '/home/www/node_modules', [
            '**/www/**'
        ] ) ).toBe( true );

        expect( m( '/home/www/node_modules', [
            '**/node_modules'
        ] ) ).toBe( true ); 

        expect( m( '/home/www/node_modules', [
            '*ode_modules'
        ] ) ).toBe( false ); 
    } );

    it( 'should support the ! operator', () => {
        const patterns = [ '**/.*', '~**/.cox.json' ];
        expect( m( '/home/www/.cox', patterns ) ).toBe( true );
        expect( m( '/home/www/.cox.json', patterns ) ).toBe( false );
    } );
} );
