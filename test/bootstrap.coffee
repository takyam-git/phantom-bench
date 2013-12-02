global.chai = require('chai')
global.sinon = require('sinon')
global.sinonChai = require('sinon-chai')
global.chai.use(global.sinonChai)
global.assert = global.chai.assert
global._ = require('underscore')