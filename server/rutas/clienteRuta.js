const express = require('express');
const clienteModelo = require('../modelos/clienteModelo');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-clientes',
    async (req, res) => {
        try{
            const registrosClientes = await mysqlSequelize.query('call obtener_clientes()');
            res.status(200).json(registrosClientes);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-cliente',
    async (req, res) =>{
        try{
            const {
                DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                DIRECCION,
                CIUDAD,
                REFERENCIA
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_CLIENTE(:DNI, :NOMBRES, :EMAIL, :CONTACTO, :FECHA_NACIMIENTO, :GENERO, :DIRECCION, :CIUDAD, :REFERENCIA)',
                {
                    replacements:{
                        DNI,
                        NOMBRES,
                        EMAIL,
                        CONTACTO,
                        FECHA_NACIMIENTO,
                        GENERO,
                        DIRECCION,
                        CIUDAD,
                        REFERENCIA
                    }
                }
            );
            res.status(200).json({Message: `Insercción valida`});
        }catch(error){
            res.status(500).json({message: `Insercción invalida ${error.message}`});
        }
    }
);

module.exports = ruta;

// Insertar registros
ruta.post(
    '/actualizar-cliente',
    async (req, res) =>{
        try{
            const {
                DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                DIRECCION,
                CIUDAD,
                REFERENCIA
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_CLIENTE(:DNI, :NOMBRES, :EMAIL, :CONTACTO, :FECHA_NACIMIENTO, :GENERO, :DIRECCION, :CIUDAD, :REFERENCIA)',
                {
                    replacements:{
                        DNI,
                        NOMBRES,
                        EMAIL,
                        CONTACTO,
                        FECHA_NACIMIENTO,
                        GENERO,
                        DIRECCION,
                        CIUDAD,
                        REFERENCIA
                    }
                }
            );
            res.status(200).json({Message: `Insercción valida`});
        }catch(error){
            res.status(500).json({message: `Insercción invalida ${error.message}`});
        }
    }
);

module.exports = ruta;
