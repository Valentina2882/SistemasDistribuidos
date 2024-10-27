/**
 * @author 
 * @version 1.0.0
 * 
 * Controlador de pagos
 * Este archivo define los controladores de payments
 */

const { response, request } = require('express');
const { PrismaClient } = require('@prisma/client'); 
const { Encrypt, Decrypt } = require('../middlewares/validate');
const { CreateJWT } = require('../middlewares/jwt');

const prisma = new PrismaClient();

const processPayment = async (req = request, res = response) => {
    try {
        let { amount, method } = req.body;

        const encryptMethod = Encrypt(method);

        const payment = await prisma.payments.create({
            data: {
                amount: amount,
                method: encryptMethod,
                status: 'processed',
            }
        });

        const token = CreateJWT ({
            paymentId: payment.id,
            status: payment.status,
            amount: payment.amount
        })

        res.json({
            message: 'Payment processed successfully.',
            payment,
            token
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    } finally {
        await prisma.$disconnect();
    }
};

const showPayments = async (req = request, res = response) => {
    try {
        const payments = await prisma.payments.findMany();

        const decryptPayments = payments.map(payment => ({
            id: payment.id,
            amount: payment.amount,
            method: Decrypt(payment.method),
            status: payment.status
        }));

        res.json({ payments: decryptPayments });
    } catch (error) {
        res.status(500).json({ message: error.message });
    } finally {
        await prisma.$disconnect();
    }
};

module.exports = {
    processPayment,
    showPayments
};
