import sirv from 'sirv';
import polka from 'polka';
import compression from 'compression';
import * as sapper from '../__sapper__/server.js';

const { PORT=3000, NODE_ENV='development' } = process.env;
const dev = NODE_ENV === 'development';

polka() // You can also use Express
	.use(
		compression({ threshold: 0 }),
		sirv('data'), // where geographies live
		sirv('static'),
		sapper.middleware(),
	)
	.listen(process.env.PORT)
	.catch(err => {
		console.log('error', err);
	})
