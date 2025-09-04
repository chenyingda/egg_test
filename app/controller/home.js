const { Controller } = require('egg');

class HomeController extends Controller {
  async index() {
    const { ctx } = this;
    ctx.throw(500)
    ctx.body = 'hi, egg';
  }
}

module.exports = HomeController;
