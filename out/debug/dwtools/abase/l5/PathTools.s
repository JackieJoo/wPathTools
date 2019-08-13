( function _PathTools_s_() {

'use strict';

/**
 * Collection of routines to operate paths reliably and consistently. Implements routines for manipulating paths maps and globing. Extends module PathBasic.
  @module Tools/base/Path
*/

/**
 * @file Path.s.
 */

/**
 * @summary Collection of routines to operate paths reliably and consistently.
 * @namespace "wTools.path"
 * @memberof module:Tools/PathTools
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );
  _.include( 'wPathFundamentals' );
  _.include( 'wStringsExtra' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Self = _.path = _.path || Object.create( null );

// --
// path map
// --

function filterPairs( filePath, onEach )
{
  let result = Object.create( null );
  let hasDst = false;
  let hasSrc = false;
  let it = Object.create( null );
  it.src = '';
  it.dst = '';

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || filePath === '' )
  {
    let r = onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.strIs( filePath ) )
  {
    it.src = filePath;
    let r = onEach( it );
    elementsWrite( result, it, r );
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.src = filePath[ p ];
      if( filePath[ p ] === null )
      it.src = '';
      let r = onEach( it );
      elementsWrite( result, it, r );
    }
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];
      if( _.arrayIs( dst ) )
      {
        if( !dst.length )
        {
          it.src = src;
          it.dst = '';
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
        else
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          if( it.dst === null )
          it.dst = '';
          let r = onEach( it );
          elementsWrite( result, it, r );
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( it.dst === null )
        it.dst = '';
        let r = onEach( it );
        elementsWrite( result, it, r );
      }
    }
  }
  else _.assert( 0 );

  return end();

  /* */

  function elementsWrite( result, it, elements )
  {

    if( _.arrayIs( elements ) )
    {
      elements.forEach( ( r ) => elementsWrite( result, it, r ) );
      return result;
    }

    _.assert( elements === undefined || elements === null || _.strIs( elements ) || _.arrayIs( elements ) || _.mapIs( elements ) );

    if( elements === undefined )
    return result;

    if( elements === null || elements === '' )
    return elementWrite( result, '', '' );

    if( _.strIs( elements ) )
    return elementWrite( result, elements, it.dst );

    if( _.arrayIs( elements ) )
    {
      elements.forEach( ( src ) => elementWrite( result, src, it.dst ) );
      return result;
    }

    if( _.mapIs( elements ) )
    {
      for( let src in elements )
      {
        let dst = elements[ src ];
        elementWrite( result, src, dst );
      }
      return result;
    }

    _.assert( 0 );
  }

  /* */

  function elementWrite( result, src, dst )
  {
    if( _.arrayIs( dst ) )
    {
      if( dst.length )
      dst.forEach( ( dst ) => elementWriteSingle( result, src, dst ) );
      else
      elementWriteSingle( result, src, '' );
      return result;
    }
    elementWriteSingle( result, src, dst );
    return result;
  }

  /* */

  function elementWriteSingle( result, src, dst )
  {
    if( dst === null )
    dst = '';
    if( src === null )
    src = '';

    _.assert( _.strIs( src ) );
    _.assert( _.strIs( dst ) || _.boolLike( dst ) );

    result[ src ] = _.scalarAppend( result[ src ], dst );

    if( src )
    hasSrc = true;

    if( dst !== '' )
    hasDst = true;

    return result;
  }

  /* */

  function end()
  {
    let r;

    if( !hasSrc )
    {
      if( !hasDst )
      return '';
      return result;
    }
    else if( !hasDst )
    {
      r = _.mapKeys( result );
    }
    else
    return result;

    if( _.arrayIs( r ) )
    {
      if( r.length === 1 )
      r = r[ 0 ]
      else if( r.length === 0 )
      r = '';
    }

    _.assert( _.strIs( r ) || _.arrayIs( r ) )
    return r;
  }

}

//

// function filterPairsInplace( filePath, onEach )
// {
//
//   _.assert( arguments.length === 2 );
//   _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
//   _.routineIs( onEach );
//
//   let hasSrc = false;
//   let hasDst = false;
//   let it = Object.create( null );
//   it.src = '';
//   it.dst = '';
//
//   if( filePath === null || filePath === '' )
//   {
//     let r = onEach( it );
//     if( r === undefined )
//     return filePath;
//     return r;
//   }
//   if( _.strIs( filePath ) )
//   {
//     it.src = filePath;
//     let r = onEach( it );
//     if( r === undefined )
//     return filePath;
//     if( _.primitiveIs(r) )
//     return r;
//     else
//     {
//       filePath = r;
//       elementsWrite( filePath, it, r );
//     }
//   }
//   else if( _.arrayIs( filePath ) )
//   {
//     for( let p = 0 ; p < filePath.length ; p++ )
//     {
//       it.src = filePath[ p ];
//       let r = onEach( it );
//       elementsWrite( filePath, it, r );
//     }
//   }
//   else if( _.mapIs( filePath ) )
//   {
//     for( let src in filePath )
//     {
//       let dst = filePath[ src ];
//
//       delete filePath[ src ];
//
//       if( _.arrayIs( dst ) )
//       {
//         if( !dst.length )
//         {
//           it.src = src;
//           it.dst = '';
//           let r = onEach( it );
//           elementsWrite( filePath, it, r );
//         }
//         else
//         for( let d = 0 ; d < dst.length ; d++ )
//         {
//           it.src = src;
//           it.dst = dst[ d ];
//           let r = onEach( it );
//           elementsWrite( filePath, it, r );
//         }
//       }
//       else
//       {
//         it.src = src;
//         it.dst = dst;
//         let r = onEach( it );
//         elementsWrite( filePath, it, r );
//       }
//
//     }
//   }
//   else _.assert( 0 );
//
//   return end();
//
//   /* */
//
//   function elementsWrite( filePath, it, elements )
//   {
//
//     if( _.arrayIs( elements ) )
//     {
//       elements.forEach( ( r ) => elementsWrite( filePath, it, r ) );
//       return filePath;
//     }
//
//     _.assert( elements === undefined || elements === null || _.strIs( elements ) || _.arrayIs( elements ) || _.mapIs( elements ) );
//
//     if( elements === undefined )
//     return filePath;
//
//     if( elements === null || elements === '' )
//     return elementWrite( filePath, '', '' );
//
//     if( _.strIs( elements ) )
//     return elementWrite( filePath, elements, it.dst );
//
//     if( _.arrayIs( elements ) )
//     {
//       elements.forEach( ( src ) => elementWrite( filePath, src, it.dst ) );
//       return result;
//     }
//
//     if( _.mapIs( elements ) )
//     {
//       for( let src in elements )
//       {
//         let dst = elements[ src ];
//         elementWrite( filePath, src, dst );
//       }
//       return filePath;
//     }
//
//     _.assert( 0 );
//   }
//
//   /* */
//
//   function elementWrite( filePath, src, dst )
//   {
//     if( _.arrayIs( dst ) )
//     {
//       if( dst.length )
//       dst.forEach( ( dst ) => elementWriteSingle( filePath, src, dst ) );
//       else
//       elementWriteSingle( filePath, src, '' );
//       return filePath;
//     }
//     elementWriteSingle( filePath, src, dst );
//     return filePath;
//   }
//
//   /* */
//
//   function elementWriteSingle( filePath, src, dst )
//   {
//     if( dst === null )
//     dst = '';
//     if( src === null )
//     src = '';
//
//     _.assert( _.strIs( src ) );
//     _.assert( _.strIs( dst ) || _.boolLike( dst ) );
//
//     filePath[ src ] = _.scalarAppend( filePath[ src ], dst );
//
//     if( src )
//     hasSrc = true;
//
//     if( dst !== '' )
//     hasDst = true;
//
//     return filePath;
//   }
//
//   function end()
//   {
//     let r;
//
//     if( !hasSrc )
//     {
//       if( !hasDst )
//       return filePath;
//       return filePath;
//     }
//     else if( !hasDst )
//     {
//       r = _.mapKeys( filePath );
//     }
//     else
//     return filePath;
//
//     if( _.arrayIs( r ) )
//     {
//       if( r.length === 1 )
//       r = r[ 0 ]
//       else if( r.length === 0 )
//       r = filePath;
//     }
//
//     _.assert( _.strIs( r ) || _.arrayIs( r ) )
//     return r;
//   }
//
// }

//

function filterInplace( filePath, onEach )
{
  let self = this;
  let it = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || _.strIs( filePath ) )
  {
    if( filePath === null )
    filePath = '';
    it.value = filePath;
    let r = onEach( it.value, it );
    if( r === undefined )
    return '';
    return self.simplify( r );
  }
  else if( _.arrayIs( filePath ) )
  {
    let filePath2 = filePath.slice();
    filePath.splice( 0, filePath.length );
    for( let p = 0 ; p < filePath2.length ; p++ )
    {
      it.index = p;
      it.value = filePath2[ p ];
      if( filePath2[ p ] === null )
      it.value = '';
      let r = onEach( it.value, it );
      if( r === undefined )
      {
      }
      else
      {
        _.arrayAppendArraysOnce( filePath, r )
      }
    }
    return self.simplifyInplace( filePath );
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      delete filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = onEach( it.value, it );
          it.side = 'dst';
          it.value = it.dst;
          let dstResult = onEach( it.value, it );
          write( filePath, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ];
            if( dst[ d ] === null )
            it.dst = '';
            it.value = it.src;
            it.side = 'src';
            let srcResult = onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = onEach( it.value, it );
            write( filePath, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( dst === null )
        it.dst = '';
        it.value = it.src;
        it.side = 'src';
        let srcResult = onEach( it.value, it );
        it.side = 'dst';
        it.value = it.dst;
        let dstResult = onEach( it.value, it );
        write( filePath, srcResult, dstResult );
      }

    }

    return self.simplifyInplace( filePath );
  }
  else _.assert( 0 );

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';
    if( _.arrayIs( dst ) && dst.length === 1 )
    dst = dst[ 0 ];

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
      }
      else if( src !== undefined )
      {
        pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
      }
    }

  }

}

//

/*
  Dmytro : added codition if( dst.lengt === 0 ) in map
*/

function filter( filePath, onEach )
{
  let self = this;
  let it = Object.create( null );

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    if( filePath === null )
    it.value = '';
    let r = onEach( it.value, it );
    if( r === undefined )
    return null;
    return self.simplify( r );
  }
  else if( _.arrayIs( filePath ) )
  {
    let result = [];
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      if( filePath[ p ] === null )
      it.value = '';
      let r = onEach( it.value, it );
      if( r !== undefined )
      _.arrayAppendArraysOnce( result, r );
    }
    return self.simplify( result );
  }
  else if( _.mapIs( filePath ) )
  {
    let result = Object.create( null );
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        if( dst.length === 0 )
        {
          it.src = src;
          it.dst = '';
          it.value = it.src;
          it.side = 'src';
          let srcResult = onEach( it.value, it );
          it.value = it.dst;
          it.side = 'dst';
          let dstResult = onEach( it.value, it );
          write( result, srcResult, dstResult );
        }
        else
        {
          for( let d = 0 ; d < dst.length ; d++ )
          {
            it.src = src;
            it.dst = dst[ d ];
            if( dst[ d ] === null )
            it.dst = '';
            it.value = it.src;
            it.side = 'src';
            let srcResult = onEach( it.value, it );
            it.value = it.dst;
            it.side = 'dst';
            let dstResult = onEach( it.value, it );
            write( result, srcResult, dstResult );
          }
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        if( dst === null )
        it.dst = '';
        it.value = it.src;
        it.side = 'src';
        let srcResult = onEach( it.value, it );
        it.value = it.dst;
        it.side = 'dst';
        let dstResult = onEach( it.value, it );
        write( result, srcResult, dstResult );
      }

    }

    return self.simplify( result );
  }
  else _.assert( 0 );

  /* */

  function write( pathMap, src, dst )
  {
    if( src === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    src = '';
    if( dst === null || ( _.arrayIs( dst ) && dst.length === 0 ) )
    dst = '';

    _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );

    if( dst !== undefined )
    {
      if( _.arrayIs( src ) )
      {
        for( let s = 0 ; s < src.length ; s++ )
        if( src[ s ] !== undefined )
        pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
      }
      else if( src !== undefined )
      {
        pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
      }
    }

  }

}

// function filter( filePath, onEach )
// {
//   let self = this;
//   let it = Object.create( null );
//
//   _.assert( arguments.length === 2 );
//   _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
//   _.routineIs( onEach );
//
//   if( filePath === null || _.strIs( filePath ) )
//   {
//     it.value = filePath;
//     let r = onEach( it.value, it );
//     if( r === undefined )
//     return null;
//     return self.simplify( r );
//   }
//   else if( _.arrayIs( filePath ) )
//   {
//     let result = [];
//     for( let p = 0 ; p < filePath.length ; p++ )
//     {
//       it.index = p;
//       it.value = filePath[ p ];
//       let r = onEach( it.value, it );
//       if( r !== undefined )
//       result.push( r );
//     }
//     return self.simplify( result );
//   }
//   else if( _.mapIs( filePath ) )
//   {
//     let result = Object.create( null );
//     for( let src in filePath )
//     {
//       let dst = filePath[ src ];
//
//       if( _.arrayIs( dst ) )
//       {
//         dst = dst.slice();
//         for( let d = 0 ; d < dst.length ; d++ )
//         {
//           it.src = src;
//           it.dst = dst[ d ];
//           it.value = it.src;
//           it.side = 'src';
//           let srcResult = onEach( it.value, it );
//           it.value = it.dst;
//           it.side = 'dst';
//           let dstResult = onEach( it.value, it );
//           write( result, srcResult, dstResult );
//         }
//       }
//       else
//       {
//         it.src = src;
//         it.dst = dst;
//         it.value = it.src;
//         it.side = 'src';
//         let srcResult = onEach( it.value, it );
//         it.value = it.dst;
//         it.side = 'dst';
//         let dstResult = onEach( it.value, it );
//         write( result, srcResult, dstResult );
//       }
//
//     }
//
//     return self.simplify( result );
//   }
//   else _.assert( 0 );
//
//   /* */
//
//   function write( pathMap, src, dst )
//   {
//
//     _.assert( src === undefined || _.strIs( src ) || _.arrayIs( src ) );
//
//     if( dst !== undefined )
//     {
//       if( _.arrayIs( src ) )
//       {
//         for( let s = 0 ; s < src.length ; s++ )
//         if( src[ s ] !== undefined )
//         pathMap[ src[ s ] ] = _.scalarAppend( pathMap[ src[ s ] ], dst );
//       }
//       else if( src !== undefined )
//       {
//         pathMap[ src ] = _.scalarAppend( pathMap[ src ], dst );
//       }
//     }
//
//   }
//
// }

//

function all( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( !r )
    return false;
    return true;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( !r )
      return false;
    }
    return true;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          var r = onEach( it.value, it );
          if( !r )
          return false;
          it.value = it.dst;
          it.side = 'dst';
          var r = onEach( it.value, it );
          if( !r )
          return false;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        var r = onEach( it.value, it );
        if( !r )
        return false;
        it.value = it.dst;
        it.side = 'dst';
        var r = onEach( it.value, it );
        if( !r )
        return false;
      }

    }
    return true;
  }
  else _.assert( 0 );

}

//

function any( filePath, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( filePath === null || _.strIs( filePath ) || _.arrayIs( filePath ) || _.mapIs( filePath ) );
  _.routineIs( onEach );

  let it = Object.create( null );

  if( filePath === null || _.strIs( filePath ) )
  {
    it.value = filePath;
    let r = onEach( it.value, it );
    if( r )
    return true;
    return false;
  }
  else if( _.arrayIs( filePath ) )
  {
    for( let p = 0 ; p < filePath.length ; p++ )
    {
      it.index = p;
      it.value = filePath[ p ];
      let r = onEach( it.value, it );
      if( r )
      return true;
    }
    return false;
  }
  else if( _.mapIs( filePath ) )
  {
    for( let src in filePath )
    {
      let dst = filePath[ src ];

      if( _.arrayIs( dst ) )
      {
        dst = dst.slice();
        for( let d = 0 ; d < dst.length ; d++ )
        {
          it.src = src;
          it.dst = dst[ d ];
          it.value = it.src;
          it.side = 'src';
          var r = onEach( it.value, it );
          if( r )
          return true;
          it.value = it.dst;
          it.side = 'dst';
          var r = onEach( it.value, it );
          if( r )
          return true;
        }
      }
      else
      {
        it.src = src;
        it.dst = dst;
        it.value = it.src;
        it.side = 'src';
        var r = onEach( it.value, it );
        if( r )
        return true;
        it.value = it.dst;
        it.side = 'dst';
        var r = onEach( it.value, it );
        if( r )
        return true;
      }

    }
    return false;
  }
  else _.assert( 0 );

}

//

function none( filePath, onEach )
{
  return !this.any.apply( this, arguments )
}

//

/*
qqq : implement good tests for routine isEmpty
*/

function isEmpty( src )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( src === null || _.arrayIs( src ) || _.strIs( src ) || _.mapIs( src ) );

  if( src === null || src === '' )
  return true;

  if( _.strIs( src ) )
  return false;

  if( _.arrayIs( src ) )
  {
    if( src.length === 0 )
    return true;
    if( src.length === 1 )
    if( src[ 0 ] === null || src[ 0 ] === '' || src[ 0 ] === '.' ) // qqq zzz : refactor to remove dot case
    return true;
    return false;
  }

  if( _.mapKeys( src ).length === 1 )
  if( src[ '.' ] === null || src[ '.' ] === '' || src[ '' ] === null || src[ '' ] === '' ) // qqq zzz : refactor to remove dot
  return true;

  return false;
}

//

/*
qqq : add support of hashes for mapExtend, extend tests
*/

function _mapExtend( o )
{
  let self = this;
  let used = false;

  _.routineOptions( _mapExtend, arguments );
  _.assert( o.dstPathMap === null || _.strIs( o.dstPathMap ) || _.arrayIs( o.dstPathMap ) || _.mapIs( o.dstPathMap ) );
  _.assert( !_.mapIs( o.dstPath ) );
  _.assert( _.arrayHas( [ 'replace', 'append', 'prepend' ], o.mode ) );

  let removing = o.srcPathMap === '' || o.srcPathMap === null;
  removing = false; /* off the feature */

  o.dstPath = dstPathNormalize( o.dstPath );
  o.srcPathMap = srcPathMapNormalize( o.srcPathMap );

  if( o.supplementing )
  {
    getDstPathFromSrcMap();
    getDstPathFromDstMap();
  }
  else
  {
    getDstPathFromDstMap();
    getDstPathFromSrcMap();
  }

  [ o.dstPathMap, used ] = dstPathMapNormalize( o.dstPathMap );

  if( removing )
  dstPathMapRemove( o.dstPathMap, o.dstPath );
  else
  used = dstPathMapExtend( o.dstPathMap, o.srcPathMap, o.dstPath ) || used;

  if( used && o.dstPathMap[ '' ] === o.dstPath )
  {
    delete o.dstPathMap[ '' ];
  }

  /* */

  return o.dstPathMap;

  /* */

  function dstPathNormalize( dstPath )
  {
    dstPath = self.simplify( dstPath );
    return dstPath;
  }

  /* */

  function srcPathMapNormalize( srcPathMap )
  {
    srcPathMap = self.simplify( srcPathMap );
    return srcPathMap;
  }

  /* */

  function getDstPathFromDstMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.dstPathMap ) )
    if( o.dstPathMap[ '' ] !== undefined && o.dstPathMap[ '' ] !== null && o.dstPathMap[ '' ] !== '' )
    if( o.srcPathMap !== '' )
    if( o.dstPath !== o.dstPathMap[ '' ] )
    {
      o.dstPath = o.dstPathMap[ '' ];
      used = false;
    }

  }

  /* */

  function getDstPathFromSrcMap()
  {

    if( o.dstPath === null || o.dstPath === '' )
    if( _.mapIs( o.srcPathMap ) )
    if( o.srcPathMap[ '' ] !== undefined && o.srcPathMap[ '' ] !== null && o.srcPathMap[ '' ] !== '' )
    if( o.dstPath !== o.srcPathMap[ '' ] )
    {
      o.dstPath = o.srcPathMap[ '' ];
      used = false;
    }

  }

  /* */

  function dstPathMapNormalize( dstPathMap )
  {
    let used = false;

    if( dstPathMap === null )
    {
      dstPathMap = Object.create( null );
    }
    else if( _.strIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      if( originalDstPath !== '' || ( o.dstPath !== null && o.dstPath !== '' ) )
      {
        dstPathMap[ originalDstPath ] = o.dstPath;
        if( originalDstPath !== '' )
        used = true;
      }
    }
    else if( _.arrayIs( dstPathMap ) )
    {
      let originalDstPath = dstPathMap;
      dstPathMap = Object.create( null );
      originalDstPath.forEach( ( p ) =>
      {
        dstPathMap[ p ] = o.dstPath;
        used = true;
      });
    }
    else if( _.mapIs( dstPathMap ) )
    {
      if( o.srcPathMap === null || o.srcPathMap === '' || o.dstPath === '' )
      for( let f in dstPathMap )
      {
        let val = dstPathMap[ f ];
        if( val === null || val === '' )
        {
          dstPathMap[ f ] = o.dstPath;
          used = true;
        }
        else if( _.boolLike( val ) )
        {
          dstPathMap[ f ] = !!val;
        }
      }
      else for( let f in dstPathMap )
      {
        let val = dstPathMap[ f ];
        if( _.boolLike( val ) )
        dstPathMap[ f ] = !!val;
      }

    }

    /* get dstPath from dstPathMap if it has empty key */

    // if( dstPathMap[ '' ] !== undefined && o.srcPathMap !== '' )
    // if( o.dstPath === null || o.dstPath === '' )
    // if( o.dstPath !== dstPathMap[ '' ] )
    // {
    //   o.dstPath = dstPathMap[ '' ];
    //   used = false;
    // }

    if( dstPathMap[ '' ] === '' || dstPathMap[ '' ] === null )
    {
      delete dstPathMap[ '' ];
    }

    _.assert( _.mapIs( dstPathMap ) );
    return [ dstPathMap, used ];
  }

  /* */

  function dstPathMapRemove( dstPathMap, dstPath )
  {
    if( dstPath !== '' && _.mapKeys( dstPathMap ).length === 0 )
    {
      dstPathMap[ '' ] = dstPath;
    }
    else for( let src in dstPathMap )
    {
      dstPathMap[ src ] = dstPath;
      if( src === '' && dstPath === '' )
      delete dstPathMap[ '' ];
    }
  }

  /* */

  function dstPathMapExtend( dstPathMap, srcPathMap, dstPath, wasUsed )
  {
    let used = false;

    if( _.strIs( srcPathMap ) )
    {
      let dst;
      srcPathMap = self.normalize( srcPathMap );
      [ dst, used ] = dstJoin( dstPathMap[ srcPathMap ], dstPath, srcPathMap );
      if( srcPathMap !== '' || dst !== '' )
      dstPathMap[ srcPathMap ] = dst;
    }
    else if( _.mapIs( srcPathMap ) )
    {
      for( let g in srcPathMap )
      {
        let dstPath2 = srcPathMap[ g ];
        let tryingToUse = false;

        dstPath2 = dstPathNormalize( dstPath2 );

        if( ( dstPath2 === null ) || ( dstPath2 === '' ) )
        {
          dstPath2 = dstPath;
          tryingToUse = true;
        }

        if( tryingToUse )
        used = dstPathMapExtend( dstPathMap, g, dstPath2 ) || used;
        else
        dstPathMapExtend( dstPathMap, g, dstPath2 );
      }
    }
    else if( _.arrayLike( srcPathMap ) )
    {
      for( let g = 0 ; g < srcPathMap.length ; g++ )
      {
        let srcPathMap2 = srcPathMap[ g ];
        srcPathMap2 = srcPathMapNormalize( srcPathMap2 );
        used = dstPathMapExtend( dstPathMap, srcPathMap2, dstPath ) || used;
      }
    }
    else _.assert( 0, () => 'Expects srcPathMap, got ' + _.strType( srcPathMap ) );

    return used;
  }

  /* */

  function dstJoin( dst, src, key )
  {
    let used = false;
    let r;

    if( _.boolLike( src ) )
    src = !!src;

    _.assert( dst === undefined || dst === null || _.arrayIs( dst ) || _.strIs( dst ) || _.boolIs( dst ) || _.objectIs( dst ) );
    _.assert( src === null || _.arrayIs( src ) || _.strIs( src ) || _.boolIs( src ) || _.objectIs( src ) );

    if( o.mode === 'replace' )
    {
      if( o.supplementing )
      {
        r = dst;
        if( dst === undefined || dst === null || dst === '' )
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      else
      {
        if( key !== '' )
        used = true;
        r = src;
      }
    }
    else
    {
      r = dst;

      if( dst === undefined || dst === null || dst === '' )
      {
        r = src;
        if( key !== '' )
        used = true;
      }
      else if( src === null || src === '' || _.boolLike( src ) || _.boolLike( dst ) )
      {
        if( o.supplementing )
        {
          r = dst;
        }
        else
        {
          r = src;
          if( key !== '' )
          used = true;
        }
      }
      else
      {
        if( key !== '' )
        used = true;
        if( o.mode === 'append' )
        r = _.scalarAppendOnce( dst, src );
        else
        r = _.scalarPrependOnce( dst, src );
      }

    }

    r = self.simplifyInplace( r );

    return [ r, used ];
  }

}

_mapExtend.defaults =
{
  dstPathMap : null,
  srcPathMap : null,
  dstPath : null,
  mode : 'replace',
  supplementing : 0,
}

/*

qqq : implement _.path.mapSupplement, _.path.mapAppend, _.path.mapPrepend

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : "/dst" };
var dstMap = { "" : "/dst2" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapExtend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : "/dst" };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapSupplement( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : [ "/dst", "/dst2" ] };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapAppend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

test.case = 'dstMap=map with empty src, srcMap=null, dstPath=str';
var expected = { "" : [ "/dst2", "/dst" ] };
var dstMap = { "" : "/dst" };
var srcMap = null;
var dstPath = '/dst2';
var got = path.mapPrepend( dstMap, srcMap, dstPath );
test.identical( got, expected );
test.is( got === dstMap );

*/

//

function mapExtend( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 0,
  });
}

//

/*
qqq : cover routine mapSupplement
*/

function mapSupplement( dstPathMap, srcPathMap, dstPath )
{
  let self = this;
  _.assert( arguments.length === 2 || arguments.length === 3 );
  return self._mapExtend
  ({
    dstPathMap,
    srcPathMap,
    dstPath,
    mode : 'replace',
    supplementing : 1,
  });
}

//

function mapsPair( dstFilePath, srcFilePath )
{
  let self = this;
  // let srcPath1;
  // let srcPath2;
  // let dstPath1;
  // let dstPath2;

  _.assert( srcFilePath !== undefined );
  _.assert( dstFilePath !== undefined );
  _.assert( arguments.length === 2 );

  if( srcFilePath && dstFilePath )
  {

    // srcPath1 = self.mapSrcFromSrc( srcFilePath );
    // srcPath2 = self.mapSrcFromDst( dstFilePath );
    // dstPath1 = self.mapDstFromSrc( srcFilePath );
    // dstPath2 = self.mapDstFromDst( dstFilePath );

    // srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
    // dstPath1 = self.mapDstFromSrc( srcFilePath ).filter( ( e ) => e !== null );
    // dstPath2 = self.mapDstFromDst( dstFilePath ).filter( ( e ) => e !== null );

    if( _.mapIs( srcFilePath ) && _.mapIs( dstFilePath ) )
    {
      mapsVerify();
    }
    else
    {
      srcVerify();
      // dstVerify();
    }

    if( _.mapIs( dstFilePath ) )
    {
      dstFilePath = self.mapExtend( null, dstFilePath, null );
      srcFilePath = dstFilePath = self.mapExtend( dstFilePath, srcFilePath, null );
    }
    else
    {
      srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, dstFilePath );
    }

  }
  else if( srcFilePath )
  {
    if( self.isEmpty( srcFilePath ) )
    srcFilePath = dstFilePath = null;
    else
    srcFilePath = dstFilePath = self.mapExtend( null, srcFilePath, null );
  }
  else if( dstFilePath )
  {
    if( self.isEmpty( dstFilePath ) )
    srcFilePath = dstFilePath = null;
    else if( _.mapIs( dstFilePath ) )
    srcFilePath = dstFilePath = self.mapExtend( null, dstFilePath, null );
    else
    srcFilePath = dstFilePath = self.mapExtend( null, '', dstFilePath ); // yyy
  }
  else
  {
    srcFilePath = dstFilePath = null;
    // srcFilePath = dstFilePath = Object.create( null );
    // srcFilePath[ '.' ] = null;
  }

  return srcFilePath;

  /* */

  function mapsVerify()
  {
    _.assert
    (
      _.mapsAreIdentical( srcFilePath, dstFilePath ),
      () => 'File maps are inconsistent\n' + _.toStr( srcFilePath ) + '\n' + _.toStr( dstFilePath )
    );
  }

  /* */

  function srcVerify()
  {
    if( dstFilePath && srcFilePath && Config.debug )
    {
      let srcPath1 = self.mapSrcFromSrc( srcFilePath ).filter( ( e ) => e !== null );
      let srcPath2 = self.mapSrcFromDst( dstFilePath ).filter( ( e ) => e !== null );
      let srcFilteredPath1 = srcPath1.filter( ( e ) => !_.boolLike( e ) && e !== null );
      let srcFilteredPath2 = srcPath2.filter( ( e ) => !_.boolLike( e ) && e !== null );
      _.assert
      (
        srcFilteredPath1.length === 0 || srcFilteredPath2.length === 0 ||
        self.isEmpty( srcFilteredPath1 ) || self.isEmpty( srcFilteredPath2 ) ||
        _.arraySetIdentical( srcFilteredPath1, srcFilteredPath2 ),
        () => 'Source paths are inconsistent ' + _.toStr( srcFilteredPath1 ) + ' ' + _.toStr( srcFilteredPath2 )
      );
    }
  }

  // /* */
  //
  // function dstVerify()
  // {
  //   if( dstFilePath && srcFilePath && Config.debug )
  //   {
  //     let dstFilteredPath1 = dstPath1.filter( ( e ) => !_.boolLike( e ) && e !== null );
  //     let dstFilteredPath2 = dstPath2.filter( ( e ) => !_.boolLike( e ) && e !== null );
  //     _.assert
  //     (
  //       dstFilteredPath1.length === 0 || dstFilteredPath2.length === 0 ||
  //       _.arraySetIdentical( dstFilteredPath1, [ '.' ] ) || _.arraySetIdentical( dstFilteredPath2, [ '.' ] ) || _.arraySetIdentical( dstFilteredPath1, dstFilteredPath2 ),
  //       () => 'Destination paths are inconsistent ' + _.toStr( dstFilteredPath1 ) + ' ' + _.toStr( dstFilteredPath2 )
  //     );
  //   }
  // }

}

//

/*
qqq : cover routine simplify
qqq : make sure routine simplify does not clone input data if possible to avoid it
Dmytro : covered. Routine create new container every time if src is array with duplicates,
         empty strings, nulls.
*/

function simplify( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  if( _.strIs( src ) )
  return src;

  // qqq
  if( _.boolLike( src ) )
  return !!src;
  // qqq : was missing!

  if( _.arrayIs( src ) )
  {
    let src2 = _.arrayAppendArrayOnce( null, src );
    src2 = src2.filter( ( e ) => e !== null && e !== '' );
    if( src2.length !== src.length )
    src = src2;
    if( src.length === 0 )
    return '';
    else if( src.length === 1 )
    return src[ 0 ]
    else
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  let keys = _.mapKeys( src );
  if( keys.length === 0 )
  return '';

  let vals = _.mapVals( src );
  vals = vals.filter( ( e ) => e !== null && e !== '' );
  if( vals.length === 0 )
  {
    if( keys.length === 1 && keys[ 0 ] === '' )
    return '';
    else if( keys.length === 1 )
    return keys[ 0 ]
    else
    return src;
  }

  for( let k in src )
  {
    src[ k ] = self.simplify( src[ k ] );
  }

  return src;
}

//

/*
qqq : cover routine simplifyInplace
qqq : make sure routine simplifyInplace never clone input data if possible to avoid it
Dmytro : covered, routine not create new container
*/

function simplifyInplace( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( src === null )
  return '';

  // qqq
  if( _.boolLike( src ) )
  return !!src;
  // qqq : was missing!

  if( _.strIs( src ) )
  return src;

  if( _.arrayIs( src ) )
  {
    src = _.arrayRemoveDuplicates( src, ( e ) => e );
    src = _.arrayRemoveElement( src, '', ( e ) => e === null || e === '' );
    return src;
  }

  if( !_.mapIs( src ) )
  return src;

  for( let k in src )
  {
    src[ k ] = self.simplifyInplace( src[ k ] );
  }

  return src;
}

//

/*
qqq : make pathMap*From* optimal and add tests
*/

function mapDstFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  // if( _.strIs( pathMap ) )
  // return [ null ];

  // if( !_.mapIs( pathMap ) ) // yyy
  // return [ null ];

  if( !_.mapIs( pathMap ) )
  if( pathMap === null )
  return [];
  else
  return [ null ];

  let result = _.mapVals( pathMap );

  result = _.filter( result, ( e ) =>
  {
    if( _.arrayIs( e ) )
    return _.unrollFrom( e );
    return e;
  });

  result = _.arrayAppendArrayOnce( null, result );

  return result;
}

//

function mapDstFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  if( pathMap === null )
  return [];
  else
  return _.arrayAsShallowing( pathMap );

  let result = _.mapVals( pathMap );

  result = _.filter( result, ( e ) =>
  {
    if( _.arrayIs( e ) )
    return _.unrollFrom( e );
    return e;
  });

  result = _.arrayAppendArrayOnce( null, result );

  return result;
}

//

function mapSrcFromSrc( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  if( pathMap === null )
  return [];
  else
  return _.arrayAsShallowing( pathMap );

  // if( !_.mapIs( pathMap ) )
  // return _.arrayAs( pathMap );

  pathMap = this.mapExtend( null, pathMap );

  return _.mapKeys( pathMap )
}

//

function mapSrcFromDst( pathMap )
{
  _.assert( arguments.length === 1 );

  if( !_.mapIs( pathMap ) )
  if( pathMap === null )
  return [];
  else
  return [ null ];

  // if( !_.mapIs( pathMap ) )
  // return [];

  return _.mapKeys( pathMap )
}

//

function mapGroupByDst( pathMap )
{
  let path = this;
  let result = Object.create( null );

  _.assert( arguments.length == 1 );
  _.assert( _.mapIs( pathMap ) );

  /* */

  for( let src in pathMap )
  {
    let normalizedSrc = path.fromGlob( src );
    let dst = pathMap[ src ];

    if( _.boolLike( dst ) )
    continue;

    if( _.strIs( dst ) )
    {
      extend( dst, src );
    }
    else
    {
      _.assert( _.arrayIs( dst ) );
      for( var d = 0 ; d < dst.length ; d++ )
      extend( dst[ d ], src );
    }

  }

  /* */

  for( let src in pathMap )
  {
    let dst = pathMap[ src ];

    if( !_.boolLike( dst ) )
    continue;

    for( var dst2 in result )
    {

      for( var src2 in result[ dst2 ]  )
      {
        if( path.isRelative( src ) ^ path.isRelative( src2 ) )
        {
          result[ dst2 ][ src ] = !!dst;
        }
        else
        {
          let srcBase = path.fromGlob( src );
          let srcBase2 = path.fromGlob( src2 );
          if( path.begins( srcBase, srcBase2 ) || path.begins( srcBase2, srcBase ) )
          result[ dst2 ][ src ] = !!dst;
        }
      }

    }

  }

  /* */

  return result;

  /* */

  function extend( dst, src )
  {
    dst = path.normalize( dst );
    result[ dst ] = result[ dst ] || Object.create( null );
    result[ dst ][ src ] = '';
  }

}

//

function areBasePathsEquivalent( basePath1, basePath2 )
{
  let path = this;

  let filePath1 = path.mapSrcFromDst( basePath1 );
  let filePath2 = path.mapSrcFromDst( basePath2 );

  basePath1 = path.mapDstFromDst( basePath1 );
  basePath2 = path.mapDstFromDst( basePath2 );

  if( filePath1.length > 0 && filePath2.length > 0 )
  if( !_.entityIdentical( basePath1, basePath2 ) )
  return false;

  if( !_.entityIdentical( basePath1, basePath2 ) )
  return false;

  return true;
}

// --
// fields
// --

let Fields =
{
}

// --
// routines
// --

let Routines =
{

  // path map

  filterPairs,
  // filterPairsInplace,
  filterInplace,
  filter,
  all,
  any,
  none,

  isEmpty,
  _mapExtend,
  mapExtend,
  mapSupplement,
  mapsPair,

  simplify,
  simplifyInplace,

  mapDstFromSrc,
  mapDstFromDst,
  mapSrcFromSrc,
  mapSrcFromDst,
  mapGroupByDst,

  areBasePathsEquivalent,

}

_.mapSupplement( Self, Fields );
_.mapSupplement( Self, Routines );

// Self.Init();

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
{
  require( './Glob.s' );
}

})();
