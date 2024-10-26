/**
 * @author kevin
 * @version 1.0.0
 * 
 * Rutas de usuario
 * este archivo define las rutas de shopping car
 */

const{Router} = require('express');
const router = Router();

const {ShowCartOrders,GetOrderById,AddOrderToCart} = require('../controllers/shopping.controller')

router.get('/',ShowCartOrders );
router.get('/:id',GetOrderById );
router.post('/',AddOrderToCart)



module.exports = router;
