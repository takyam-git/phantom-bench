global.chai = require('chai')
global.sinonChai = require('sinon-chai')
global.chai.use(global.sinonChai)
global.assert = global.chai.assert