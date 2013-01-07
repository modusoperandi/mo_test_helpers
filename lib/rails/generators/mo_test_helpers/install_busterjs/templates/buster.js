var config = module.exports;
config[ 'My Project' ] = {
  rootPath: '../',
  environment: 'browser', // or 'node'
  libs: [ ],
 
  sources: [
    // Pre settings
    'tests/Helpers/pre.js.coffee',
    // Post settings
    'tests/Helpers/post.js.coffee'
  ],
 
  tests: [
    // Collections
    // 'tests/Specs/App/Collections/.js.coffee',
    // Models
    // 'tests/Specs/App/Models/.js.coffee',
    // Routers
    // 'tests/Specs/App/Routers/.js.coffee',
  ],
 
  // Using with coffeescript
  extensions: [
    require('buster-coffee')
  ]
}