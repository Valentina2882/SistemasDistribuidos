/**
 * @author kevin
 * @version 1.0.0
 * 
 * Controlador de carrito de compras
 * Este archivo define los controladores de shopping
 */

const { response, request } = require('express');
const { PrismaClient } = require('@prisma/client');
const axios = require('axios');

const prisma = new PrismaClient();

const ShowCartOrders = async (req = request, res = response) => {
    try {
        const ordersResponse = await axios.get('http://localhost:3000/orders'); 
        
        const orders = ordersResponse.data.orders;

        res.json({
            message: "Orders retrieved successfully",
            orders
        });
    } catch (error) {
        console.error('Error fetching orders from orders API:', error.message);
        res.status(500).json({
            message: 'Failed to retrieve orders from orders API'
        });
    }
};
const GetOrderById = async (req = request, res = response) => {
    const { id } = req.params; 
    console.log(id)
    try {
        const orderResponse = await axios.get(`http://localhost:3000/orders/${id}`); 
        
        const order = orderResponse.data.order; 

        res.json({
            message: "Order retrieved successfully",
            order
        });
    } catch (error) {
        console.error('Error fetching order by ID from orders API:', error.message);
        res.status(500).json({
            message: 'Failed to retrieve order from orders API'
        });
    }
};
const AddOrderToCart = async (req = request, res = response) => {
    const { cartId, orderId } = req.body;

    try {
        let cart = await prisma.cart.findUnique({
            where: { id: Number(cartId) },
            include: { orders: true }
        });

        if (!cart) {
            cart = await prisma.cart.create({
                data: {
                    orders: {
                        connect: { id: orderId }  
                    }
                },
                include: { orders: true } 
            });

            return res.json({
                message: `New shopping cart created with ID ${cart.id} and order added successfully`,
                cart
            });
        }

        const updatedCart = await prisma.cart.update({
            where: { id: Number(cartId) },
            data: {
                orders: {
                    connect: { id: orderId }
                }
            },
            include: { orders: true }
        });

        res.json({
            message: `Order added to existing cart with ID ${cartId} successfully`,
            cart: updatedCart
        });
    } catch (error) {
        console.error('Error adding order to cart:', error.message);
        res.status(500).json({
            message: 'Failed to add order to cart',
            error: error.message
        });
    } finally {
        await prisma.$disconnect();
    }
};
//no funcional aun



module.exports = {
    ShowCartOrders,
    GetOrderById, 
    AddOrderToCart
};

