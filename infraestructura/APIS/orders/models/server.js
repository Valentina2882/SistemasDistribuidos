/**
 * @author kevin
 * @version 1.0.0
 * 
 * Server from express
 * esta clase llama a los metodos necesarios para instanciar orders
 */

const express = require('express');
const cors = require('cors')

class Server{
    //manejar puerto 3100: aumentar 100 por cada uno
    constructor(){
        this.app = express ();
        this.port = 3100;
        this.path = '/api/';
        this.middlewares();
        this.routes();


    }

    middlewares(){
        this.app.use(cors());
        this.app.use(express.json());
    }

    routes(){
        this.app.use('/orders', require('../routes/orders.routes'))
    }

    listen(){
        this.app.listen(this.port, () =>{
            console.log('Servidor funcionando en el puerto',this.port);
        });
    }
}

module.exports = Server;