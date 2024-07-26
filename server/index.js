// Importar los módulo
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mysqlSequelize = require('./database/conexionDb');
const rutaCliente = require('./rutas/clienteRuta');
const rutaVeterinario = require('./rutas/veterinarioRuta');
const rutaProveedor = require('./rutas/proveedorRuta');
const rutaCategoria = require('./rutas/categoriaRuta');
const rutaServicio = require('./rutas/servicioRuta');
const rutaMascota = require('./rutas/mascotaRuta');

const app = express();
const puerto = 3900;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

app.use('/clientes', rutaCliente);
app.use('/veterinarios', rutaVeterinario);
app.use('/proveedores', rutaProveedor);
app.use('/categorias', rutaCategoria);
app.use('/servicios', rutaServicio);
app.use('/macotas', rutaMascota);

mysqlSequelize.sync().then(
    ()=>{
        app.listen(puerto, ()=>{
            console.log("Servidor inicializado en el puerto 3900");
        })
    }
).catch(
    (error)=>{
        console.log("No hay conexión con el servidor");
    }
);